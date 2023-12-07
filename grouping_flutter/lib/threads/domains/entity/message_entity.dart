class MessageEntity{
  final String messageText;
  final MessageSender messageSender;
  final DateTime? messageTime;
  // final bool? isMessageRead;
  // final bool? isMessageSent;
  // final bool? isMessageReceived;
  MessageEntity({
    required this.messageText,
    required this.messageSender,
    // required this.isMessageRead,
    // required this.isMessageSent,
    // required this.isMessageReceived,
  }) : messageTime = DateTime.now();
} 

enum MessageSender{
  user,
  bot,
}