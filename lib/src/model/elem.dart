class LimElem {}

class LimTextElem extends LimElem {
  LimTextElem({
    required this.text,
  });

  final String text;

  factory LimTextElem.fromMap(Map<String, dynamic> json) => LimTextElem(
        text: json["text"],
      );

  Map<String, dynamic> toMap() => {
        "text": text,
      };

  @override
  String toString() {
    return text;
  }
}

class LimImageElem extends LimElem {
  LimImageElem({
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

  factory LimImageElem.fromMap(Map<String, dynamic> json) => LimImageElem(
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

  @override
  String toString() {
    return '[图片消息]';
  }
}

class LimAudioElem extends LimElem {
  LimAudioElem({
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

  factory LimAudioElem.fromMap(Map<String, dynamic> json) => LimAudioElem(
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

  @override
  String toString() {
    return '[音频消息]';
  }
}

class LimVideoElem extends LimElem {
  LimVideoElem({
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

  factory LimVideoElem.fromMap(Map<String, dynamic> json) => LimVideoElem(
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

  @override
  String toString() {
    return '[视频消息]';
  }
}

class LimFileElem extends LimElem {
  LimFileElem({
    required this.contentType,
    required this.name,
    required this.size,
    required this.url,
  });

  final String contentType;
  final String name;
  final int size;
  final String url;

  factory LimFileElem.fromMap(Map<String, dynamic> json) => LimFileElem(
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

  @override
  String toString() {
    return '[文件消息]';
  }
}

class LimCustomElem extends LimElem {
  LimCustomElem({
    required this.content,
  });

  final String content;

  factory LimCustomElem.fromMap(Map<String, dynamic> json) => LimCustomElem(
        content: json["content"],
      );

  Map<String, dynamic> toMap() => {
        "content": content,
      };

  @override
  String toString() {
    return '[自定义消息]';
  }
}

class LimRecordElem extends LimElem {
  LimRecordElem({
    required this.contentType,
    required this.duration,
    required this.size,
    required this.url,
  });

  final String contentType;
  final int duration;
  final int size;
  final String url;

  factory LimRecordElem.fromMap(Map<String, dynamic> json) => LimRecordElem(
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

  @override
  String toString() {
    return '[语音消息]';
  }
}
