class LimMessage {
  LimMessage({
    required this.senderId,
    required this.receiverId,
    required this.userId,
    required this.avatar,
    required this.conversationId,
    required this.isSelf,
    required this.nickname,
    required this.seq,
    required this.timestamp,
    required this.type,
    required this.isRead,
    required this.isPeerRead,
    required this.createAt,
    // LimTextElem? textElem,
    required this.text,
    required this.image,
    required this.audio,
    required this.video,
    required this.custom,
  });

  final String senderId;
  final String receiverId;
  final String userId;
  final String conversationId;
  final String avatar;
  final bool isSelf;
  final String nickname;
  final int seq;
  final int timestamp;
  final int createAt;
  final int type;

  final bool isRead;
  final bool isPeerRead;
  final String? text;
  final String? image;
  final String? audio;
  final String? video;
  final String? custom;

  factory LimMessage.fromMap(Map<String, dynamic> json) => LimMessage(
        avatar: json["avatar"],
        conversationId: json["conversation_id"],
        userId: json["user_id"],
        isSelf: json["is_self"] == 1,
        nickname: json["nickname"],
        seq: json["seq"],
        timestamp: json["timestamp"],
        type: json["type"],
        senderId: json["sender_id"],
        receiverId: json["receiver_id"],
        isRead: json["is_read"] == 1,
        isPeerRead: json["is_peer_read"] == 1,
        createAt: json["create_at"],
        text: json["text"],
        image: json["image"],
        audio: json["audio"],
        video: json["video"],
        custom: json["custom"],
      );

  Map<String, dynamic> toMap() => {
        "avatar": avatar,
        "user_id": userId,
        "conversation_id": conversationId,
        "is_self": isSelf,
        "nickname": nickname,
        "seq": seq,
        "timestamp": timestamp,
        "type": type,
        "sender_id": senderId,
        "receiver_id": receiverId,
        "is_read": isRead ? 1 : 0,
        "is_peer_read": isPeerRead ? 1 : 0,
        "create_at": createAt,
        "text": text,
        "image": image,
        "audio": audio,
        "video": video,
        "custom": custom,
      };
}

class LimMessagePull {
  LimMessagePull({
    required this.isEnd,
    required this.items,
    required this.sequence,
  });

  final int isEnd;
  final List<LimMessage> items;
  final int sequence;

  Map<String, dynamic> toMap() => {
        "is_end": isEnd,
        "items": List<dynamic>.from(items.map((x) => x.toMap())),
        "sequence": sequence,
      };
}
