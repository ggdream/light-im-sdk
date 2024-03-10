import 'message.dart';

class LimConversation {
  final String? userId;
  final String? groupId;
  final String conversationId;

  final String nickname;
  final String avatar;
  int unread;
  final int createAt;
  LimMessage? lastMessage;

  LimConversation({
    required this.userId,
    required this.groupId,
    required this.conversationId,
    required this.nickname,
    required this.avatar,
    required this.unread,
    required this.createAt,
    required this.lastMessage,
  });
}
