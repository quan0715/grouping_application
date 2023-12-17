import 'package:flutter/material.dart';

class DashboardFrameLayout extends StatelessWidget{

  final double? frameWidth;
  final double? frameHeight;
  final Color? frameColor;
  final Widget child;

  const DashboardFrameLayout({
    super.key,
    required this.child,
    this.frameWidth,
    this.frameHeight,
    this.frameColor
  });

  @override
  Widget build(BuildContext context) => _buildBody(context);

  Widget _buildBody(BuildContext context) {
    return Container(
      width: frameWidth,
      height: frameHeight,
      decoration: BoxDecoration(
        color: Color.lerp(Colors.white, frameColor, 0.05), 
        borderRadius: const BorderRadius.all(Radius.circular(10.0),
      )),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: child,
      )
    );
  }
}