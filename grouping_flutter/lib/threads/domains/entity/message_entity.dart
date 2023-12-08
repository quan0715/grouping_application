class MessageEntity{
  final String messageText;
  final MessageSender messageSender;
  final DateTime? messageTime;
  
  MessageEntity({
    required this.messageText,
    required this.messageSender,
  }) : messageTime = DateTime.now();
} 

enum MessageSender{
  user,
  bot,
}