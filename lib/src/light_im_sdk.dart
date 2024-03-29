import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cross_file/cross_file.dart';
import 'package:mime/mime.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'http/http.dart';
import 'listener/listener.dart';
import 'model/model.dart';
import 'packet/packet.dart';
import 'types/types.dart';

class LightIMSDK {
  static late WebSocketChannel _conn;
  static late StreamSubscription<dynamic> _stream;
  static StreamController? _streamController;
  static late Timer _pingTimer;
  static Timer? _reconnectTimer;
  static final Map<String, LightIMSDKListener> _lightIMSDKListener = {};

  static final List<LimConversation> _conversationList = [];
  static final Map<String, List<LimMessage>> _messageMap = {};
  static final Map<String, LimUserInfo> _userInfoMap = {};

  static late String _userId;
  static late String _token;
  static late String _endpoint;
  static late bool _tls;

  static void init({
    required String endpoint,
    bool tls = false,
    LightIMSDKListener? listener,
  }) {
    _endpoint = endpoint;
    _tls = tls;
    if (listener != null) {
      final uuid = const Uuid().v4();
      _lightIMSDKListener[uuid] = listener;
    }

    LightIMSDKHttp.init(
      baseUrl: tls ? 'https://$endpoint' : 'http://$endpoint',
    );
  }

  static void _dispose() {
    _pingTimer.cancel();
    _conn.sink.close();
    _stream.cancel();
    _lightIMSDKListener.clear();
    _conversationList.clear();
    _messageMap.clear();
    _userInfoMap.clear();
  }

  static Future<bool> login({
    required String userId,
    required String token,
  }) async {
    _userId = userId;
    _token = token;

    _streamController = StreamController.broadcast();
    _conn = WebSocketChannel.connect(
      Uri.parse(
        _tls ? 'wss://$_endpoint/websocket' : 'ws://$_endpoint/websocket',
      ),
    );
    if (_reconnectTimer != null) {
      _reconnectTimer?.cancel();
      _reconnectTimer = null;
    }

    _stream = _conn.stream.listen(
      _onData,
      onError: _onError,
      onDone: _onDone,
      cancelOnError: false,
    );

    final data = AuthPktDataModel(
      userId: userId,
      token: token,
    );
    _sendPacket(data);

    final retPkt = await _streamController!.stream.first;
    if (retPkt.type != PacketType.pass) {
      return false;
    }
    if ((retPkt.data as PassPktDataModel).code != 0) {
      return false;
    }

    _streamController?.close();
    _streamController = null;
    _pingTimer = Timer.periodic(
      const Duration(seconds: 10),
      _sendPingPacket,
    );
    LightIMSDKHttp.auth(userId: userId, token: token);

    final conversationList = await pullConversation();
    if (conversationList == null) return true;
    conversationList.sort((a, b) => b.createAt - a.createAt);
    _conversationList.addAll(conversationList);

    return true;
  }

  /// 退出登录
  static Future<ResponseModel<ConnectLogoutResModel?>?> logout() async {
    final res = await LightIMSDKHttp.logout();
    if (!LightIMSDKHttp.checkRes(res)) return res;

    _dispose();

    return res;
  }

  static void addListener(LightIMSDKListener listener) {
    final uuid = const Uuid().v4();
    _lightIMSDKListener[uuid] = listener;
  }

  /// 上传文件
  static Future<String?> _fileUpload({
    required XFile file,
    required String contentType,
  }) async {
    final res1 = await LightIMSDKHttp.filePresignPutURL(
      name: file.name,
      size: await file.length(),
      contentType: contentType,
    );
    if (!LightIMSDKHttp.checkRes(res1)) return null;

    final res1Data = res1!.data!;
    final res2 = await LightIMSDKHttp.filePresignPut(
      url: res1Data.url,
      file: file,
      contentType: contentType,
    );
    if (res2 != true) return null;

    return res1Data.key;
  }

