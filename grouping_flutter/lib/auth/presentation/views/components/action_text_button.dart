import 'package:flutter/material.dart';
import 'package:grouping_project/app/presentation/theme/color.dart';

class ActionTextButton extends StatelessWidget {
  const ActionTextButton({
    super.key,
    required this.onPressed,
    required this.questionText,
    required this.actionText,
    this.questionColor,
    this.actionColor,
  });

  final VoidCallback? onPressed;
  final String questionText;
  final String actionText;
  final Color? questionColor;
  final Color? actionColor;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: RichText(
        text: TextSpan(
          text: questionText,
          style: TextStyle(color: questionColor ?? AppColor.onSurface(context)),
          children: [
            TextSpan(
              text: actionText,
              style: TextStyle(color: actionColor ?? AppColor.primary(context)),
            )
          ]
        ),
      )
    );
  }
}