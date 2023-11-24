import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget{
  final Color themePrimaryColor;
  final Widget? avatar;
  final String label;

  const ProfileAvatar({
    super.key,
    required this.themePrimaryColor,
    required this.label,
    this.avatar,
  });

  Widget _getAvatar() {
    if (avatar != null) {
      return avatar!;
    }
    return Center(child: Text(label.substring(0, 2), style: TextStyle(color: themePrimaryColor, fontSize: 14, fontWeight: FontWeight.bold)));
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: themePrimaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: themePrimaryColor.withOpacity(0.3), width: 2),
        // image: const DecorationImage(
        //   image: AssetImage('assets/images/profile_male.png'),
        //   fit: BoxFit.fill,
        // ),
      ),
      child: _getAvatar(),
    );
  }

  @override
  Widget build(BuildContext context) => _buildBody(context);

}