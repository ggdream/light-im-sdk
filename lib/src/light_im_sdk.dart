import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cross_file/cross_file.dart';
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
    required LightIMSDKListener listener,
  }) {
    _endpoint = endpoint;
    _tls = tls;
    final uuid = const Uuid().v4();
    _lightIMSDKListener[uuid] = listener;

    LightIMSDKHttp.init(
        baseUrl: tls ? 'https://$endpoint' : 'http://$endpoint');
  }

  static void _dispose() {
    _conversationList.clear();
    _messageMap.clear();
    _userInfoMap.clear();
    _pingTimer.cancel();
    _stream.cancel();
    _conn.sink.close();
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
        _tls ? 'wss://$_endpoint/connect/im' : 'ws://$_endpoint/connect/im',
      ),
    );
    _stream = _conn.stream.listen(
      _onData,
      onError: _onError,
      onDone: _onDone,
      cancelOnError: true,
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
    final res = await LightIMSDK.logout();
    if (!LightIMSDKHttp.checkRes(res)) return res;

    _dispose();

    return res;
  }

  /// 上传文件
  static Future<String?> _fileUpload({
    required XFile file,
    required String contentType,
  }) async {
    final res1 = await LightIMSDKHttp.filePresignPutURL(
      contentType: contentType,
    );
    if (!LightIMSDKHttp.checkRes(res1)) return null;

    final res1Data = res1!.data!;
    final res2 = await LightIMSDKHttp.filePresignPut(
      url: res1Data.presignUrl,
      file: file,
      contentType: contentType,
    );
    if (res2 != true) return null;

    return res1Data.url;
  }

  /// 删除会话
  static Future<ResponseModel<ConversationDeleteResModel?>?>
      deleteConversation({
    required String userId,
  }) async {
    return await LightIMSDKHttp.deleteConversation(userId: userId);
  }

  /// 获取会话信息
  static Future<LimConversation?> detailConversation({
    required String userId,
  }) async {
    final res = await LightIMSDKHttp.detailConversation(userId: userId);
    if (!LightIMSDKHttp.checkRes(res)) return null;

    return LimConversation(
      userId: userId,
      conversationId: res!.data!.conversationId,
      nickname: res.data!.nickname,
      avatar: res.data!.avatar,
      unread: 0,
      createAt: 0,
      lastMessage: LimMessage(
        senderId: '',
        receiverId: '',
        userId: '',
        avatar: '',
        conversationId: '',
        isSelf: false,
        nickname: '',
        seq: 0,
        timestamp: 0,
        type: 0,
        isRead: false,
        isPeerRead: false,
        createAt: 0,
        text: '',
        image: '',
        audio: '',
        video: '',
        custom: '',
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
    for (var e in data.items) {
      final limUserInfo = await _getUserInfo(e.userId);
      final lastMessage = LimMessage(
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
        text: e.text,
        image: e.image,
        audio: e.audio,
        video: e.video,
        custom: e.custom,
      );
      final conv = LimConversation(
        userId: e.userId,
        conversationId: e.conversationId,
        nickname: lastMessage.nickname,
        avatar: lastMessage.avatar,
        unread: e.unread,
        createAt: e.createAt,
        lastMessage: lastMessage,
      );

      ret.add(conv);
    }

    return ret;
  }

  /// 发送消息
  static Future<ResponseModel<MessageSendResModel?>?> sendMessage({
    required String userId,
    required LimMessageType type,
    String? text,
    String? image,
    String? audio,
    String? video,
    String? custom,
  }) async {
    return await LightIMSDKHttp.sendMessage(
      userId: userId,
      type: type.index,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      text: text,
      image: image,
      audio: audio,
      video: video,
      custom: custom,
    );
  }

  /// 发送文本消息
  static Future<ResponseModel<MessageSendResModel?>?> sendTextMessage({
    required String userId,
    required String text,
  }) async {
    return await sendMessage(
      userId: userId,
      type: LimMessageType.text,
      text: text,
    );
  }

  /// 发送图片消息
  static Future<ResponseModel<MessageSendResModel?>?> sendImageMessage({
    required String userId,
    required XFile file,
  }) async {
    final res = await _fileUpload(file: file, contentType: file.mimeType!);
    if (res == null) return null;

    return await sendMessage(
      userId: userId,
      type: LimMessageType.image,
      image: res,
    );
  }

  /// 发送语音消息
  static Future<ResponseModel<MessageSendResModel?>?> sendAudioMessage({
    required String userId,
    required XFile file,
  }) async {
    final res = await _fileUpload(file: file, contentType: file.mimeType!);
    if (res == null) return null;

    return await sendMessage(
      userId: userId,
      type: LimMessageType.audio,
      audio: res,
    );
  }

  /// 发送语音消息
  static Future<ResponseModel<MessageSendResModel?>?> sendVideoMessage({
    required String userId,
    required XFile file,
  }) async {
    final res = await _fileUpload(file: file, contentType: file.mimeType!);
    if (res == null) return null;

    return await sendMessage(
      userId: userId,
      type: LimMessageType.video,
      video: res,
    );
  }

  /// 发送自定义消息
  static Future<ResponseModel<MessageSendResModel?>?> sendCustomMessage({
    required String userId,
    required String custom,
  }) async {
    return await sendMessage(
      userId: userId,
      type: LimMessageType.custom,
      custom: custom,
    );
  }

  /// 已读消息
  static Future<ResponseModel<MessageMarkResModel?>?> markMessage({
    required String userId,
    required int sequence,
  }) async {
    return await LightIMSDKHttp.markMessage(
      userId: userId,
      sequence: sequence,
    );
  }

  /// 获取已读数量
  static Future<ResponseModel<MessageUnreadResModel?>?> unreadMessage() async {
    return await LightIMSDKHttp.unreadMessage();
  }

  /// 获取历史消息
  static Future<LimMessagePull?> pullMessage({
    required String userId,
    required int sequence,
  }) async {
    final res = await LightIMSDKHttp.pullMessage(
      userId: userId,
      sequence: sequence,
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
        text: e.text,
        image: e.image,
        audio: e.audio,
        video: e.video,
        custom: e.custom,
      );

      items.add(limMessage);
    }

    return LimMessagePull(
      isEnd: data.isEnd,
      items: items,
      sequence: data.sequence,
    );
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
          text: pktData.text,
          image: pktData.image,
          audio: pktData.audio,
          video: pktData.video,
          custom: pktData.custom,
        );
        final oldLimConversationIndex = _conversationList.indexWhere(
          (e) => e.conversationId == limMessage.conversationId,
        );
        int unread = 1;
        if (oldLimConversationIndex > -1) {
          unread += _conversationList[oldLimConversationIndex].unread;
        }

        final userLimUserInfo = await _getUserInfo(pktData.userId);
        final limConversation = LimConversation(
          userId: limMessage.userId,
          conversationId: limMessage.conversationId,
          nickname: userLimUserInfo!.nickname,
          avatar: userLimUserInfo.avatar,
          unread: unread,
          createAt: limMessage.createAt,
          lastMessage: limMessage,
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
    login(userId: _userId, token: _token);
  }

  static void _onDone() {}
}
