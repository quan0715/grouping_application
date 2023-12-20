import 'package:flutter/material.dart';

class ColorTagChip extends StatelessWidget {
  const ColorTagChip({
    super.key, 
    required this.tagString,
    this.color = Colors.amber, 
    this.textStyle, 
  });
  final Color color;
  final String tagString;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.5), width: 1),
          borderRadius: BorderRadius.circular(5),
          color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        child: Center(
          child: Text(tagString,
              textAlign: TextAlign.center,
              style: textStyle ?? Theme.of(context).textTheme.labelLarge!.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
          ), 
        ),
      ),
        ));
  }
}