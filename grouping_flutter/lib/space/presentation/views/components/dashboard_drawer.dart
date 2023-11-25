import 'package:flutter/material.dart';
import 'package:grouping_project/core/shared/color_widget_interface.dart';
import 'package:grouping_project/space/domain/entities/space_profile_entity.dart';
import 'package:grouping_project/space/presentation/views/components/drawer_navigation_card.dart';
import 'package:grouping_project/space/presentation/views/components/profile_avatar.dart';

class DashboardDrawer extends StatelessWidget implements WithThemePrimaryColor{

  const DashboardDrawer({
    super.key,
    required this.selectedProfile,
    required this.userProfiles,
    required this.workspaceProfiles,
  });

  final SpaceProfileEntity selectedProfile;
  final List<SpaceProfileEntity> userProfiles;
  final List<SpaceProfileEntity> workspaceProfiles;


  @override
  Color get getThemePrimaryColor => const Color(0xFF7D5800);

  TextStyle get _titleTextStyle 
    => const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  // outer padding of the drawer children
  EdgeInsets get _outerPadding 
    => const EdgeInsets.symmetric(horizontal: 10, vertical: 20,);

  // header padding of the drawer children 
  EdgeInsets get _headDrawerPadding 
    => const EdgeInsets.symmetric(horizontal: 10, vertical: 20,);

  EdgeInsets get _blockPadding 
    => const EdgeInsets.symmetric(horizontal: 0, vertical: 5,);

  @override 
  Widget build(BuildContext context) => _buildBody(context);

  Widget _buildBody(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Padding(
        padding: _outerPadding,
        child: ListView(
          children: [
            _getDrawerHeader(context),
            _getUserProfileList(context),
            _getWorkspaceProfileList(context),
          ],
        ),
      ),
    );
  }

  Widget _getDrawerHeader(BuildContext context){
    return Padding(
      padding: _headDrawerPadding,
      child: Row(
        children: [
          ProfileAvatar(
            themePrimaryColor: getThemePrimaryColor,
            label: "Quan",
          ),
          const SizedBox(width: 10,),
          const Text(
            "Quan",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
          ),
        ],
      ),
    );
  }

  Widget _getUserProfileList(BuildContext context){
    return Padding(
      padding: _blockPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("使用者 User", style: _titleTextStyle),
          const SizedBox(height: 5,),
          ...userProfiles.map((profile) => Padding(
            padding: _blockPadding,
            child: DrawerNavigationCard (profile: profile, isSelected: profile == selectedProfile,),
          )),
        ],
      ),
    );
  }

  Widget _getWorkspaceProfileList(BuildContext context){
    return Padding(
      padding: _blockPadding, 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("工作區 Workspace", style: _titleTextStyle),
          const SizedBox(height: 5,),
          ...workspaceProfiles.map((profile) => Padding(
            padding: _blockPadding,
            child: DrawerNavigationCard (profile: profile, isSelected: profile == selectedProfile,),
          )),
        ],
      ),
    );
  }
} 