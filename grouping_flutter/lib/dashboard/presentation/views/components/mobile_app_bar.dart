import 'package:flutter/material.dart';
import 'package:grouping_project/dashboard/domain/entities/user_profile_entity.dart';

class MobileAppBar extends StatelessWidget implements PreferredSizeWidget{
  final Color themePrimaryColor;
  final UserProfileEntity profile;

  const MobileAppBar({
    super.key,
    required this.themePrimaryColor,
    required this.profile,
  });

  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: themePrimaryColor.withOpacity(0.3), width: 2)
            ),
            child: Center(
              child: Text(profile.accountName[0]),
            ),
          ),
          const SizedBox(width: 10,),
          Text(
            getTitle(profile.accountName,),
            style: TextStyle(color: themePrimaryColor, fontSize: 16, fontWeight: FontWeight.bold)
          ),
        ],
      ),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          onPressed: () => Scaffold.maybeOf(context)!.openDrawer(),
          icon: Icon(Icons.menu, color: themePrimaryColor,),
        ),
      ],
    );
  }

  String getTitle(String userName) {
    return '$userName 的儀表板';
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
