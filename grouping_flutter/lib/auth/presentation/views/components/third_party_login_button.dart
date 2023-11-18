import 'package:flutter/material.dart';

class ThirdPartyLoginButton extends StatelessWidget {
  final Color primaryColor;
  final String semanticsLabel;
  final VoidCallback? onPressed;
  final Widget icon;
  const ThirdPartyLoginButton({
    super.key,
    required this.icon,
    this.primaryColor = Colors.transparent,
    this.onPressed,
    this.semanticsLabel = "auth button",
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel,
      child: SizedBox(
        width: 50,
        child: AspectRatio(
          aspectRatio: 1,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: primaryColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
            ),
            child: icon,
        )
          ),
      ));
  }
}