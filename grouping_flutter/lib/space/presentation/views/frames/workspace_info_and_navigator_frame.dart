import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grouping_project/core/shared/color_widget_interface.dart';
// import 'package:grouping_project/space/domain/entities/space_profile_entity.dart';
import 'package:grouping_project/space/domain/entities/workspace_entity.dart';
// import 'package:grouping_project/space/presentation/view_models/user_page_view_model.dart';
// import 'package:grouping_project/space/presentation/view_models/workspace_view_model.dart';
import 'package:grouping_project/space/presentation/views/components/member_widget.dart';
// import 'package:grouping_project/space/presentation/views/components/navigated_profile_info_card.dart';
import 'package:grouping_project/space/presentation/views/components/profile_avatar.dart';
// import 'package:grouping_project/space/presentation/views/components/user_action_button.dart';
// import 'package:provider/provider.dart';

class WorkspaceInfoAndNavigatorFrame extends StatelessWidget implements WithThemePrimaryColor{
  // SpaceInfoAndNavigatorFrame, display space info with expanded user information card and navigator route list 
  final Color frameColor;
  final double? frameHeight;
  final double? frameWidth;
  final WorkspaceEntity workspace;

  const WorkspaceInfoAndNavigatorFrame({
    required this.workspace,
    this.frameColor = Colors.white,
    this.frameHeight,
    this.frameWidth,
    super.key
  });


  @override
  Widget build(BuildContext context) => _buildBody(context);

  Widget _buildBody(BuildContext context){
    final frameDecoration = BoxDecoration(
      color: frameColor.withOpacity(0.05),
      borderRadius: const BorderRadius.all(
        Radius.circular(10.0),
      ),
    );
    return Container(
      width: frameWidth,
      height: frameHeight,
      decoration: frameDecoration,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSpaceInfo(context),
            // _buildNavigator(context),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSpaceInfo(BuildContext context) {
    // SpaceProfileEntity userWorkspaceProfiles = Provider.of<WorkspaceViewModel>(context, listen: false).workspaceProfile;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileAvatar(
          themePrimaryColor: getThemePrimaryColor,
          label: "grouping",          // TODO: don't actually know what label is
          avatarSize: 55,
          labelFontSize: 20,
        ),
        const Gap(10),
        Text("@group-0743", style: Theme.of(context).textTheme.labelLarge!.copyWith(       // TODO: nickname?
          color: getThemePrimaryColor,
          fontWeight: FontWeight.bold,
        )),
        const Gap(10),
        Text(workspace.name, style: Theme.of(context).textTheme.titleLarge!.copyWith(         // TODO: name?
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        )),
        Divider(color: getThemePrimaryColor.withOpacity(0.2), thickness: 2,),
        Text("成員",
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: getThemePrimaryColor,
                fontWeight: FontWeight.bold,
            )),
        const Gap(10),
        ...workspace.members.map((member) => Padding(padding: const EdgeInsets.all(4.0), child: MemberWidget(profile: member, themePrimaryColor: getThemePrimaryColor),))
        // ...userWorkspaceProfiles.map((profile) => Padding(
        //   padding: const EdgeInsets.all(4.0),
        //   child: NavigatedProfileInfoCardButton(profile: profile,),
        // )),
      ],
    );
  }
  
  @override
  Color get getThemePrimaryColor => frameColor;
}

