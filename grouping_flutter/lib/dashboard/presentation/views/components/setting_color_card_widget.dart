import 'package:flutter/material.dart';
import 'package:grouping_project/core/shared/color_widget_interface.dart';

class SettingColorCardWidget extends StatelessWidget
    implements WithThemeSettingColor {
  final Color secondaryColor;
  final Color tertiaryColor;
  final Widget? child;
  final double borderRadius;
  final EdgeInsets padding;
  @override
  Color get getThemeSecondaryColor => secondaryColor;
  @override
  Color get getThemeTertiaryColor => tertiaryColor;

  const SettingColorCardWidget({
    super.key,
    required this.secondaryColor,
    required this.tertiaryColor,
    this.child,
    this.borderRadius = 5,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 10,
    ),
  });

  @override
  Widget build(BuildContext context) => _buildBody(context);

  BorderSide get _getColoredBorder => BorderSide(
        color: getThemeSecondaryColor,
        width: 1,
      );

  Widget _buildBody(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border(
            left: _getColoredBorder,
            right: _getColoredBorder,
            top: _getColoredBorder,
            bottom: _getColoredBorder,
          )),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
