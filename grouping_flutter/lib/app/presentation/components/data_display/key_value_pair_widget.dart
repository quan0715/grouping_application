import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grouping_project/core/shared/color_widget_interface.dart';
import 'package:grouping_project/core/theme/color.dart';

class KeyValuePairWidget<K, V> extends StatelessWidget{
  final K keyChild;
  final V valueChild;
  final Widget? action;
  final Color primaryColor;
  final double borderRadius;
  final EdgeInsets padding;
  final Widget? child;
  final double gap; 
  const KeyValuePairWidget({
    super.key,
    this.primaryColor = Colors.white,
    required this.keyChild,
    required this.valueChild,
    this.action,
    this.gap = 5,
    this.borderRadius = 5,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 5,
    ), 
    
    this.child,
  });

  TextStyle keyTextStyle(BuildContext context) => 
    Theme.of(context).textTheme.titleSmall!.copyWith(
      color: primaryColor, 
      fontWeight: FontWeight.bold
    );

  TextStyle valueTextStyle(BuildContext context) => 
    Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColor.onSurfaceColor
    );

  Widget getKeyWidget(BuildContext context){
    switch (K){
      case Widget:
        return keyChild as Widget;
      case String:
        return Text(keyChild as String, style: keyTextStyle(context));
      default:
        return Text("wrong value Type", style: keyTextStyle(context));
    }
  }

  Widget getValueWidget(BuildContext context){
    switch (V){
      case Widget:
        return valueChild as Widget;
      case String:
        return Text(valueChild as String, style: valueTextStyle(context));
      default:
        return Text("wrong value Type", style: valueTextStyle(context));
    }
  }


  @override
  Widget build(BuildContext context) => _buildBody(context);

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
       //  mainAxisAlignment: MainAxisAlignment.spaceBetween, 
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getKeyWidget(context),
                Gap(gap),
                getValueWidget(context),
              ]
            ),
          ),
          action ?? const SizedBox(),
        ]
      ),
    );
  }
}


class PrimaryInfoFrame extends StatelessWidget implements WithThemePrimaryColor{
  final Color color;
  final Widget? child;
  final double borderRadius;
  final EdgeInsets padding;

  const PrimaryInfoFrame({
    super.key,
    required this.color,
    required this.child,
    this.borderRadius = 5,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 10,
    ),
  });

  @override
  Widget build(BuildContext context) => _buildBody(context);

  Color get backgroundColor => color.withOpacity(0.1);

  Widget _buildBody(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white ,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Container(
        color: color.withOpacity(0.1),
        child: Padding(
          padding: padding,
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    );
  }

  @override
  Color get getThemePrimaryColor => color;

}

