import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grouping_project/core/theme/color.dart';
import 'package:grouping_project/space/data/models/workspace_model.dart';
import 'package:grouping_project/space/domain/entities/user_entity.dart';
import 'package:grouping_project/space/presentation/views/components/navigated_profile_info_card.dart';
import 'package:grouping_project/space/presentation/views/components/profile_avatar.dart';

class DashboardDrawer extends StatelessWidget {

  const DashboardDrawer({
    super.key,
    required this.primaryColor,
    required this.userProfiles,
    this.isSelectedUserSpace = true,
    this.selectedProfileId,
    required this.workspaceProfiles,
  }) : 
    assert(selectedProfileId != null || isSelectedUserSpace == true),
    assert(selectedProfileId == null || isSelectedUserSpace != false);
  // assert when  the selected profile is user profile selectedProfileId == null

  final Color primaryColor;
  final bool isSelectedUserSpace ;
  final int? selectedProfileId;
  final List<WorkspaceModel> workspaceProfiles;
  final UserEntity userProfiles;

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
            themePrimaryColor: primaryColor,
            label: userProfiles.name,
            avatar: userProfiles.photo != null && userProfiles.photo!.data.isNotEmpty 
              ? Image.network(userProfiles.photo!.data) : null,
            avatarSize: 35,
          ),
          const Gap(5),
          Text(
            userProfiles.name,
            style: _titleTextStyle,
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
          Text("個人儀表板", style: _titleTextStyle),
          const Gap(5),
          Padding(
            padding: _blockPadding,
            child: NavigatedProfileInfoCardButton (
              primaryColor:  primaryColor,
              profileName: userProfiles.name,
              routerPath: "/app/user/${userProfiles.id}/home",
              profileImageURL: userProfiles.photo != null && userProfiles.photo!.data.isNotEmpty 
                ? userProfiles.photo!.data : null,
              isSelected: isSelectedUserSpace,
            ),
          ),
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
          Text("小組工作區", style: _titleTextStyle),
          const SizedBox(height: 5,),
          ...workspaceProfiles.map<Widget>((workspaceProfiles) => Padding(
            padding: _blockPadding,
            child: NavigatedProfileInfoCardButton (
              primaryColor: AppColor.getWorkspaceColorByIndex(workspaceProfiles.themeColor),
              profileName: workspaceProfiles.name,
              routerPath: "/app/workspace/${workspaceProfiles.id}/home",
              profileImageURL: workspaceProfiles.photo != null && workspaceProfiles.photo!.data.isNotEmpty 
                ? workspaceProfiles.photo!.data : null,
              isSelected: !isSelectedUserSpace || selectedProfileId == workspaceProfiles.id,
            ),
          )),
        ],
      ),
    );
  }
} 