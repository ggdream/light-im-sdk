import 'message.dart';

class ConversationPullResModel {
  ConversationPullResModel({
    required this.count,
    required this.items,
  });

  final int count;
  final List<ConversationPullResModelItem> items;

  factory ConversationPullResModel.fromMap(Map<String, dynamic> json) =>
      ConversationPullResModel(
        count: json["count"],
        items: List<ConversationPullResModelItem>.from(
            json["items"].map((x) => ConversationPullResModelItem.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "count": count,
        "items": List<dynamic>.from(items.map((x) => x.toMap())),
      };
}

///会话消息
class ConversationPullResModelItem {
  ConversationPullResModelItem({
    required this.conversationId,
    required this.createAt,
    this.userId,
    this.groupId,
    required this.unreadCount,
    required this.lastMessage,
    required this.name,
    required this.avatar,
  });

  final String conversationId;
  final String name;
  final String avatar;
  final int createAt;
  final String? userId;
  final String? groupId;
  final int unreadCount;
  final MessageItemModel? lastMessage;

  factory ConversationPullResModelItem.fromMap(Map<String, dynamic> json) =>
      ConversationPullResModelItem(
        conversationId: json["conversation_id"],
        createAt: json["create_at"],
        userId: json["user_id"],
        groupId: json["group_id"],
        unreadCount: json["unread_count"],
        lastMessage:json["last_message"] ==null?null: MessageItemModel.fromMap(json["last_message"]),
        name: json["name"],
        avatar: json["avatar"],
      );

  Map<String, dynamic> toMap() => {
        "conversation_id": conversationId,
        "create_at": createAt,
        "user_id": userId,
        "group_id": groupId,
        "unread_count": unreadCount,
        "last_message": lastMessage?.toMap(),
        "name": name,
        "avatar": avatar,
      };
}

class ConversationDeleteResModel {
  ConversationDeleteResModel();

  factory ConversationDeleteResModel.fromMap(Map<String, dynamic> json) =>
      ConversationDeleteResModel();

  Map<String, dynamic> toMap() => {};
}

class ConversationDetailResModel {
  ConversationDetailResModel({
    required this.avatar,
    required this.conversationId,
    required this.nickname,
    this.userId,
    this.groupId,
  });

  final String avatar;
  final String conversationId;
  final String nickname;
  final String? userId;
  final String? groupId;

  factory ConversationDetailResModel.fromMap(Map<String, dynamic> json) =>
      ConversationDetailResModel(
        avatar: json["avatar"],
        conversationId: json["conversation_id"],
        nickname: json["nickname"],
        userId: json["user_id"],
        groupId: json["group_id"],
      );

  Map<String, dynamic> toMap() => {
        "avatar": avatar,
        "conversation_id": conversationId,
        "nickname": nickname,
        "user_id": userId,
        "group_id": groupId,
      };
}
