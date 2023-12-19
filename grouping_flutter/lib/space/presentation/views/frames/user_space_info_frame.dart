import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grouping_project/core/theme/color.dart';
import 'package:grouping_project/space/presentation/view_models/user_page_view_model.dart';
import 'package:grouping_project/space/presentation/views/components/layout/dashboard_frame_layout.dart';
import 'package:grouping_project/space/presentation/views/components/navigated_profile_info_card.dart';
import 'package:grouping_project/space/presentation/views/components/profile_avatar.dart';
import 'package:grouping_project/space/presentation/views/components/user_action_button.dart';
import 'package:grouping_project/space/presentation/views/frames/create_workspace_dialog.dart';
import 'package:provider/provider.dart';

class SpaceInfoFrame extends StatelessWidget{
  // SpaceInfoAndNavigatorFrame, display space info with expanded user information card and navigator route list 
  final Color frameColor;
  final double? frameHeight;
  final double? frameWidth;

  const SpaceInfoFrame({
    this.frameColor = Colors.white,
    this.frameHeight,
    this.frameWidth,
    super.key
  });

  @override
  Widget build(BuildContext context) => _buildBody(context);

  Widget _buildBody(BuildContext context){
    return DashboardFrameLayout(
      frameWidth: frameWidth,
      frameHeight: frameHeight,
      frameColor: frameColor,
      child: _buildSpaceInfo(context),
    );
  }
  
  Widget _buildSpaceInfo(BuildContext context) {
    final userData = Provider.of<UserDataProvider>(context, listen: false);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileAvatar(
            themePrimaryColor: frameColor,
            label: userData.currentUser?.name ?? "",
            avatarSize: 72,
            labelFontSize: 20,
          ),
          const Gap(10),
          Text("@user-5-${userData.currentUser?.name ?? ""}", style: Theme.of(context).textTheme.labelLarge!.copyWith(
            color: frameColor,
            fontWeight: FontWeight.bold,
          )),
          const Gap(10),
          Text(userData.currentUser?.name ?? "", style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          )),
          Divider(color: frameColor.withOpacity(0.2), thickness: 2,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("工作小組 (${userData.currentUser!.joinedWorkspaces.length})",
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: frameColor,
                  fontWeight: FontWeight.bold,
              )),
              const Spacer(),
            ],
          ),
          const Gap(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: UserActionButton.secondary(
                  onPressed: () => _onCreateGroup(context),
                  label: "創建小組",
                  primaryColor: frameColor,
                  icon: const Icon(Icons.add),
                ),
              ),
              const Gap(5),
              Expanded(
                child: UserActionButton.secondary(
                  onPressed: (){},
                  label: "加入小組",
                  primaryColor: frameColor,
                  icon: const Icon(Icons.group_add),
                ),
              ),
            ],
          ),
          const Gap(10),
          ...userData.currentUser!.joinedWorkspaces.map((workspace) => Padding(
            padding: const EdgeInsets.all(4.0),
            child: NavigatedProfileInfoCardButton(
              primaryColor: AppColor.getWorkspaceColorByIndex(workspace.themeColor),
              profileName: workspace.name,
              routerPath: "/app/workspace/${workspace.id}/home",
              profileImageURL: "",
            ),
          )),
        ],
      ),
    );
  }
  
  _onCreateGroup(BuildContext context) async {
    // open create group dialog
    await showDialog(
      context: context,
      builder: (context) => const CreateWorkspaceDialog()
    );
  }
}

