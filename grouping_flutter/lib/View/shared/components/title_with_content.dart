
import 'package:flutter/material.dart';
import 'package:grouping_project/View/theme/theme.dart';

class TitleWithContent extends StatelessWidget {
  final String title;
  final String content;
  const TitleWithContent(
      {super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppText.titleLarge(context)),
        Text(content,
            style: AppText.titleSmall(context)
                .copyWith(color: AppColor.onSurface(context).withOpacity(0.5))),
      ],
    );
  }
}