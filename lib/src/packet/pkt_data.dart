import 'typedef.dart';

class MessagePktDataModel extends PacketDataModel {
  MessagePktDataModel({
    required this.conversationId,
    required this.isSelf,
    required this.seq,
    required this.timestamp,
    required this.type,
    required this.userId,
    required this.senderId,
    required this.receiverId,
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
  final String conversationId;
  final bool isSelf;
  final int seq;
  final int timestamp;
  final int createAt;
  final int type;
  final String userId;
  final bool isRead;
  final bool isPeerRead;
  final String? text;
  final String? image;
  final String? audio;
  final String? video;
  final String? custom;

  factory MessagePktDataModel.fromMap(Map<String, dynamic> json) =>
      MessagePktDataModel(
        conversationId: json["conversation_id"],
        isSelf: json["is_self"] == 1,
        seq: json["sequence"],
        timestamp: json["timestamp"],
        type: json["type"],
        senderId: json["sender_id"],
        receiverId: json["receiver_id"],
        userId: json["user_id"],
        isRead: json["is_read"] == 1,
        isPeerRead: json["is_peer_read"] == 1,
        createAt: json["create_at"],
        text: json["text"],
        image: json["image"],
        audio: json["audio"],
        video: json["video"],
        custom: json["custom"],
      );

  @override
  Map<String, dynamic> toMap() => {
        "sender_id": senderId,
        "receiver_id": receiverId,
        "conversation_id": conversationId,
        "is_self": isSelf,
        "sequence": seq,
        "timestamp": timestamp,
        "type": type,
        "user_id": userId,
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

class PingPktDataModel extends PacketDataModel {
  PingPktDataModel();

  factory PingPktDataModel.fromMap(Map<String, dynamic> json) =>
      PingPktDataModel();

  @override
  Map<String, dynamic> toMap() => {};
}

class PongPktDataModel extends PacketDataModel {
  PongPktDataModel();

  factory PongPktDataModel.fromMap(Map<String, dynamic> json) =>
      PongPktDataModel();

  @override
  Map<String, dynamic> toMap() => {};
}

class AuthPktDataModel extends PacketDataModel {
  AuthPktDataModel({
    required this.userId,
    // required this.role,
    required this.token,
  });

  final String userId;
  // final int role;
  final String token;

  factory AuthPktDataModel.fromMap(Map<String, dynamic> json) =>
      AuthPktDataModel(
        userId: json['user_id'],
        // role: json['role'],
        token: json['token'],
      );

  @override
  Map<String, dynamic> toMap() => {
        'user_id': userId,
        // 'role': role,
        'token': token,
      };
}

class PassPktDataModel extends PacketDataModel {
  PassPktDataModel({
    required this.code,
    required this.desc,
  });

  final int code;
  final String desc;

  factory PassPktDataModel.fromMap(Map<String, dynamic> json) =>
      PassPktDataModel(
        code: json['code'],
        desc: json['desc'],
      );

  @override
  Map<String, dynamic> toMap() => {
        'code': code,
        'desc': desc,
      };
}
