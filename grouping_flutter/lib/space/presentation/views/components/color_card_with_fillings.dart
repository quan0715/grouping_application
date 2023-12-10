import 'package:flutter/material.dart';
import 'package:grouping_project/core/shared/color_widget_interface.dart';
import 'package:grouping_project/core/theme/color.dart';

class ColorFillingCardWidget extends StatelessWidget implements WithThemePrimaryColor{
  final Color primaryColor;
  final Widget? child;
  final double borderRadius;
  final EdgeInsets padding;
  final String title;
  final String content;

  const ColorFillingCardWidget({
    super.key,
    required this.primaryColor,
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
  Color get getThemePrimaryColor => primaryColor;

  Color get backgroundColor => primaryColor.withOpacity(0.1);

  @override
  Widget build(BuildContext context) => _buildBody(context);

  Widget _buildBody(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Padding(
        padding: padding,
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, 
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: getThemePrimaryColor,
                    fontWeight: FontWeight.bold
                  )
                ),
                Text(
                  content,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: AppColor.onSurfaceColor.withOpacity(0.9)
                  )
                )
          ]),
          child ?? const SizedBox()
        ]),
      ),
    );
  }
  

}
