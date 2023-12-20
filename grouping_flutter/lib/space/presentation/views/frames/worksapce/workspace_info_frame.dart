import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grouping_project/app/presentation/components/components.dart';
import 'package:grouping_project/app/presentation/components/data_display/key_value_pair_widget.dart';
import 'package:grouping_project/core/shared/color_widget_interface.dart';
import 'package:grouping_project/space/presentation/view_models/workspace_view_model.dart';
import 'package:grouping_project/space/presentation/views/components/layout/dashboard_frame_layout.dart';
import 'package:grouping_project/space/presentation/views/components/member_widget.dart';
import 'package:grouping_project/space/presentation/views/components/profile_avatar.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

class WorkspaceInfoFrame extends StatelessWidget implements WithThemePrimaryColor{
  // SpaceInfoAndNavigatorFrame, display space info with expanded user information card and navigator route list 
  final Color frameColor;
  final double? frameHeight;
  final double? frameWidth;

  const WorkspaceInfoFrame({
    this.frameColor = Colors.white,
    this.frameHeight,
    this.frameWidth,
    super.key
  });


  @override
  Widget build(BuildContext context) => _buildBody(context);

  Widget _buildBody(BuildContext context){
    return DashboardFrameLayout(
      frameWidth: frameWidth ?? MediaQuery.of(context).size.width,
      frameHeight: frameHeight ?? MediaQuery.of(context).size.height,
      frameColor: frameColor,
      child: _buildSpaceInfo(context),
    );
  }
  
  Widget _buildSpaceInfo(BuildContext context) {
    final workspaceData = Provider.of<GroupDataProvider>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         ProfileAvatar(
            themePrimaryColor: frameColor,
            label: workspaceData.currentWorkspace!.name,
            avatar: workspaceData.currentWorkspace!.photo != null
              ? Image.network(
                workspaceData.currentWorkspace!.photo!.imageUri, 
                fit: BoxFit.fitWidth, 
              ) : null,
            avatarSize: 72,
            labelFontSize: 20,
          ),
        const Gap(5),
        KeyValuePairWidget<String, Widget>(
          gap: 3,
          primaryColor: frameColor,
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          keyChild: "@group-${workspaceData.currentWorkspace?.id ?? "error"}", 
          valueChild: Text(workspaceData.currentWorkspace?.name ?? "error", style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          )),
        ),
        const Gap(5),
        Row(
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              spacing: 4.0,
              runSpacing: 4.0,
              children: [
                  ...workspaceData.currentWorkspace!.tags.map((tag) => ColorTagChip(
                    color: frameColor,
                    tagString: "# ${tag.content}"
                  )),
              ],
            ),
          ],
        ), 
        const Gap(5),
        KeyValuePairWidget(
          gap: 3,
          primaryColor: frameColor,
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
          keyChild: "小組介紹", 
          valueChild: workspaceData.currentWorkspace?.description ?? "",
        ),
        const Gap(5),
        KeyValuePairWidget<String, Widget>(
          gap: 3,
          primaryColor: frameColor,
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
          keyChild: "小組成員", 
          valueChild: Column(
            children: [
              ... workspaceData.currentWorkspace!.members.map((member) => Padding(
                padding: const EdgeInsets.all(4.0),
                child: MemberWidget(
                  themePrimaryColor: frameColor,
                  profile: member,
                ),
              ))
            ],
          )
        ),     
      ],
    );
  }
  
  @override
  Color get getThemePrimaryColor => frameColor;
}