  /// 删除会话
  static Future<ResponseModel<ConversationDeleteResModel?>?>
      deleteConversation({
    required String conversationId,
  }) async {
    return await LightIMSDKHttp.deleteConversation(
      conversationId: conversationId,
    );
  }

  /// 获取会话信息
  static Future<LimConversation?> detailConversation({
    required String conversationId,
  }) async {
    final res =
        await LightIMSDKHttp.detailConversation(conversationId: conversationId);
    if (!LightIMSDKHttp.checkRes(res)) return null;

    final e = res!.data!.lastMessage;
    return LimConversation(
      userId: res.data!.userId,
      groupId: res.data!.groupId,
      conversationId: res.data!.conversationId,
      nickname: res.data!.name,
      avatar: res.data!.avatar,
      unread: 0,
      createAt: 0,
      lastMessage: e == null
          ? null
          : LimMessage(
              senderId: e.senderId,
              receiverId: e.receiverId,
              userId: e.userId,
              avatar: '',
              conversationId: e.conversationId,
              isSelf: e.isSelf,
              nickname: '',
              seq: e.sequence,
              timestamp: e.timestamp,
              type: e.type,
              isRead: e.isRead,
              isPeerRead: false,
              createAt: e.createAt,
              text: e.text == null
                  ? null
                  : LimTextElem(
                      text: e.text!.text,
                    ),
              image: e.image == null
                  ? null
                  : LimImageElem(
                      contentType: e.image!.contentType,
                      name: e.image!.name,
                      size: e.image!.size,
                      url: e.image!.url,
                      thumbnailUrl: e.image!.thumbnailUrl,
                    ),
              audio: e.audio == null
                  ? null
                  : LimAudioElem(
                      contentType: e.audio!.contentType,
                      duration: e.audio!.duration,
                      name: e.audio!.name,
                      size: e.audio!.size,
                      url: e.audio!.url,
                    ),
              video: e.video == null
                  ? null
                  : LimVideoElem(
                      contentType: e.video!.contentType,
                      duration: e.video!.duration,
                      name: e.video!.name,
                      size: e.video!.size,
                      url: e.video!.url,
                      thumbnailUrl: e.video!.thumbnailUrl,
                    ),
              file: e.file == null
                  ? null
                  : LimFileElem(
                      contentType: e.file!.contentType,
                      name: e.file!.name,
                      size: e.file!.size,
                      url: e.file!.url,
                    ),
              custom: e.custom == null
                  ? null
                  : LimCustomElem(
                      content: e.custom!.content,
                    ),
              record: e.record == null
                  ? null
                  : LimRecordElem(
                      contentType: e.record!.contentType,
                      duration: e.record!.duration,
                      size: e.record!.size,
                      url: e.record!.url,
                    ),
            ),
    );
  }

