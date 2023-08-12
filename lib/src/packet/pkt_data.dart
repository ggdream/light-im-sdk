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
  final String conversationId;
  final bool isSelf;
  final int seq;
  final int timestamp;
  final int createAt;
  final int type;
  final String userId;
  final bool isRead;
  final bool isPeerRead;
  final TextElem? text;
  final ImageElem? image;
  final AudioElem? audio;
  final VideoElem? video;
  final FileElem? file;
  final CustomElem? custom;
  final RecordElem? record;

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
        text: json["text"] == null ? null : TextElem.fromMap(json["text"]),
        image: json["image"] == null ? null : ImageElem.fromMap(json["image"]),
        audio: json["audio"] == null ? null : AudioElem.fromMap(json["audio"]),
        video: json["video"] == null ? null : VideoElem.fromMap(json["video"]),
        file: json["file"] == null ? null : FileElem.fromMap(json["file"]),
        custom:
            json["custom"] == null ? null : CustomElem.fromMap(json["custom"]),
        record:
            json["record"] == null ? null : RecordElem.fromMap(json["record"]),
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
        "text": text?.toMap(),
        "image": image?.toMap(),
        "audio": audio?.toMap(),
        "video": video?.toMap(),
        "file": file?.toMap(),
        "custom": custom?.toMap(),
        "record": record?.toMap(),
      };
}

class TextElem {
  TextElem({
    required this.text,
  });

  final String text;

  factory TextElem.fromMap(Map<String, dynamic> json) => TextElem(
        text: json["text"],
      );

  Map<String, dynamic> toMap() => {
        "text": text,
      };
}

class ImageElem {
  ImageElem({
    required this.contentType,
    required this.name,
    required this.size,
    required this.url,
    required this.thumbnailUrl,
  });

  final String contentType;
  final String name;
  final int size;
  final String url;
  final String thumbnailUrl;

  factory ImageElem.fromMap(Map<String, dynamic> json) => ImageElem(
        contentType: json["content_type"],
        name: json["name"],
        size: json["size"],
        url: json["url"],
        thumbnailUrl: json["thumbnail_url"],
      );

  Map<String, dynamic> toMap() => {
        "content_type": contentType,
        "name": name,
        "size": size,
        "url": url,
        "thumbnail_url": thumbnailUrl,
      };
}

class AudioElem {
  AudioElem({
    required this.contentType,
    required this.duration,
    required this.name,
    required this.size,
    required this.url,
  });

  final String contentType;
  final int duration;
  final String name;
  final int size;
  final String url;

  factory AudioElem.fromMap(Map<String, dynamic> json) => AudioElem(
        contentType: json["content_type"],
        duration: json["duration"],
        name: json["name"],
        size: json["size"],
        url: json["url"],
      );

  Map<String, dynamic> toMap() => {
        "content_type": contentType,
        "duration": duration,
        "name": name,
        "size": size,
        "url": url,
      };
}

class VideoElem {
  VideoElem({
    required this.contentType,
    required this.duration,
    required this.name,
    required this.size,
    required this.url,
    required this.thumbnailUrl,
  });

  final String contentType;
  final int duration;
  final String name;
  final int size;
  final String url;
  final String thumbnailUrl;

  factory VideoElem.fromMap(Map<String, dynamic> json) => VideoElem(
        contentType: json["content_type"],
        duration: json["duration"],
        name: json["name"],
        size: json["size"],
        url: json["url"],
        thumbnailUrl: json["thumbnail_url"],
      );

  Map<String, dynamic> toMap() => {
        "content_type": contentType,
        "duration": duration,
        "name": name,
        "size": size,
        "url": url,
        "thumbnail_url": thumbnailUrl,
      };
}

class FileElem {
  FileElem({
    required this.contentType,
    required this.name,
    required this.size,
    required this.url,
  });

  final String contentType;
  final String name;
  final int size;
  final String url;

  factory FileElem.fromMap(Map<String, dynamic> json) => FileElem(
        contentType: json["content_type"],
        name: json["name"],
        size: json["size"],
        url: json["url"],
      );

  Map<String, dynamic> toMap() => {
        "content_type": contentType,
        "name": name,
        "size": size,
        "url": url,
      };
}

class CustomElem {
  CustomElem({
    required this.content,
  });

  final String content;

  factory CustomElem.fromMap(Map<String, dynamic> json) => CustomElem(
        content: json["content"],
      );

  Map<String, dynamic> toMap() => {
        "content": content,
      };
}

class RecordElem {
  RecordElem({
    required this.contentType,
    required this.duration,
    required this.size,
    required this.url,
  });

  final String contentType;
  final int duration;
  final int size;
  final String url;

  factory RecordElem.fromMap(Map<String, dynamic> json) => RecordElem(
        contentType: json["content_type"],
        duration: json["duration"],
        size: json["size"],
        url: json["url"],
      );

  Map<String, dynamic> toMap() => {
        "content_type": contentType,
        "duration": duration,
        "size": size,
        "url": url,
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
