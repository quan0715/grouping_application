import 'package:flutter/material.dart';
import 'package:grouping_project/dashboard/domain/entities/user_profile_entity.dart';
import 'package:grouping_project/dashboard/presentation/views/components/profile_avatar.dart';

class MobileAppBar extends StatelessWidget implements PreferredSizeWidget{
  final Color themePrimaryColor;
  final UserProfileEntity profile;

  const MobileAppBar({
    super.key,
    required this.themePrimaryColor,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) => _buildBody(context); 

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  String getTitle(String userName) => '$userName 的儀表板';

  Widget _buildBody(BuildContext context) {
    return AppBar(
      centerTitle: false,
      title: Row(
        children: [
          ProfileAvatar(
            themePrimaryColor: themePrimaryColor,
            label: profile.accountName,
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
}