  /// 获取会话列表
  static Future<List<LimConversation>?> pullConversation() async {
    final res = await LightIMSDKHttp.pullConversation();
    if (!LightIMSDKHttp.checkRes(res)) {
      return null;
    }

    final data = res!.data!;
    final ret = <LimConversation>[];
    for (var item in data.items) {
      final e = item.lastMessage;
      final lastMessage = e == null
          ? null
          : LimMessage(
              senderId: e.senderId,
              receiverId: e.receiverId,
              userId: e.userId,
              avatar: '',
              conversationId: e.conversationId,
              isSelf: e.isSelf,
              nickname: '',
              seq: e.sequence,
              timestamp: e.timestamp,
              type: e.type,
              isRead: e.isRead,
              isPeerRead: false,
              createAt: e.createAt,
              text: e.text == null
                  ? null
                  : LimTextElem(
                      text: e.text!.text,
                    ),
              image: e.image == null
                  ? null
                  : LimImageElem(
                      contentType: e.image!.contentType,
                      name: e.image!.name,
                      size: e.image!.size,
                      url: e.image!.url,
                      thumbnailUrl: e.image!.thumbnailUrl,
                    ),
              audio: e.audio == null
                  ? null
                  : LimAudioElem(
                      contentType: e.audio!.contentType,
                      duration: e.audio!.duration,
                      name: e.audio!.name,
                      size: e.audio!.size,
                      url: e.audio!.url,
                    ),
              video: e.video == null
                  ? null
                  : LimVideoElem(
                      contentType: e.video!.contentType,
                      duration: e.video!.duration,
                      name: e.video!.name,
                      size: e.video!.size,
                      url: e.video!.url,
                      thumbnailUrl: e.video!.thumbnailUrl,
                    ),
              file: e.file == null
                  ? null
                  : LimFileElem(
                      contentType: e.file!.contentType,
                      name: e.file!.name,
                      size: e.file!.size,
                      url: e.file!.url,
                    ),
              custom: e.custom == null
                  ? null
                  : LimCustomElem(
                      content: e.custom!.content,
                    ),
              record: e.record == null
                  ? null
                  : LimRecordElem(
                      contentType: e.record!.contentType,
                      duration: e.record!.duration,
                      size: e.record!.size,
                      url: e.record!.url,
                    ),
            );
      final conv = LimConversation(
        userId: item.userId,
        groupId: item.groupId,
        conversationId: item.conversationId,
        nickname: item.name,
        avatar: item.avatar,
        unread: item.unreadCount,
        createAt: e?.createAt ?? 0,
        lastMessage: lastMessage,
      );

      ret.add(conv);
    }

    return ret;
  }

  /// 发送消息
  static Future<ResponseModel<MessageSendResModel?>?> sendMessage({
    required String conversationId,
    required LimMessageType type,
    TextElemReqModel? text,
    ImageElemReqModel? image,
    AudioElemReqModel? audio,
    VideoElemReqModel? video,
    FileElemReqModel? file,
    CustomElemReqModel? custom,
    RecordElemReqModel? record,
  }) async {
    String? userId;
    String? groupId;
    if (conversationId.startsWith('c_')) {
      final sub = conversationId.substring(2);
      final strs = sub.split('_');
      if (strs.first == _userId) {
        userId = strs.last;
      } else {
        userId = strs.first;
      }
    } else {
      groupId = conversationId.substring(2);
    }

    return await LightIMSDKHttp.sendMessage(
      userId: userId,
      groupId: groupId,
      type: type.index,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      text: text,
      image: image,
      audio: audio,
      video: video,
      file: file,
      custom: custom,
      record: record,
    );
  }

  /// 发送文本消息
  static Future<ResponseModel<MessageSendResModel?>?> sendTextMessage({
    required String conversationId,
    required String text,
  }) async {
    return await sendMessage(
      conversationId: conversationId,
      type: LimMessageType.text,
      text: TextElemReqModel(text: text),
    );
  }

  /// 发送图片消息
  static Future<ResponseModel<MessageSendResModel?>?> sendImageMessage({
    required String conversationId,
    required XFile file,
    required XFile thumbnailFile,
  }) async {
    final res = await _fileUpload(
      file: file,
      contentType: file.mimeType ?? lookupMimeType(file.name)!,
    );
    if (res == null) return null;

    String? res1 = '';
    if (thumbnailFile.path.isNotEmpty) {
      res1 = await _fileUpload(
        file: thumbnailFile,
        contentType:
            thumbnailFile.mimeType ?? lookupMimeType(thumbnailFile.name)!,
      );
      if (res1 == null) return null;
    }

    return await sendMessage(
      conversationId: conversationId,
      type: LimMessageType.image,
      image: ImageElemReqModel(
        contentType: file.mimeType ?? lookupMimeType(file.name)!,
        name: file.name,
        size: await file.length(),
        url: res,
        thumbnailUrl: res1,
      ),
    );
  }

