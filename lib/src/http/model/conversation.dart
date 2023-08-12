import 'message.dart';

class ConversationPullResModel {
  ConversationPullResModel({
    required this.count,
    required this.items,
  });

  final int count;
  final List<ConversationPullResModelItem> items;

  factory ConversationPullResModel.fromMap(Map<String, dynamic> json) =>
      ConversationPullResModel(
        count: json["count"],
        items: List<ConversationPullResModelItem>.from(
            json["items"].map((x) => ConversationPullResModelItem.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "count": count,
        "items": List<dynamic>.from(items.map((x) => x.toMap())),
      };
}

///会话消息
class ConversationPullResModelItem {
  ConversationPullResModelItem({
    required this.audio,
    required this.conversationId,
    required this.createAt,
    required this.custom,
    required this.image,
    required this.isRead,
    required this.isSelf,
    required this.receiverId,
    required this.senderId,
    required this.userId,
    required this.sequence,
    required this.text,
    required this.timestamp,
    required this.type,
    required this.unread,
    required this.video,
    required this.file,
    required this.record,
  });

  final String conversationId;
  final int createAt;
  final bool isRead;
  final bool isSelf;
  final String receiverId;
  final String senderId;
  final String userId;
  final int sequence;
  final int timestamp;
  final int type;
  final int unread;
  final MessageSendResModelTextElem? text;
  final MessageSendResModelImageElem? image;
  final MessageSendResModelAudioElem? audio;
  final MessageSendResModelVideoElem? video;
  final MessageSendResModelFileElem? file;
  final MessageSendResModelCustomElem? custom;
  final MessageSendResModelRecordElem? record;

  factory ConversationPullResModelItem.fromMap(Map<String, dynamic> json) =>
      ConversationPullResModelItem(
        conversationId: json["conversation_id"],
        createAt: json["create_at"],
        isRead: json["is_read"] == 1,
        isSelf: json["is_self"] == 1,
        receiverId: json["receiver_id"],
        senderId: json["sender_id"],
        userId: json["user_id"],
        sequence: json["sequence"],
        timestamp: json["timestamp"],
        type: json["type"],
        unread: json["unread"],
        text: json["text"] == null
            ? null
            : MessageSendResModelTextElem.fromMap(json["text"]),
        image: json["image"] == null
            ? null
            : MessageSendResModelImageElem.fromMap(json["image"]),
        audio: json["audio"] == null
            ? null
            : MessageSendResModelAudioElem.fromMap(json["audio"]),
        video: json["video"] == null
            ? null
            : MessageSendResModelVideoElem.fromMap(json["video"]),
        file: json["file"] == null
            ? null
            : MessageSendResModelFileElem.fromMap(json["file"]),
        custom: json["custom"] == null
            ? null
            : MessageSendResModelCustomElem.fromMap(json["custom"]),
        record: json["record"] == null
            ? null
            : MessageSendResModelRecordElem.fromMap(json["record"]),
      );

  Map<String, dynamic> toMap() => {
        "conversation_id": conversationId,
        "create_at": createAt,
        "is_read": isRead ? 1 : 0,
        "is_self": isSelf ? 1 : 0,
        "receiver_id": receiverId,
        "sender_id": senderId,
        "user_id": userId,
        "sequence": sequence,
        "timestamp": timestamp,
        "type": type,
        "unread": unread,
        "text": text?.toMap(),
        "image": image?.toMap(),
        "audio": audio?.toMap(),
        "video": video?.toMap(),
        "file": file?.toMap(),
        "custom": custom?.toMap(),
        "record": record?.toMap(),
      };
}

class ConversationDeleteResModel {
  ConversationDeleteResModel();

  factory ConversationDeleteResModel.fromMap(Map<String, dynamic> json) =>
      ConversationDeleteResModel();

  Map<String, dynamic> toMap() => {};
}

class ConversationDetailResModel {
  ConversationDetailResModel({
    required this.avatar,
    required this.conversationId,
    required this.nickname,
    required this.userId,
  });

  final String avatar;
  final String conversationId;
  final String nickname;
  final String userId;

  factory ConversationDetailResModel.fromMap(Map<String, dynamic> json) =>
      ConversationDetailResModel(
        avatar: json["avatar"],
        conversationId: json["conversation_id"],
        nickname: json["nickname"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toMap() => {
        "avatar": avatar,
        "conversation_id": conversationId,
        "nickname": nickname,
        "user_id": userId,
      };
}
