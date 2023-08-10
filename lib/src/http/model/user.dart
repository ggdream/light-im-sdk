class UserProfileResModel {
  UserProfileResModel({
    required this.avatar,
    required this.nickname,
    required this.userId,
  });

  final String avatar;
  final String nickname;
  final String userId;

  factory UserProfileResModel.fromMap(Map<String, dynamic> json) =>
      UserProfileResModel(
        avatar: json["avatar"],
        nickname: json["nickname"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toMap() => {
        "avatar": avatar,
        "nickname": nickname,
        "user_Id": userId,
      };
}