  /// 发送语音消息
  static Future<ResponseModel<MessageSendResModel?>?> sendAudioMessage({
    required String conversationId,
    required XFile file,
  }) async {
    final res = await _fileUpload(
        file: file, contentType: file.mimeType ?? lookupMimeType(file.name)!);
    if (res == null) return null;

    return await sendMessage(
      conversationId: conversationId,
      type: LimMessageType.audio,
      audio: AudioElemReqModel(
        contentType: file.mimeType ?? lookupMimeType(file.name)!,
        duration: 0,
        name: file.name,
        size: await file.length(),
        url: res,
      ),
    );
  }

  /// 发送语音消息
  static Future<ResponseModel<MessageSendResModel?>?> sendVideoMessage({
    required String conversationId,
    required XFile file,
    required XFile thumbnailFile,
  }) async {
    final res = await _fileUpload(
      file: file,
      contentType: file.mimeType ?? lookupMimeType(file.name)!,
    );
    if (res == null) return null;

    String? res1 = '';
    if (thumbnailFile.path.isNotEmpty) {
      res1 = await _fileUpload(
        file: thumbnailFile,
        contentType:
            thumbnailFile.mimeType ?? lookupMimeType(thumbnailFile.name)!,
      );
      if (res1 == null) return null;
    }

    return await sendMessage(
      conversationId: conversationId,
      type: LimMessageType.video,
      video: VideoElemReqModel(
        contentType: file.mimeType ?? lookupMimeType(file.name)!,
        duration: 0,
        name: file.name,
        size: await file.length(),
        url: res,
        thumbnailUrl: res1,
      ),
    );
  }

  /// 发送文件消息
  static Future<ResponseModel<MessageSendResModel?>?> sendFileMessage({
    required String conversationId,
    required XFile file,
  }) async {
    final res = await _fileUpload(
        file: file, contentType: file.mimeType ?? lookupMimeType(file.name)!);
    if (res == null) return null;

    return await sendMessage(
      conversationId: conversationId,
      type: LimMessageType.file,
      file: FileElemReqModel(
        contentType: file.mimeType ?? lookupMimeType(file.name)!,
        name: file.name,
        size: await file.length(),
        url: res,
      ),
    );
  }

  /// 发送自定义消息
  static Future<ResponseModel<MessageSendResModel?>?> sendCustomMessage({
    required String conversationId,
    required String custom,
  }) async {
    return await sendMessage(
      conversationId: conversationId,
      type: LimMessageType.custom,
      custom: CustomElemReqModel(content: custom),
    );
  }

  /// 发送语音消息
  static Future<ResponseModel<MessageSendResModel?>?> sendRecordMessage({
    required String conversationId,
    required XFile file,
    required int duration,
  }) async {
    final res = await _fileUpload(
        file: file, contentType: file.mimeType ?? lookupMimeType(file.name)!);
    if (res == null) return null;

    return await sendMessage(
      conversationId: conversationId,
      type: LimMessageType.record,
      record: RecordElemReqModel(
        contentType: file.mimeType ?? lookupMimeType(file.name)!,
        duration: duration,
        size: await file.length(),
        url: res,
      ),
    );
  }

  /// 已读消息
  static Future<ResponseModel<MessageMarkResModel?>?> markMessage({
    required String conversationId,
    required int sequence,
  }) async {
    return await LightIMSDKHttp.markMessage(
      conversationId: conversationId,
      sequence: sequence,
    );
  }

  /// 获取已读数量
  static Future<ResponseModel<MessageUnreadResModel?>?> unreadMessage() async {
    return await LightIMSDKHttp.unreadMessage();
  }

