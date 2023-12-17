import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 10,),
  });

  @override
  Widget build(BuildContext context) => _buildBody(context);

  // BorderSide get _getFocusedBorder => BorderSide( color: getThemePrimaryColor, width: borderRadius,);
  // BorderSide get _getUnfocusedBorder => BorderSide(color: Colors.white, width: 0,);

  Widget _buildBody(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(borderRadius),
        // border: Border(
        //   left: _getFocusedBorder,
        //   right: _getUnfocusedBorder,
        //   top: _getUnfocusedBorder,
        //   bottom: _getUnfocusedBorder,
        // )
      ),
      child: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: borderRadius,
                decoration: BoxDecoration(
                  color: getThemePrimaryColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(borderRadius),
                    bottomLeft: Radius.circular(borderRadius),
                  ),
                ),
                //child: Gap(10),
              ),
              Expanded(
                flex: 80,
                child: Padding(
                  padding: padding,
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}