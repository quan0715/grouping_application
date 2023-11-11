enum MessageType{
  success,
  error,
  warning,
  info,
  others,
}

class MessageData{
  final String title;
  final String message;
  final MessageType type;
  const MessageData({required this.title, required this.message, required this.type});
  factory MessageData.success({String title = "成功", String message = "成功提示， 5秒後會消失"})
    => MessageData(title: title, message: message, type: MessageType.success);
  factory MessageData.error({String title = "錯誤", String message = "錯誤提示， 5秒後會消失"}) 
    => MessageData(title: title, message: message, type: MessageType.error);
  factory MessageData.warning({String title = "警告", String message = "警告提示， 5秒後會消失"})
    => MessageData(title: title, message: message, type: MessageType.warning);
  factory MessageData.info({String title = "提示", String message = "提示， 5秒後會消失"})
    => MessageData(title: title, message: message, type: MessageType.info);
  
  // override compare operator
  @override
  bool operator==(Object other) {
    if (identical(this, other)) return true;
  
    return other is MessageData &&
      other.title == title &&
      other.message == message &&
      other.type == type;
  }
  
  @override
  int get hashCode => super.hashCode;
  
  
}