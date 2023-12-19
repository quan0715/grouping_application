import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grouping_project/app/presentation/components/form/primary_text_form_field.dart';
import 'package:grouping_project/core/shared/color_widget_interface.dart';
import 'package:grouping_project/space/domain/entities/user_entity.dart';
import 'package:grouping_project/app/presentation/components/data_display/key_value_pair_widget.dart';
import 'package:grouping_project/app/presentation/components/buttons/user_action_button.dart';

class UserTagEditingForm extends StatelessWidget implements WithThemePrimaryColor {
  final Color primaryColor;
  final double borderRadius;
  final EdgeInsets? padding;
  final void Function(UserTagEntity)? onChange;
  final Function(UserTagEntity)?onDeleteAction;
  final Function(UserTagEntity)? onEditingCancel;
  final Function(UserTagEntity)? onEditingDone;

  final bool enableSave; // if new tag, disable editing
  final bool enableDelete; // if new tag, disable delete
  final bool enableCancel; // if new tag, disable cancel

  final double gap;
  final UserTagEntity userTagEntity;
  final Widget? child;


  UserTagEditingForm({
    super.key,
    required this.primaryColor,
    UserTagEntity? userTagEntity,
    this.onChange,
    this.enableSave = true,
    this.enableDelete = true,
    this.enableCancel = true,
    this.onDeleteAction,
    this.onEditingCancel,
    this.onEditingDone,
    this.child,
    this.borderRadius = 5,
    this.padding,
    this.gap = 10,
  }): userTagEntity = userTagEntity == null  
      ? UserTagEntity.emptyTag() : userTagEntity.copy();

  factory UserTagEditingForm.createNewUserTag({
    Color primaryColor = Colors.white,
    void Function(UserTagEntity)? onChange,
    void Function(UserTagEntity)? onCancel,
    void Function(UserTagEntity)? onEditingDone,
  }){
    return UserTagEditingForm(
      primaryColor: primaryColor,
      userTagEntity: UserTagEntity.emptyTag(),
      enableSave: true,
      enableDelete: false,
      enableCancel: true,
      onChange: onChange,
      onEditingCancel: onCancel,
      onEditingDone: onEditingDone,
    );
  }

  @override
  Color get getThemePrimaryColor => primaryColor;

  Color get backgroundColor => primaryColor.withOpacity(0.1);

  Widget get gapSpace => Gap(gap);


  @override
  Widget build(BuildContext context) => _buildBody(context);

  Widget _getActionBar(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Visibility(
          visible: enableDelete,
          child: UserActionButton.secondary(
              icon: const Icon(Icons.delete),
              onPressed: () => onDeleteAction?.call(userTagEntity),
              label: "刪除",
              primaryColor: getThemePrimaryColor),
        ),
        const Gap(10),
        Visibility(
          visible: enableCancel,
          child: UserActionButton.secondary(
              icon: const Icon(Icons.close),
              onPressed: () => onEditingCancel?.call(userTagEntity), 
              label: "放棄修改",
              primaryColor: getThemePrimaryColor),
        ),
        const Gap(10),
        Visibility(
          visible: enableSave,
          child: UserActionButton.primary(
              icon: const Icon(Icons.done),
              onPressed: () => onEditingDone?.call(userTagEntity),
              label: "儲存",
              primaryColor: getThemePrimaryColor),
        )
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return PrimaryInfoFrame(
      color: getThemePrimaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          KeyValuePairWidget<String, Widget>(
            primaryColor: getThemePrimaryColor,
            keyChild: "標籤名稱",
            valueChild: AppTextFormField(
              initialValue: userTagEntity.title,
              hintText: "請輸入標籤名稱",
              primaryColor: getThemePrimaryColor,
              onChanged: (value){
                userTagEntity.title = value ?? "";
                onChange?.call(userTagEntity);
              }, 
            ),
          ),
          gapSpace,
          KeyValuePairWidget<String, Widget>(
            keyChild: "標籤內容",
            primaryColor: getThemePrimaryColor,
            valueChild: AppTextFormField(
              initialValue: userTagEntity.content,
              hintText: "請輸入標籤內容",
              primaryColor: getThemePrimaryColor,
              onChanged: (value){
                userTagEntity.content = value ?? "";
                onChange?.call(userTagEntity);
              },
            ),
          ),
          child ?? const SizedBox.shrink(),
          gapSpace,
          _getActionBar(),
      ]),
    );
  }
}


