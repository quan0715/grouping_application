import 'package:flutter/material.dart';
import 'package:grouping_project/core/theme/color.dart';

class TitleWithContent extends StatelessWidget {
  final String title;
  final String content;
  final Color? color;
  Widget? child;
  TitleWithContent(
      {super.key,
      required this.title,
      required this.content,
      this.color,
      this.child});

  Color getPrimaryColor(BuildContext context) =>
      color ?? AppColor.onSurface(context);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: getPrimaryColor(context),
                      fontWeight: FontWeight.bold,
                    )),
            Text(content,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: getPrimaryColor(context).withOpacity(0.5))),
          ],
        ),
        child ?? Container()
      ],
    );
  }
}
