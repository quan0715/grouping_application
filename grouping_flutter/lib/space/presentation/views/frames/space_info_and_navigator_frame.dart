import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grouping_project/core/shared/color_widget_interface.dart';
import 'package:grouping_project/space/presentation/view_models/user_page_view_model.dart';
import 'package:grouping_project/space/presentation/views/components/navigated_profile_info_card.dart';
import 'package:grouping_project/space/presentation/views/components/profile_avatar.dart';
import 'package:grouping_project/space/presentation/views/components/user_action_button.dart';
import 'package:provider/provider.dart';

class SpaceInfoAndNavigatorFrame extends StatelessWidget implements WithThemePrimaryColor{
  // SpaceInfoAndNavigatorFrame, display space info with expanded user information card and navigator route list 
  final Color frameColor;
  final double? frameHeight;
  final double? frameWidth;

  const SpaceInfoAndNavigatorFrame({
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
    List userWorkspaceProfiles = Provider.of<UserPageViewModel>(context, listen: false).workspaceProfiles;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileAvatar(
          themePrimaryColor: getThemePrimaryColor,
          label: "張百寬",
          avatarSize: 55,
          labelFontSize: 20,
        ),
        const Gap(10),
        Text("@user-5-張百寬", style: Theme.of(context).textTheme.labelLarge!.copyWith(
          color: getThemePrimaryColor,
          fontWeight: FontWeight.bold,
        )),
        const Gap(10),
        Text("帥哥寬", style: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        )),
        Divider(color: getThemePrimaryColor.withOpacity(0.2), thickness: 2,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("工作小組 (${userWorkspaceProfiles.length})",
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: getThemePrimaryColor,
                fontWeight: FontWeight.bold,
            )),
            const Spacer(),
            UserActionButton.secondary(
              onPressed: (){},
              label: "創建小組",
              primaryColor: getThemePrimaryColor,
              icon: const Icon(Icons.add),
            ),
            const Gap(5),
            UserActionButton.secondary(
              onPressed: (){},
              label: "加入小組",
              primaryColor: getThemePrimaryColor,
              icon: const Icon(Icons.group_add),
            ),
          ],
        ),
        const Gap(10),
        ...userWorkspaceProfiles.map((profile) => Padding(
          padding: const EdgeInsets.all(4.0),
          child: NavigatedProfileInfoCardButton(profile: profile,),
        )),
      ],
    );
  }
  
  @override
  Color get getThemePrimaryColor => frameColor;
}

