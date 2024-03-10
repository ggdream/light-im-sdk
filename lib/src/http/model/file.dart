class FilePresignPutURLResModel {
  FilePresignPutURLResModel({
    required this.id,
    required this.url,
    required this.key,
    required this.expireAt,
  });

  final String id;
  final String url;
  final String key;
  final int expireAt;

  factory FilePresignPutURLResModel.fromMap(Map<String, dynamic> json) =>
      FilePresignPutURLResModel(
        id: json["id"],
        url: json["url"],
        key: json["key"],
        expireAt: json["expire_at"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "url": url,
        "key": key,
        "expire_at": expireAt,
      };
}
