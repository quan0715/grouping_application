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
    this.withALLBorder = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 8,),
  });

  @override
  Widget build(BuildContext context) => _buildBody(context);
  Widget _buildBody(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Padding(
        padding: EdgeInsets.all(borderRadius),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: color, width: borderRadius,),
              ),
            ),
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}