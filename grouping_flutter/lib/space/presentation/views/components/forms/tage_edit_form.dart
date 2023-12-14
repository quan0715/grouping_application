import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grouping_project/core/shared/color_widget_interface.dart';
import 'package:grouping_project/space/presentation/views/components/user_action_button.dart';

class UserTagEditingFrame extends StatelessWidget implements WithThemePrimaryColor {
  final Color primaryColor;
  final double borderRadius;
  final EdgeInsets? padding;
  final String firstEditTitle;
  final String secondEditTitle;
  final String firstEditingContent;
  final String secondEditingContent;
  final Widget? child;
  final void Function(String?)? onTagKeyChange;
  final void Function(String?)? onTagValueChange;
  final VoidCallback? onDeleteAction;
  final VoidCallback? onEditingCancel;
  final VoidCallback? onEditingDone;

  final bool enableSave; // if new tag, disable editing
  final bool enableDelete; // if new tag, disable delete
  final bool enableCancel; // if new tag, disable cancel

  final double gap;
  

  const UserTagEditingFrame({
    super.key,
    required this.primaryColor,
    required this.firstEditTitle,
    required this.secondEditTitle,
    required this.firstEditingContent,
    required this.secondEditingContent,
    required this.onTagKeyChange,
    required this.onTagValueChange,
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
  });

  final _defaultPadding = const EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 10,
  );

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
              onPressed: onDeleteAction,
              label: "刪除",
              primaryColor: getThemePrimaryColor),
        ),
        const Gap(10),
        Visibility(
          visible: enableCancel,
          child: UserActionButton.secondary(
              icon: const Icon(Icons.close),
              onPressed: onEditingCancel, 
              label: "放棄修改",
              primaryColor: getThemePrimaryColor),
        ),
        const Gap(10),
        Visibility(
          visible: enableSave,
          child: UserActionButton.primary(
              icon: const Icon(Icons.done),
              onPressed: onEditingDone,
              label: "儲存",
              primaryColor: getThemePrimaryColor),
        )
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Padding(
        padding: padding ?? _defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            AppTextFormField(
              title: firstEditTitle,
              initialValue: firstEditingContent,
              hintText: "請輸入標籤名稱",
              primaryColor: getThemePrimaryColor,
              onChanged: onTagKeyChange, 
            ),
            gapSpace,
            AppTextFormField(
              title: secondEditTitle,
              initialValue: secondEditingContent,
              hintText: "請輸入標籤內容",
              primaryColor: getThemePrimaryColor,
              onChanged: onTagValueChange,
            ),
            child ?? const SizedBox.shrink(),
            gapSpace,
            _getActionBar(),
        ]),
      ),
    );
  }
}


class AppTextFormField extends StatelessWidget{
  final Color? primaryColor;
  final String title;
  final String? initialValue;
  final String hintText;
  final String Function(String?)? validator;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final bool obscureText;
  final bool enabled;
  final bool filled;
  final Color fillColor;
  final TextStyle? textStyle;
  final TextStyle? contentStyle;

  const AppTextFormField({
    Key? key,
    required this.title,
    this.initialValue,
    required this.hintText,
    this.primaryColor,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.obscureText = false,
    this.enabled = true,
    this.filled = true,
    this.fillColor = Colors.white,
    this.textStyle,
    this.contentStyle,

  }) : super(key: key);

  final gap = const Gap(5);
  final borderRadius = 5.0;

  Color getColor (BuildContext context) =>
    primaryColor ?? Theme.of(context).primaryColor;
  
  TextStyle getLabelStyle(BuildContext context){ 
    return textStyle ?? Theme.of(context).textTheme.labelLarge!.copyWith(
      color: getColor(context),
      fontWeight: FontWeight.bold
    );
  }

  TextStyle getContentStyle(BuildContext context){
    return contentStyle ?? Theme.of(context).textTheme.labelLarge!.copyWith(
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: getLabelStyle(context)),
        gap,
        Row(
          children: [
            Expanded(
              child: Center(
                child: TextFormField(
                  initialValue: initialValue,
                  style: getContentStyle(context),
                  onChanged: onChanged,
                  validator: validator,
                  onSaved: onSaved,
                  decoration: InputDecoration(
                    hintText: hintText,
                    filled: filled,
                    fillColor: fillColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}