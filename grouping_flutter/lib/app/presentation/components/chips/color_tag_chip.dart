import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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


class StatusChip extends StatelessWidget{
  
  const StatusChip({
    super.key,
    required this.statusLabel,
    this.statusColor = Colors.amber,
    this.textStyle,
  });

  Color _getBackgroundColor(Color color)
    => Color.lerp(Colors.white, color, 0.05)!;

  Color _getBorderColor(Color color)
    => Color.lerp(Colors.white, color, 0.3)!;


  final Color statusColor;
  final String statusLabel;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: _getBorderColor(statusColor), width: 1),
          borderRadius: BorderRadius.circular(5),
          color: _getBackgroundColor(statusColor)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Center(
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: statusColor,
                radius: 4,
              ),
              const Gap(5),
              Text(statusLabel,
                  textAlign: TextAlign.center,
                  style: textStyle ?? Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
              ), 
                      ),
            ],
          ),
      ),
    ));
  }
}