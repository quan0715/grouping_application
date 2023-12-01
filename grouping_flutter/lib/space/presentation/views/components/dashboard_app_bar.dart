import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grouping_project/core/shared/color_widget_interface.dart';
import 'package:grouping_project/space/domain/entities/space_profile_entity.dart';
import 'package:grouping_project/space/presentation/views/components/profile_avatar.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget, WithThemePrimaryColor{
  // final Color color;
  final SpaceProfileEntity profile;

  const DashboardAppBar({
    super.key,
    // required this.color,
    required this.profile,
  });

  @override
  Color get getThemePrimaryColor => profile.spaceColor;

  @override
  Widget build(BuildContext context) => _buildBody(context); 

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  String getTitle(String userName) => userName;

  Widget _buildBody(BuildContext context){
    return kIsWeb ? _buildWebView(context) : _buildMobileView(context);
  }

  Widget _getMenuButton(BuildContext context){
    return IconButton(
      onPressed: () => Scaffold.maybeOf(context)!.openDrawer(),
      icon: Icon(Icons.menu, color: getThemePrimaryColor),
    );
  }

  Widget _getTitleWidget(BuildContext context){
    return Row(
      children: [
        ProfileAvatar(
          themePrimaryColor: getThemePrimaryColor,
          label: profile.spaceName,
          avatarSize: 35,
        ),
        const SizedBox(width: 10,),
        Text(
          getTitle(profile.spaceName,),
          style: TextStyle(color: getThemePrimaryColor, fontSize: 16, fontWeight: FontWeight.bold)
        ),
      ],
    );
  }

  Widget _buildWebView(BuildContext context){
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: false,
      leading: _getMenuButton(context),
      title: _getTitleWidget(context),
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildMobileView(BuildContext context){
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: false,
      leading: IconButton(
        onPressed: () => Scaffold.maybeOf(context)!.openDrawer(),
        icon: Icon(Icons.menu, color: getThemePrimaryColor),
      ),
      title: _getTitleWidget(context),
      automaticallyImplyLeading: false,
      actions: [
        _getMenuButton(context),
      ],
    );

  }

}
