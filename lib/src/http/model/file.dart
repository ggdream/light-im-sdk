class FilePresignPutURLResModel {
  FilePresignPutURLResModel({
    required this.presignUrl,
    required this.url,
  });

  final String presignUrl;
  final String url;

  factory FilePresignPutURLResModel.fromMap(Map<String, dynamic> json) =>
      FilePresignPutURLResModel(
        presignUrl: json["presign_url"],
        url: json["url"],
      );

  Map<String, dynamic> toMap() => {
        "presign_url": presignUrl,
        "url": url,
      };
}