  /// 获取历史消息
  static Future<LimMessagePull?> pullMessage({
    required String conversationId,
    required int sequence,
    required int size,
  }) async {
    final res = await LightIMSDKHttp.pullMessage(
      conversationId: conversationId,
      sequence: sequence,
      size: size,
    );
    if (!LightIMSDKHttp.checkRes(res)) {
      return null;
    }

    final data = res!.data!;
    final items = <LimMessage>[];
    for (var e in data.items) {
      final limUserInfo = await _getUserInfo(e.senderId);
      final limMessage = LimMessage(
        senderId: e.senderId,
        receiverId: e.receiverId,
        userId: e.userId,
        avatar: limUserInfo!.avatar,
        conversationId: e.conversationId,
        isSelf: e.isSelf,
        nickname: limUserInfo.nickname,
        seq: e.sequence,
        timestamp: e.timestamp,
        type: e.type,
        isRead: e.isRead,
        isPeerRead: false,
        createAt: e.createAt,
        text: e.text == null
            ? null
            : LimTextElem(
                text: e.text!.text,
              ),
        image: e.image == null
            ? null
            : LimImageElem(
                contentType: e.image!.contentType,
                name: e.image!.name,
                size: e.image!.size,
                url: e.image!.url,
                thumbnailUrl: e.image!.thumbnailUrl,
              ),
        audio: e.audio == null
            ? null
            : LimAudioElem(
                contentType: e.audio!.contentType,
                duration: e.audio!.duration,
                name: e.audio!.name,
                size: e.audio!.size,
                url: e.audio!.url,
              ),
        video: e.video == null
            ? null
            : LimVideoElem(
                contentType: e.video!.contentType,
                duration: e.video!.duration,
                name: e.video!.name,
                size: e.video!.size,
                url: e.video!.url,
                thumbnailUrl: e.video!.thumbnailUrl,
              ),
        file: e.file == null
            ? null
            : LimFileElem(
                contentType: e.file!.contentType,
                name: e.file!.name,
                size: e.file!.size,
                url: e.file!.url,
              ),
        custom: e.custom == null
            ? null
            : LimCustomElem(
                content: e.custom!.content,
              ),
        record: e.record == null
            ? null
            : LimRecordElem(
                contentType: e.record!.contentType,
                duration: e.record!.duration,
                size: e.record!.size,
                url: e.record!.url,
              ),
      );

      items.add(limMessage);
    }

    return LimMessagePull(
      isEnd: data.isEnd,
      items: items,
      sequence: data.sequence,
    );
  }

  static Future<int?> getUnreadCount() async {
    return _getUnreadCount();
  }

  static int _getUnreadCount() {
    int count = 0;
    for (var e in _conversationList) {
      count += e.unread;
    }

    return count;
  }

  static void _sendPingPacket(Timer _) {
    final data = PingPktDataModel();
    _sendPacket(data);
  }

  static void _sendPacket(PacketDataModel data) {
    late final int type;
    if (data is PingPktDataModel) {
      type = PacketType.ping;
    } else if (data is AuthPktDataModel) {
      type = PacketType.auth;
    } else {
      return;
    }

    final packet = Packet(type: type, data: data);
    _conn.sink.add(packet.toJson());
  }

  static Future<LimUserInfo?> getUserInfo(String userId) async {
    return await _getUserInfo(userId);
  }

  static Future<LimUserInfo?> getSelfUserInfo() async {
    return await _getUserInfo(_userId);
  }

  static Future<LimUserInfo?> _getUserInfo(String userId) async {
    final limUserInfo = _userInfoMap[userId];
    if (limUserInfo != null) {
      return limUserInfo;
    }

    final res = await LightIMSDKHttp.profileUser(userId: userId);
    if (!LightIMSDKHttp.checkRes(res)) {
      return null;
    }

    final data = res!.data!;
    final tmp = LimUserInfo(
      userId: data.userId,
      nickname: data.nickname,
      avatar: data.avatar,
    );
    _userInfoMap[userId] = tmp;

    return tmp;
  }

