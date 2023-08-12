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
    required this.file,
    required this.record,
    required this.video,
  });

  ///会话ID
  final String conversationId;
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

  final MessageSendResModelTextElem? text;
  final MessageSendResModelImageElem? image;
  final MessageSendResModelAudioElem? audio;
  final MessageSendResModelVideoElem? video;
  final MessageSendResModelFileElem? file;
  final MessageSendResModelCustomElem? custom;
  final MessageSendResModelRecordElem? record;

  factory MessageSendResModel.fromMap(Map<String, dynamic> json) =>
      MessageSendResModel(
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
        type: json["type"],
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
        "is_peer_read": isPeerRead ? 1 : 0,
        "is_read": isRead ? 1 : 0,
        "is_self": isSelf ? 1 : 0,
        "receiver_id": receiverId,
        "sender_id": senderId,
        "user_id": userId,
        "sequence": sequence,
        "timestamp": timestamp,
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

class MessageSendResModelTextElem {
  MessageSendResModelTextElem({
    required this.text,
  });

  final String text;

  factory MessageSendResModelTextElem.fromMap(Map<String, dynamic> json) =>
      MessageSendResModelTextElem(
        text: json["text"],
      );

  Map<String, dynamic> toMap() => {
        "text": text,
      };
}

class MessageSendResModelImageElem {
  MessageSendResModelImageElem({
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

  factory MessageSendResModelImageElem.fromMap(Map<String, dynamic> json) =>
      MessageSendResModelImageElem(
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

class MessageSendResModelAudioElem {
  MessageSendResModelAudioElem({
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

  factory MessageSendResModelAudioElem.fromMap(Map<String, dynamic> json) =>
      MessageSendResModelAudioElem(
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

class MessageSendResModelVideoElem {
  MessageSendResModelVideoElem({
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

  factory MessageSendResModelVideoElem.fromMap(Map<String, dynamic> json) =>
      MessageSendResModelVideoElem(
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

class MessageSendResModelFileElem {
  MessageSendResModelFileElem({
    required this.contentType,
    required this.name,
    required this.size,
    required this.url,
  });

  final String contentType;
  final String name;
  final int size;
  final String url;

  factory MessageSendResModelFileElem.fromMap(Map<String, dynamic> json) =>
      MessageSendResModelFileElem(
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

class MessageSendResModelCustomElem {
  MessageSendResModelCustomElem({
    required this.content,
  });

  final String content;

  factory MessageSendResModelCustomElem.fromMap(Map<String, dynamic> json) =>
      MessageSendResModelCustomElem(
        content: json["content"],
      );

  Map<String, dynamic> toMap() => {
        "content": content,
      };
}

class MessageSendResModelRecordElem {
  MessageSendResModelRecordElem({
    required this.contentType,
    required this.duration,
    required this.size,
    required this.url,
  });

  final String contentType;
  final int duration;
  final int size;
  final String url;

  factory MessageSendResModelRecordElem.fromMap(Map<String, dynamic> json) =>
      MessageSendResModelRecordElem(
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
