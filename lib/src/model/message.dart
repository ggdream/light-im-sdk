import 'package:light_im_sdk/src/types/types.dart';

import 'elem.dart';

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
    required this.text,
    required this.image,
    required this.audio,
    required this.video,
    required this.file,
    required this.custom,
    required this.record,
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
  final LimTextElem? text;
  final LimImageElem? image;
  final LimAudioElem? audio;
  final LimVideoElem? video;
  final LimFileElem? file;
  final LimCustomElem? custom;
  final LimRecordElem? record;

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
        text: json["text"] == null ? null : LimTextElem.fromMap(json["text"]),
        image:
            json["image"] == null ? null : LimImageElem.fromMap(json["image"]),
        audio:
            json["audio"] == null ? null : LimAudioElem.fromMap(json["audio"]),
        video:
            json["video"] == null ? null : LimVideoElem.fromMap(json["video"]),
        file: json["file"] == null ? null : LimFileElem.fromMap(json["file"]),
        custom: json["custom"] == null
            ? null
            : LimCustomElem.fromMap(json["custom"]),
        record: json["record"] == null
            ? null
            : LimRecordElem.fromMap(json["record"]),
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
        "text": text?.toMap(),
        "image": image?.toMap(),
        "audio": audio?.toMap(),
        "video": video?.toMap(),
        "file": file?.toMap(),
        "custom": custom?.toMap(),
        "record": record?.toMap(),
      };

  @override
  String toString() {
    late final LimElem elem;
    switch (LimMessageType.values[type]) {
      case LimMessageType.text:
        elem = text!;
        break;
      case LimMessageType.image:
        elem = image!;
        break;
      case LimMessageType.audio:
        elem = audio!;
        break;
      case LimMessageType.video:
        elem = video!;
        break;
      case LimMessageType.file:
        elem = file!;
        break;
      case LimMessageType.custom:
        elem = custom!;
        break;
      case LimMessageType.record:
        elem = record!;
        break;
      default:
        return '[未知消息]';
    }

    return elem.toString();
  }
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
