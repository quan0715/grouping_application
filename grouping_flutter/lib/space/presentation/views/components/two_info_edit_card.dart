import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grouping_project/core/shared/color_widget_interface.dart';
import 'package:grouping_project/space/presentation/view_models/setting_view_model.dart';
import 'package:provider/provider.dart';

class TwoInfoEditCardWidget extends StatelessWidget
    implements WithThemePrimaryColor {
  final Color primaryColor;
  final double borderRadius;
  final EdgeInsets padding;
  final String firstEditTitle;
  final String secondEditTitle;
  String firstEditingContent;
  String secondEditingContent;
  final Widget? child;

  TwoInfoEditCardWidget({
    super.key,
    required this.primaryColor,
    required this.firstEditTitle,
    required this.secondEditTitle,
    required this.firstEditingContent,
    required this.secondEditingContent,
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(firstEditTitle,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: getThemePrimaryColor, fontWeight: FontWeight.bold)),
          TextFormField(
            initialValue: firstEditingContent,
            onChanged: (value) {
              firstEditingContent = value;
              Provider.of<SettingPageViewModel>(context, listen: false)
                  .firstEditedFiled = value;
            },
          ),
          Text(secondEditTitle,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: getThemePrimaryColor, fontWeight: FontWeight.bold)),
          TextFormField(
            initialValue: secondEditingContent,
            onChanged: (value) {
              firstEditingContent = value;
              Provider.of<SettingPageViewModel>(context, listen: false)
                  .secondEditedFiled = value;
            },
          ),
          const Gap(10),
          child ?? const SizedBox()
        ]),
      ),
    );
  }
}
