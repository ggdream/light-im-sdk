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
  });

  final String? audio;
  final String conversationId;
  final int createAt;
  final String? custom;
  final String? image;
  final bool isRead;
  final bool isSelf;
  final String receiverId;
  final String senderId;
  final String userId;
  final int sequence;
  final String? text;
  final int timestamp;
  final int type;
  final int unread;
  final String? video;

  factory ConversationPullResModelItem.fromMap(Map<String, dynamic> json) =>
      ConversationPullResModelItem(
        audio: json["audio"],
        conversationId: json["conversation_id"],
        createAt: json["create_at"],
        custom: json["custom"],
        image: json["image"],
        isRead: json["is_read"] == 1,
        isSelf: json["is_self"] == 1,
        receiverId: json["receiver_id"],
        senderId: json["sender_id"],
        userId: json["user_id"],
        sequence: json["sequence"],
        text: json["text"],
        timestamp: json["timestamp"],
        type: json["type"],
        unread: json["unread"],
        video: json["video"],
      );

  Map<String, dynamic> toMap() => {
        "audio": audio,
        "conversation_id": conversationId,
        "create_at": createAt,
        "custom": custom,
        "image": image,
        "is_read": isRead ? 1 : 0,
        "is_self": isSelf ? 1 : 0,
        "receiver_id": receiverId,
        "sender_id": senderId,
        "user_id": userId,
        "sequence": sequence,
        "text": text,
        "timestamp": timestamp,
        "type": type,
        "unread": unread,
        "video": video,
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
