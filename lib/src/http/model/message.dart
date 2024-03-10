///聊天消息
class MessageItemModel {
  MessageItemModel({
    required this.audio,
    required this.conversationId,
    required this.groupId,
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
    required this.file,
    required this.record,
    required this.video,
  });

  ///会话ID
  final String conversationId;
  final String groupId;
  final int createAt;

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

  ///时间戳
  final int timestamp;

  ///消息类型
  final int type;

  final TextElem? text;
  final ImageElem? image;
  final AudioElem? audio;
  final VideoElem? video;
  final FileElem? file;
  final CustomElem? custom;
  final RecordElem? record;

  factory MessageItemModel.fromMap(Map<String, dynamic> json) =>
      MessageItemModel(
        conversationId: json["conversation_id"],
        createAt: json["create_at"],
        isPeerRead: json["is_peer_read"] == 1,
        isRead: json["is_read"] == 1,
        isSelf: json["is_self"] == 1,
        receiverId: json["receiver_id"],
        senderId: json["sender_id"],
        userId: json["user_id"],
        sequence: json["sequence"],
        timestamp: json["timestamp"],
        groupId: json["group_id"],
        type: json["type"],
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

  Map<String, dynamic> toMap() => {
        "conversation_id": conversationId,
        "create_at": createAt,
        "is_peer_read": isPeerRead ? 1 : 0,
        "is_read": isRead ? 1 : 0,
        "is_self": isSelf ? 1 : 0,
        "receiver_id": receiverId,
        "sender_id": senderId,
        "user_id": userId,
        "sequence": sequence,
        "timestamp": timestamp,
        "group_id": groupId,
        "type": type,
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

class MessagePullResModel {
  MessagePullResModel({
    required this.isEnd,
    required this.items,
    required this.sequence,
  });

  final int isEnd;
  final List<MessageItemModel> items;
  final int sequence;

  factory MessagePullResModel.fromMap(Map<String, dynamic> json) =>
      MessagePullResModel(
        isEnd: json["has_more"] == 1 ? 0 : 1,
        items: List<MessageItemModel>.from(
            json["items"].map((x) => MessageItemModel.fromMap(x))),
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

class MessageSendResModel {
  MessageSendResModel();

  factory MessageSendResModel.fromMap(Map<String, dynamic> json) =>
      MessageSendResModel();

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
