import 'package:light_im_sdk/src/model/conversation.dart';
import 'package:light_im_sdk/src/model/message.dart';

class LightIMSDKListener {
  LightIMSDKListener({
    this.onReceiveNewMessage,
    this.onOpenNewConversation,
    this.onUnreadCountChange,
  });

  final void Function(LimMessage)? onReceiveNewMessage;
  final void Function(LimConversation)? onOpenNewConversation;
  final void Function(int)? onUnreadCountChange;
}