  static void _onData(dynamic data) async {
    final packet = Packet.fromMap(jsonDecode(data));
    _streamController?.sink.add(packet);

    switch (packet.type) {
      case PacketType.pong:
        break;
      case PacketType.message:
        final pktData = (packet.data as MessagePktDataModel);
        final senderLimUserInfo = await _getUserInfo(pktData.senderId);

        final limMessage = LimMessage(
          senderId: pktData.senderId,
          receiverId: pktData.receiverId,
          userId: pktData.userId,
          avatar: senderLimUserInfo!.avatar,
          conversationId: pktData.conversationId,
          isSelf: pktData.isSelf,
          nickname: senderLimUserInfo.nickname,
          seq: pktData.seq,
          timestamp: pktData.timestamp,
          type: pktData.type,
          isRead: pktData.isRead,
          isPeerRead: pktData.isPeerRead,
          createAt: pktData.createAt,
          text: pktData.text == null
              ? null
              : LimTextElem(
                  text: pktData.text!.text,
                ),
          image: pktData.image == null
              ? null
              : LimImageElem(
                  contentType: pktData.image!.contentType,
                  name: pktData.image!.name,
                  size: pktData.image!.size,
                  url: pktData.image!.url,
                  thumbnailUrl: pktData.image!.thumbnailUrl,
                ),
          audio: pktData.audio == null
              ? null
              : LimAudioElem(
                  contentType: pktData.audio!.contentType,
                  duration: pktData.audio!.duration,
                  name: pktData.audio!.name,
                  size: pktData.audio!.size,
                  url: pktData.audio!.url,
                ),
          video: pktData.video == null
              ? null
              : LimVideoElem(
                  contentType: pktData.video!.contentType,
                  duration: pktData.video!.duration,
                  name: pktData.video!.name,
                  size: pktData.video!.size,
                  url: pktData.video!.url,
                  thumbnailUrl: pktData.video!.thumbnailUrl,
                ),
          file: pktData.file == null
              ? null
              : LimFileElem(
                  contentType: pktData.file!.contentType,
                  name: pktData.file!.name,
                  size: pktData.file!.size,
                  url: pktData.file!.url,
                ),
          custom: pktData.custom == null
              ? null
              : LimCustomElem(
                  content: pktData.custom!.content,
                ),
          record: pktData.record == null
              ? null
              : LimRecordElem(
                  contentType: pktData.record!.contentType,
                  duration: pktData.record!.duration,
                  size: pktData.record!.size,
                  url: pktData.record!.url,
                ),
        );
        final oldLimConversationIndex = _conversationList.indexWhere(
          (e) => e.conversationId == limMessage.conversationId,
        );
        int unread = 1;
        if (oldLimConversationIndex > -1) {
          unread += _conversationList[oldLimConversationIndex].unread;
        }

        final userLimUserInfo = await _getUserInfo(
          pktData.isSelf ? pktData.receiverId : pktData.senderId,
        );
        final limConversation = LimConversation(
          userId: pktData.isSelf ? limMessage.receiverId : limMessage.senderId,
          conversationId: limMessage.conversationId,
          nickname: userLimUserInfo!.nickname,
          avatar: userLimUserInfo.avatar,
          unread: unread,
          createAt: limMessage.createAt,
          lastMessage: limMessage,
          groupId: limMessage.groupId,
        );
        if (oldLimConversationIndex > -1) {
          _conversationList.removeAt(oldLimConversationIndex);
        }
        _conversationList.insert(0, limConversation);
        if (!_messageMap.containsKey(limMessage.conversationId)) {
          _messageMap[limMessage.conversationId] = [];
        }
        _messageMap[limMessage.conversationId]!.add(limMessage);

        _lightIMSDKListener.values.toList().forEach((e) {
          if (unread == 1) e.onOpenNewConversation?.call(limConversation);
          e.onReceiveNewMessage?.call((limMessage));
          e.onUnreadCountChange?.call(_getUnreadCount());
        });
        break;
      default:
    }
  }

  static void _onError(Object error, StackTrace stackTrace) {
    final e = error as WebSocketChannelException;
    log(e.message ?? '');

    _pingTimer.cancel();
    _stream.cancel();
  }

  static void _onDone() {
    reconnect();
  }

  static void reconnect() async {
    _reconnectTimer = Timer.periodic(
      const Duration(seconds: 3),
      (timer) {
        login(userId: _userId, token: _token);
      },
    );
  }
}
