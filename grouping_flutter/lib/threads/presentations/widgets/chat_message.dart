import 'package:flutter/material.dart';
import 'package:grouping_project/threads/domains/entity/message_entity.dart';

class ChatMessageCard extends StatelessWidget {
  final MessageEntity message;

  const ChatMessageCard({
    super.key,
    required this.message,
  });
    
  @override
  Widget build(BuildContext context) => _buildBody(context);

  Widget _buildBody(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(4),
      child: message.messageSender == MessageSender.user
      ? _buildUserMessage(context)
      : _buildBotMessage(context)
    );  
  }
  
  Widget _buildUserMessage(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(message.messageText, style: Theme.of(context).textTheme.labelLarge!.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.normal,
          )),
        ),
      ],
    );
  }
  
  Widget _buildBotMessage(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          // backgroundImage: const AssetImage("assets/images/logo.png"),
          radius: 18,
        ),
        const SizedBox(width: 10,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "TEST Bot",
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.normal,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(message.messageText, style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.normal,
              )),
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }
}