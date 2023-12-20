import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grouping_project/app/presentation/components/components.dart';
import 'package:grouping_project/app/presentation/components/data_display/title_with_content.dart';
import 'package:grouping_project/core/theme/color.dart';
import 'package:grouping_project/space/presentation/view_models/join_workspace_view_model.dart';
import 'package:grouping_project/app/presentation/components/data_display/key_value_pair_widget.dart';
import 'package:grouping_project/space/presentation/views/components/layout/dashboard_frame_layout.dart';
import 'package:grouping_project/space/presentation/views/components/profile_avatar.dart';
import 'package:provider/provider.dart';


class JoinWorkspaceDialog extends StatelessWidget {
  JoinWorkspaceDialog({super.key});

  final _formKey = GlobalKey<FormState>();
    
  EdgeInsets get _innerPadding => const EdgeInsets.all(20.0);

  _onSubmit(BuildContext context, JoinWorkspaceViewModel viewModel) async {
    if(_formKey.currentState!.validate()){
      await viewModel.getWorkspace();
    }
  }

  _onJoin(BuildContext context, JoinWorkspaceViewModel viewModel) async {
    await viewModel.joinWorkspace();
    if(context.mounted){
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) => _buildBody(context);

  Widget _buildBody(BuildContext context) {
    return Consumer<JoinWorkspaceViewModel>(
      builder: (context, viewModel, child) => Dialog(
        backgroundColor: viewModel.spaceColor,
        elevation: 0,
        child: DashboardFrameLayout(
          frameColor: viewModel.spaceColor,
          child: Padding(
            padding: _innerPadding,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.4,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TitleWithContent(
                    title: "輸入你的小組編號", 
                    content: "加入你的小組，一起開始吧！",
                  ),
                  const Divider(),
                  _buildSearchTable(context),
                  MessagesList(messageService: viewModel.messageService),
                  const Gap(10),
                  _buildSearchResult(context),
                  const Gap(10),
                  _buildActionList(context, viewModel),
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
 
  Widget _buildSearchResult(BuildContext context){  
    return Consumer<JoinWorkspaceViewModel>(
      builder: (context, viewModel, child) {
        if(viewModel.joinedWorkspace == null){
          return Container();
        }
        else{
          return DashboardFrameLayout(
            frameColor: viewModel.workspaceColor,
            child: Padding(
              padding: _innerPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileAvatar(
                    themePrimaryColor: viewModel.workspaceColor, 
                    label: "Profile",
                    imageUrl: viewModel.joinedWorkspace!.photo?.imageUri ?? '',
                    avatarSize: 72,
                  ),
                  // const Gap(10),
                  KeyValuePairWidget<String, Widget>(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                    primaryColor: viewModel.workspaceColor,
                    keyChild: "@group-${viewModel.joinedWorkspace!.id}",
                    valueChild: Text(viewModel.joinedWorkspace!.name, style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      // color: viewModel.workspaceColor,
                      fontWeight: FontWeight.bold,
                    ),),),
                   KeyValuePairWidget<String, Widget>(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                    primaryColor: viewModel.workspaceColor,
                    keyChild: "小組介紹",
                    valueChild: Text(viewModel.joinedWorkspace!.description, style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    ),),),
                  // const Gap(10),
                  Row(
                  children: [
                    ...viewModel.joinedWorkspace!.tags.map((tag){
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ColorTagChip(
                          tagString: '# ${tag.content}',
                          color: viewModel.workspaceColor,
                        )
                      );}),
                  ],)
                ],
              )
            ),
          );
      }
    });
  }

  Widget _buildSearchTable(BuildContext context){
    return Consumer<JoinWorkspaceViewModel>(
      builder: (context, viewModel, child) => Form(
        key: _formKey,
        child: Row(
          children: [
            Expanded(
              child: AppTextFormField(
                primaryColor: viewModel.spaceColor,
                hintText: "輸入小組代碼",
                // controller: _tagEditingController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '請輸入小組代碼';
                  }
                  return null;
                },
                onChanged: (value) {
                  viewModel.workspaceIndex = value!;
                },
                onSubmit: (value){
                  _onSubmit(context, viewModel);
                },
              )
            ),
            const Gap(10),
            IconButton(
              onPressed: () async {
                if(_formKey.currentState!.validate()){
                  await viewModel.getWorkspace();
                }
              },
              icon: Icon(Icons.search, color: viewModel.spaceColor,)
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionList(BuildContext context, viewModel){
    return Row(
        children: [
          const Spacer(),
          UserActionButton.secondary(
            label: "取消", 
            primaryColor: AppColor.mainSpaceColor,
            icon: const Icon(Icons.close),
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
          const Gap(10),
          UserActionButton.primary(
            label: "加入新小組", 
            primaryColor: AppColor.mainSpaceColor,
            icon: const Icon(Icons.check),
            onPressed: () => _onJoin(context, viewModel),
          ),
        ],
    );
  }

}