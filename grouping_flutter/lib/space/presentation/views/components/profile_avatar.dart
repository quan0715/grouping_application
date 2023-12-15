import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget{
  final Color themePrimaryColor;
  final Widget? avatar;
  final String label;
  final double avatarSize;
  final double labelFontSize;
  final double radius;
  
  const ProfileAvatar({
    super.key,
    required this.themePrimaryColor,
    required this.label,
    this.avatar,
    this.avatarSize = 40,
    this.labelFontSize = 14,
    this.radius = 10,
  });

  Widget _getAvatar(BuildContext context) {
    if (avatar != null) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
        ),
        child: avatar!);
    }
    return Center(
      child: Text(
        label.substring(0, 2),
        style: Theme.of(context).textTheme.labelSmall!.copyWith(
          color: themePrimaryColor,
          // fontSize: labelFontSize,
          fontWeight: FontWeight.bold
        ))
      );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        color: themePrimaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: themePrimaryColor.withOpacity(0.3), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: _getAvatar(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => _buildBody(context);

}