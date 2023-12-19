import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grouping_project/app/presentation/components/components.dart';
import 'package:grouping_project/app/presentation/components/data_display/title_with_content.dart';
import 'package:grouping_project/core/theme/color.dart';
import 'package:grouping_project/space/presentation/view_models/create_workspace_view_model.dart';
import 'package:grouping_project/app/presentation/components/data_display/key_value_pair_widget.dart';
import 'package:grouping_project/space/presentation/views/components/profile_avatar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreateWorkspaceDialog extends StatefulWidget {
  const CreateWorkspaceDialog({super.key});
  // after create workspace, return workspace data

  @override
  State<CreateWorkspaceDialog> createState() => _CreateWorkspaceDialogState();
}

class _CreateWorkspaceDialogState extends State<CreateWorkspaceDialog> {
  @override
  Widget build(BuildContext context) => _buildBody(context);

  final _formKey = GlobalKey<FormState>();
  final _tagFocusNode = FocusNode();
  final _spaceNameFocusNode = FocusNode();
  final _spaceDescriptionFocusNode = FocusNode();

  EdgeInsets get _innerPadding => const EdgeInsets.all(20.0);

  final _tagEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _spaceNameFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _tagEditingController.dispose();
    _tagFocusNode.dispose();
    _spaceNameFocusNode.dispose();
    _spaceDescriptionFocusNode.dispose();
    super.dispose();
  }

  Future<void> _onCreate(CreateWorkspaceViewModel vm) async{
    if(_formKey.currentState!.validate()){
      var status = await vm.createWorkspace();
      if(status && context.mounted){
        Navigator.of(context).pop(vm.newWorkspaceData);
      }
    } 
  }

  void _onCancel(){
    Navigator.of(context).pop();
  }



  Widget _buildBody(BuildContext context){
    return Consumer<CreateWorkspaceViewModel>(
        builder: (context, viewModel, child) => Dialog(
          backgroundColor: Colors.white,
          elevation: 0,
          child: PrimaryInfoFrame(
            color: viewModel.spaceColor,
            padding: _innerPadding,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.4,
              ),
              child: Form(
                key: _formKey,
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
                    MessagesList(messageService: viewModel.messageService),
                    _buildGroupBasicInfoInputSection(context),
                    const Gap(10),
                    _buildActionList(viewModel),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }

  Widget _buildActionList(CreateWorkspaceViewModel viewModel){
    return Row(
        children: [
          const Spacer(),
          UserActionButton.secondary(
            label: "取消", 
            primaryColor: viewModel.spaceColor,
            icon: const Icon(Icons.close),
            onPressed: _onCancel, 
          ),
          const Gap(10),
          UserActionButton.primary(
            label: "建立新小組", 
            primaryColor: viewModel.spaceColor,
            icon: const Icon(Icons.check),
            onPressed: () async  => await _onCreate(viewModel)
          ),
        ],
    );
  }

  String _getProfilePreviewURL(CreateWorkspaceViewModel viewModel){
    if(viewModel.newWorkspaceData.photo != null){
      return viewModel.newWorkspaceData.photo!.imageUri;
    }
    if(viewModel.tempAvatarFile != null){
      return File(viewModel.tempAvatarFile!.path,).path;
    }
    return "";
  }

  Widget _buildGroupBasicInfoInputSection(BuildContext context) {
    return Consumer<CreateWorkspaceViewModel>(
      builder: (context, vm, child) => Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _spaceProfileUploadFrame(vm),
            _spaceNameInputFrame(vm),
            _spaceDescriptionInputFrame(vm),
            _spaceTagFrame(vm),
            _spaceThemeSelectFrame(vm)
          ]),
    );
  }

  Widget _spaceTagFrame(CreateWorkspaceViewModel vm){
    return KeyValuePairWidget<String, Widget>(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextFormField(
              focusNode: _tagFocusNode,
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
                vm.addTag(value!);
                _tagEditingController.clear();
                _tagFocusNode.requestFocus();
              }
            ), 
            if(vm.newWorkspaceData.tags.isNotEmpty)
              const Gap(10),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              spacing: 4.0,
              runSpacing: 4.0,
              children: [
                  ...vm.newWorkspaceData.tags.map((tag) => Chip(
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
                  )),
              ],
            ),
          ],
        ),
      ),
    ),);
  } 

  Widget _spaceProfileUploadFrame(CreateWorkspaceViewModel vm){
    String profilePreviewURL = _getProfilePreviewURL(vm);
    return KeyValuePairWidget<String, Widget>(
      primaryColor: vm.spaceColor,
      keyChild: "小組照片",
      valueChild:  Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            child: ProfileAvatar(
              themePrimaryColor: vm.spaceColor,
              label: vm.newWorkspaceData.name,
              avatarSize: 96,
              imageUrl: profilePreviewURL,
              avatar: profilePreviewURL.isEmpty ? Icon(Icons.add_a_photo, size: 24, color: vm.spaceColor) : null
            ),
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
    );
  }

  Widget _spaceNameInputFrame(CreateWorkspaceViewModel vm){
    return KeyValuePairWidget<String, Widget>(
      primaryColor: vm.spaceColor,
      keyChild: "小組名稱",
      valueChild:  AppTextFormField(
        focusNode: _spaceNameFocusNode,
        primaryColor: vm.spaceColor,
        validator: vm.spaceNameValidator,
        hintText: "請輸入小組名稱",
        initialValue: vm.newWorkspaceData.name,
        onChanged: (value) => vm.spaceName = value!,
        onSubmit: (value) => _spaceDescriptionFocusNode.requestFocus(),
      ),
    );
  }

  Widget _spaceDescriptionInputFrame(CreateWorkspaceViewModel vm){
    return KeyValuePairWidget<String, Widget>(
      primaryColor: vm.spaceColor,
      keyChild: "小組介紹", 
      valueChild: AppTextFormField(
        focusNode: _spaceDescriptionFocusNode,
        primaryColor: vm.spaceColor,
        validator: vm.spaceDescriptionValidator,
        hintText: "請輸入小組介紹",
        initialValue: vm.newWorkspaceData.description,
        onChanged: (value) => vm.spaceDescription = value!,
        onSubmit: (value) => _tagFocusNode.requestFocus(),
    ),);
  }
  
  Widget _spaceThemeSelectFrame(CreateWorkspaceViewModel vm){
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
