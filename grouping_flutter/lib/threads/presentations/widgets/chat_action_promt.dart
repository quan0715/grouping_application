import 'package:flutter/material.dart';

class ChatActionPrompt extends StatelessWidget {
  final String promptTitle;
  final String promptMessage;
  final String actionText;

  const ChatActionPrompt({
    super.key,
    required this.promptTitle,
    required this.promptMessage,
    required this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(promptTitle, style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              )),
              Text(promptMessage, style: Theme.of(context).textTheme.labelLarge!.copyWith(

              ),),
            ],
          ),
        ),
      ),
      onTap: () => debugPrint(actionText),
    );
  }
}