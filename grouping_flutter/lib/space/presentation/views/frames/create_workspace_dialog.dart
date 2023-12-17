import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grouping_project/app/presentation/components/data_display/title_with_content.dart';
import 'package:grouping_project/core/theme/color.dart';
import 'package:grouping_project/space/presentation/view_models/create_workspace_view_model.dart';
import 'package:grouping_project/app/presentation/components/data_display/key_value_pair_widget.dart';
import 'package:grouping_project/space/presentation/views/components/profile_avatar.dart';
import 'package:grouping_project/app/presentation/components/buttons/user_action_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreateWorkspaceDialog extends StatelessWidget {
  CreateWorkspaceDialog({super.key});

  @override
  Widget build(BuildContext context) => _buildBody(context);

  TextStyle titleTextStyle(BuildContext context) =>
      Theme.of(context).textTheme.labelLarge!.copyWith(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          );

  TextStyle labelTextStyle(BuildContext context) =>
      Theme.of(context).textTheme.labelMedium!.copyWith(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          );

  EdgeInsets get _innerPadding => const EdgeInsets.all(20.0);

  final _tagEditingController = TextEditingController();

  Widget _buildBody(BuildContext context){
    return Consumer<CreateWorkspaceViewModel>(
        builder: (context, viewModel, child) => Dialog(
          backgroundColor: Colors.white,
          elevation: 0,
          child: PrimaryInfoFrame(
            color: viewModel.spaceColor,
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
                      title: "建立新小組", 
                      content: "建立你的團隊，並邀請成員加入",
                    ),
                    const Divider(),
                    _buildGroupBasicInfoInputSection(context),
                    const Gap(10),
                    _buildGroupAdditionalInfoInputSection(context),
                    const Gap(10),
                    _buildActionList(context),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }

  Widget _buildActionList(BuildContext context){
    return Consumer<CreateWorkspaceViewModel>(
      builder: (context, viewModel, child) => Row(
        children: [
          const Spacer(),
          UserActionButton.secondary(
            label: "取消", 
            primaryColor: viewModel.spaceColor,
            icon: const Icon(Icons.close),
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
          const Gap(10),
          UserActionButton.primary(
            label: "建立新小組", 
            primaryColor: viewModel.spaceColor,
            icon: const Icon(Icons.check),
            onPressed: () async {
              await viewModel.createWorkspace();
              if(context.mounted){
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget getProfileAvatar(BuildContext context, CreateWorkspaceViewModel viewModel){
    if(viewModel.newWorkspaceData.photo != null){
      return ProfileAvatar(
        themePrimaryColor: viewModel.spaceColor,
        label: "小組照片",
        avatarSize: 96,
        imageUrl: viewModel.newWorkspaceData.photo!.imageUri,
      );
    }
    if(viewModel.tempAvatarFile != null){
      return ProfileAvatar(
        themePrimaryColor: viewModel.spaceColor,
        label: "小組照片",
        imageUrl: File(viewModel.tempAvatarFile!.path,).path,
        avatarSize: 96,
      );
    }
    return ProfileAvatar(
      themePrimaryColor: viewModel.spaceColor,
      label: viewModel.newWorkspaceData.name,
      avatarSize: 96,
      // avatar: Icon(Icons.add_a_photo, size: 32, color: viewModel.spaceColor),
    );
  }

  Widget _buildGroupBasicInfoInputSection(BuildContext context) {
    return Consumer<CreateWorkspaceViewModel>(
      builder: (context, vm, child) => Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            KeyValuePairWidget<String, Widget>(
              primaryColor: vm.spaceColor,
              keyChild: "小組照片",
              valueChild:  Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    child: getProfileAvatar(context, vm),
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? file = await picker.pickImage(source: ImageSource.gallery);
                      if(context.mounted && file != null){
                        vm.updateProfileData = file;
                      }
                    }
                  ),
                  const Gap(5),
                  Visibility(
                    visible: vm.newWorkspaceData.photo != null || vm.tempAvatarFile != null,
                    child: IconButton(
                      onPressed: (){
                        vm.updateProfileData = null;
                      },
                      icon: Icon(Icons.delete , color: AppColor.logError,),
                    ),
                  )
                ],
              ), 
            ),
            KeyValuePairWidget<String, Widget>(
              primaryColor: vm.spaceColor,
              keyChild: "小組名稱", 
              valueChild: AppTextFormField(
                primaryColor: vm.spaceColor,
                hintText: "請輸入小組名稱",
                initialValue: vm.newWorkspaceData.name,
                onChanged: (value){
                  vm.spaceName = value!;
                },
            ),), 
            KeyValuePairWidget<String, Widget>(
              primaryColor: vm.spaceColor,
              keyChild: "小組介紹", 
              valueChild: AppTextFormField(
                primaryColor: vm.spaceColor,
                hintText: "請輸入小組介紹",
                initialValue: vm.newWorkspaceData.description,
                onChanged: (value){
                  vm.spaceDescription = value!;
                },
            ),), 
            KeyValuePairWidget<String, Widget>(
              primaryColor: vm.spaceColor,
              keyChild: "小組標籤", 
              valueChild: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: vm.newWorkspaceData.tags.isEmpty ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10,),
                  child: Column(
                    children: [
                      AppTextFormField(
                        controller: _tagEditingController,
                        hintText: "請輸入小組標籤",
                        primaryColor: vm.spaceColor,
                        // initialValue: vm.tag,
                        onChanged: (value){
                          if(value!=null && value.isNotEmpty){
                            vm.tag = value;
                          }
                        },
                        onSubmit: (value){
                          vm.addTag();
                          _tagEditingController.clear();
                        }
                      ), 
                      if(vm.newWorkspaceData.tags.isNotEmpty)
                        const Gap(10),
                      Row(
                        children: [
                            ...vm.newWorkspaceData.tags.map((tag) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Chip(
                              backgroundColor: vm.spaceColor.withOpacity(0.1),
                              deleteIcon: const Icon(Icons.close, size: 16,),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: vm.spaceColor, width: 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              label: Text('# ${tag.content}', style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                color: vm.spaceColor,
                                fontWeight: FontWeight.bold,
                              ),),
                              onDeleted: () {
                                vm.deleteTag(vm.newWorkspaceData.tags.indexOf(tag));
                              },
                            ),
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),), 
          ]),
    );
  }

  Widget _buildGroupAdditionalInfoInputSection(BuildContext context) {
    return Consumer<CreateWorkspaceViewModel>(
      builder: (context, vm, child) => KeyValuePairWidget(
          primaryColor: vm.spaceColor,
          keyChild: "佈景主題顏色",
          valueChild: "更改佈景主題顏色",
          action: DropdownButton(
            isDense: true,
            underline: const SizedBox(),
            value: vm.newWorkspaceData.themeColor,
            items: vm.spaceColors.map((color) => DropdownMenuItem(
              value: vm.spaceColors.indexOf(color),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            )).toList(),
            onChanged: (value){
              vm.spaceColorIndex = value as int;
            }
        )
        ),
    );
  }
}
