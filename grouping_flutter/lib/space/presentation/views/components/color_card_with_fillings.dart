import 'package:flutter/material.dart';

class ColorFillingCardWidget extends StatelessWidget {
  final Color titleColor;
  final Color fillingColor;
  final Widget? child;
  final double borderRadius;
  final EdgeInsets padding;
  final String title;
  final String content;

  const ColorFillingCardWidget({
    super.key,
    required this.titleColor,
    required this.fillingColor,
    required this.title,
    required this.content,
    this.child,
    this.borderRadius = 5,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 10,
    ),
  });

  @override
  Widget build(BuildContext context) => _buildBody(context);

  Widget _buildBody(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: fillingColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Padding(
        padding: padding,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: TextStyle(
                    color: titleColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
            Text(content,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.bold))
          ]),
          child ?? const SizedBox()
        ]),
      ),
    );
  }
}
