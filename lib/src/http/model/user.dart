class UserProfileResModel {
  UserProfileResModel({
    required this.avatar,
    required this.nickname,
    required this.userId,
    required this.role,
    required this.createAt,
  });

  final String avatar;
  final String nickname;
  final String userId;
  final int role;
  final int createAt;

  factory UserProfileResModel.fromMap(Map<String, dynamic> json) =>
      UserProfileResModel(
        avatar: json["avatar"],
        nickname: json["username"],
        userId: json["id"],
        role: json["role"],
        createAt: json["create_at"],
      );

  Map<String, dynamic> toMap() => {
        "avatar": avatar,
        "username": nickname,
        "id": userId,
        "role": role,
        "create_at": createAt,
      };
}
