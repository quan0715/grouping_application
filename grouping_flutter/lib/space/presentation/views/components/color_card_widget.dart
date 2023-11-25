import 'package:flutter/material.dart';
import 'package:grouping_project/core/shared/color_widget_interface.dart';

class ColorCardWidget extends StatelessWidget implements WithThemePrimaryColor{
  final Color color;
  final bool withALLBorder;
  // if withALLBorder is true, then the border all around the card will be drawn, otherwise only the left border will be drawn
  final Widget? child;
  final double borderRadius;
  final EdgeInsets padding;
  @override
  Color get getThemePrimaryColor => color;

  const ColorCardWidget({
    super.key,
    required this.color,
    this.child,
    this.borderRadius = 5,
    this.withALLBorder = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 10,),
  });

  @override
  Widget build(BuildContext context) => _buildBody(context);

  BorderSide get _getFocusedBorder => BorderSide( color: getThemePrimaryColor, width: borderRadius,);
  BorderSide get _getUnfocusedBorder => BorderSide(color: getThemePrimaryColor, width: withALLBorder ? 1 : 0,);

  Widget _buildBody(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border(
          left: _getFocusedBorder,
          right: _getUnfocusedBorder,
          top: _getUnfocusedBorder,
          bottom: _getUnfocusedBorder,
        )
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}