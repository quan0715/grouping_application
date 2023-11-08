// Application Log message card 
// for notify user the result of the action
import 'package:flutter/material.dart';
import 'package:grouping_project/View/theme/theme.dart';
import 'package:grouping_project/ViewModel/message_service.dart';
import 'package:grouping_project/model/workspace/message_model.dart';

class LogMessageCard extends StatelessWidget{
  final MessageData message;
  final Color color;
  final Widget icon;
  final Function onDelete;
  const LogMessageCard({
    super.key,
    required this.message, 
    required this.color,
    required this.icon,
    required this.onDelete,
  });

  factory LogMessageCard.fromData({required MessageData messageData, Function? onDelete}) =>
    switch(messageData.type){
      MessageType.success => 
        LogMessageCard.success(
          title: messageData.title,
          message: messageData.message,
          onDelete: onDelete,
        ),
      MessageType.error =>
        LogMessageCard.error(
          title: messageData.title,
          message: messageData.message,
          onDelete: onDelete,
        ),
      MessageType.warning =>
        LogMessageCard.warning(
          title: messageData.title,
          message: messageData.message,
          onDelete: onDelete,
        ),
      MessageType.info =>
        LogMessageCard(
          message: messageData,
          color: AppColor.logInfo,
          icon: const Icon(Icons.info,),
          onDelete: () => {},
        ),
      MessageType.others =>
        LogMessageCard(
          message: messageData,
          color: AppColor.logOthers,
          icon: const Icon(Icons.info,),
          onDelete: () => {},
        )
    };

  factory LogMessageCard.success({
    String title = "成功",
    String message = "成功提示， 5秒後會消失",
    Function? onDelete,
  }) => LogMessageCard(
    message: MessageData.success(title: title, message: message),
    color: AppColor.logSuccess,
    icon: const Icon(Icons.check_circle,),
    onDelete: onDelete ?? () => {},
  );

  factory LogMessageCard.error({
    String title = "錯誤",
    String message = "錯誤提示， 5秒後會消失",
    Function? onDelete,
  }) => LogMessageCard(
    message: MessageData.error(title: title, message: message),
    color: AppColor.logError,
    icon: const Icon(Icons.error,),
    onDelete: onDelete ?? () => {},
  );

  factory LogMessageCard.warning({
    String title = "警告",
    String message = "警告提示， 5秒後會消失",
    Function? onDelete,
  }) => LogMessageCard(
    message: MessageData.warning(title: title, message: message),
    color: AppColor.logWarning,
    icon: const Icon(Icons.warning,),
    onDelete: onDelete ?? () => {},
  );

  Color get backgroundColor => color.withOpacity(0.05);
  Color get borderColor => color;
  Color get iconColor => color;
  Color get deleteIconColor => color.withOpacity(0.5);
  TextStyle get titleStyle => TextStyle(color: color, fontWeight: FontWeight.bold,);
  EdgeInsets get innerPadding => const EdgeInsets.all(8.0);
  EdgeInsets get outerPadding => const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0);
  BorderRadius get borderRadius => BorderRadius.circular(10.0);
   
  BoxBorder get border => Border(
    left: BorderSide(color: borderColor,width: 10.0),
    bottom: BorderSide(color: borderColor, width: 0.0),
    right: BorderSide( color: borderColor, width: 0.0),
    top: BorderSide( color: borderColor, width: 0.0,),
  );

  @override
  Widget build(BuildContext context) => _build;

  Widget get _build => Padding(
      padding: outerPadding,
      child: Container(
        
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
          border: border
        ),
        child: Padding(
          padding: innerPadding,
          child: Row(
            children: [
              _buildIcon,
              _textArea,
              const Spacer(),
              _buildDeleteIcon,
            ],
          ),
        ),
    )
  );
  
  Widget get _textArea => Padding(
    padding: innerPadding,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(message.title, style: titleStyle),
        Text(message.message),
      ],
    ),
  );

  Widget get _buildIcon => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Padding(
      padding: innerPadding,
      child: Icon((icon as Icon).icon, color: iconColor,),
    ),
  );

  Widget get _buildDeleteIcon => IconButton(
    onPressed: onDelete as void Function()?,
    // _messageService.clearMessage(message),
    icon: Icon(Icons.clear, color: deleteIconColor,),
  );
}

class MessagesList extends StatelessWidget{
  // final List<MessageData> messages;
  final MessageService messageService;
  const MessagesList({super.key, required this.messageService});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MessageData>>(
      stream: messageService.messageStream,
      builder: (context, AsyncSnapshot<List<MessageData>> snapshot) {
        var messages = snapshot.data ?? [];
        return ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 360.0, maxWidth: 400.0),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: messages.length,
            itemBuilder: (context, index) => LogMessageCard.fromData(
              messageData: messages[index],
              onDelete: () => {
                // debugPrint("delete message ${messages[index].title}"),
                messageService.clearMessage(messages[index])
              },
            ),
          ),
        );
      }
    );
  }
}