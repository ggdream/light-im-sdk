class TextElemReqModel {
  TextElemReqModel({
    required this.text,
  });

  final String text;

  factory TextElemReqModel.fromMap(Map<String, dynamic> json) =>
      TextElemReqModel(
        text: json["text"],
      );

  Map<String, dynamic> toMap() => {
        "text": text,
      };
}

class ImageElemReqModel {
  ImageElemReqModel({
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

  factory ImageElemReqModel.fromMap(Map<String, dynamic> json) =>
      ImageElemReqModel(
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

class AudioElemReqModel {
  AudioElemReqModel({
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

  factory AudioElemReqModel.fromMap(Map<String, dynamic> json) =>
      AudioElemReqModel(
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

class VideoElemReqModel {
  VideoElemReqModel({
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

  factory VideoElemReqModel.fromMap(Map<String, dynamic> json) =>
      VideoElemReqModel(
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

class FileElemReqModel {
  FileElemReqModel({
    required this.contentType,
    required this.name,
    required this.size,
    required this.url,
  });

  final String contentType;
  final String name;
  final int size;
  final String url;

  factory FileElemReqModel.fromMap(Map<String, dynamic> json) =>
      FileElemReqModel(
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

class CustomElemReqModel {
  CustomElemReqModel({
    required this.content,
  });

  final String content;

  factory CustomElemReqModel.fromMap(Map<String, dynamic> json) =>
      CustomElemReqModel(
        content: json["content"],
      );

  Map<String, dynamic> toMap() => {
        "content": content,
      };
}

class RecordElemReqModel {
  RecordElemReqModel({
    required this.contentType,
    required this.duration,
    required this.size,
    required this.url,
  });

  final String contentType;
  final int duration;
  final int size;
  final String url;

  factory RecordElemReqModel.fromMap(Map<String, dynamic> json) =>
      RecordElemReqModel(
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
