import 'package:flutter/material.dart';

class TimeDisplayWithPressibleBody extends StatelessWidget {
  const TimeDisplayWithPressibleBody(
      {super.key, required this.activityColor, required this.time, onPressed})
      : _onPressed = onPressed;

  final Color activityColor;
  final String time;
  final void Function()? _onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: _onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: activityColor,
          disabledBackgroundColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time, color: activityColor),
            Text(time,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ))
          ],
        ));
  }
}
