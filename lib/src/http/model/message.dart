///聊天消息
class MessageSendResModel {
  MessageSendResModel({
    required this.audio,
    required this.conversationId,
    required this.createAt,
    required this.custom,
    required this.image,
    required this.isPeerRead,
    required this.isRead,
    required this.isSelf,
    required this.receiverId,
    required this.senderId,
    required this.userId,
    required this.sequence,
    required this.text,
    required this.timestamp,
    required this.type,
    required this.video,
  });

  final String? audio;

  ///会话ID
  final String conversationId;
  final int createAt;
  final String? custom;
  final String? image;

  ///回方已读
  final bool isPeerRead;

  ///自己已读
  final bool isRead;

  ///是自己发送
  final bool isSelf;

  ///接收者ID
  final String receiverId;

  ///发送者ID
  final String senderId;

  final String userId;
  final int sequence;
  final String? text;

  ///时间戳
  final int timestamp;

  ///消息类型
  final int type;
  final String? video;

  factory MessageSendResModel.fromMap(Map<String, dynamic> json) =>
      MessageSendResModel(
        audio: json["audio"],
        conversationId: json["conversation_id"],
        createAt: json["create_at"],
        custom: json["custom"],
        image: json["image"],
        isPeerRead: json["is_peer_read"] == 1,
        isRead: json["is_read"] == 1,
        isSelf: json["is_self"] == 1,
        receiverId: json["receiver_id"],
        senderId: json["sender_id"],
        userId: json["user_id"],
        sequence: json["sequence"],
        text: json["text"],
        timestamp: json["timestamp"],
        type: json["type"],
        video: json["video"],
      );

  Map<String, dynamic> toMap() => {
        "audio": audio,
        "conversation_id": conversationId,
        "create_at": createAt,
        "custom": custom,
        "image": image,
        "is_peer_read": isPeerRead ? 1 : 0,
        "is_read": isRead ? 1 : 0,
        "is_self": isSelf ? 1 : 0,
        "receiver_id": receiverId,
        "sender_id": senderId,
        "user_id": userId,
        "sequence": sequence,
        "text": text,
        "timestamp": timestamp,
        "type": type,
        "video": video,
      };
}

class MessagePullResModel {
  MessagePullResModel({
    required this.isEnd,
    required this.items,
    required this.sequence,
  });

  final int isEnd;
  final List<MessageSendResModel> items;
  final int sequence;

  factory MessagePullResModel.fromMap(Map<String, dynamic> json) =>
      MessagePullResModel(
        isEnd: json["is_end"],
        items: List<MessageSendResModel>.from(
            json["items"].map((x) => MessageSendResModel.fromMap(x))),
        sequence: json["sequence"],
      );

  Map<String, dynamic> toMap() => {
        "is_end": isEnd,
        "items": List<dynamic>.from(items.map((x) => x.toMap())),
        "sequence": sequence,
      };
}

class MessageMarkResModel {
  MessageMarkResModel();

  factory MessageMarkResModel.fromMap(Map<String, dynamic> json) =>
      MessageMarkResModel();

  Map<String, dynamic> toMap() => {};
}

class MessageUnreadResModel {
  MessageUnreadResModel({
    required this.count,
  });

  final int count;

  factory MessageUnreadResModel.fromMap(Map<String, dynamic> json) =>
      MessageUnreadResModel(
        count: json["count"],
      );

  Map<String, dynamic> toMap() => {
        "count": count,
      };
}
