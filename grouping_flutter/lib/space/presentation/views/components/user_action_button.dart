import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grouping_project/core/shared/color_widget_interface.dart';

class UserActionButton extends ElevatedButton implements WithThemePrimaryColor{ 
  final Color? primaryColor;

  const UserActionButton({
    super.key,
    super.onPressed,
    this.primaryColor, 
    super.style,
    required super.child,
  });

  static ButtonStyle _getButtonStyle(bool isPrimary, Color color) => ElevatedButton.styleFrom(
      foregroundColor: isPrimary ? Colors.white : color,
      backgroundColor: isPrimary ? color : Colors.white,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(color: color.withOpacity(0.3), width:1),
      ),
    );

  factory UserActionButton.secondary({
    required VoidCallback onPressed,
    required String label,
    required Color primaryColor,
    Widget? icon,
  }) => UserActionButton(
    onPressed: onPressed,
    primaryColor: primaryColor,
    style: _getButtonStyle(false, primaryColor),
    child: Row(
      children: [
        icon != null ? Icon((icon as Icon).icon,) : const SizedBox.shrink(),
        const Gap(5),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    ),
  );

  factory UserActionButton.primary({
    required VoidCallback onPressed,
    required String label,
    required Color primaryColor,
    Widget? icon,
  }) => UserActionButton(
    onPressed: onPressed,
    primaryColor: primaryColor,
    style: _getButtonStyle(true, primaryColor),
    child: Row(
      children: [
        icon != null ? Icon((icon as Icon).icon,) : const SizedBox.shrink(),
        const Gap(5),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    ),
  );
  
  @override
  Color get getThemePrimaryColor => primaryColor ?? Colors.white;
}