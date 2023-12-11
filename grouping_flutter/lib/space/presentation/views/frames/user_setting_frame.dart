import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:provider/provider.dart';

import 'package:grouping_project/core/shared/color_widget_interface.dart';
import 'package:grouping_project/app/presentation/components/data_display/title_with_content.dart';
import 'package:grouping_project/space/presentation/views/components/forms/tage_edit_form.dart';
import 'package:grouping_project/app/presentation/providers/token_manager.dart';
import 'package:grouping_project/space/presentation/view_models/setting_view_model.dart';
import 'package:grouping_project/space/presentation/view_models/user_page_view_model.dart';
import 'package:grouping_project/space/presentation/views/components/color_card_with_fillings.dart';
import 'package:grouping_project/space/presentation/views/components/layout/dashboard_frame_layout.dart';
import 'package:grouping_project/space/presentation/views/components/user_action_button.dart';

class UserSettingFrame extends StatefulWidget {
  const UserSettingFrame({
    super.key,
    this.frameColor = Colors.white,
    this.frameHeight,
    this.frameWidth,
  });

  final Color frameColor;
  final double? frameHeight;
  final double? frameWidth;

  @override
  State<UserSettingFrame> createState() => _SettingViewState();
}

class _SettingViewState extends State<UserSettingFrame> implements WithThemeSettingColor {
  
  @override
  Widget build(BuildContext context) => _buildBody();

  Widget _buildBody() {
    return Consumer<SettingPageViewModel>(
      builder: (context, viewModel, child) => Consumer<UserSpaceViewModel>(
        builder: (context, userPageViewModel, child) => DashboardFrameLayout(
          frameColor: getThemePrimaryColor,
          frameHeight: widget.frameHeight,
          frameWidth: widget.frameWidth,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _getAccountBody(),
                  _getPersonalDataBody(),
                  _getPersonalDashboardBody(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onLogout() async {
    await Provider.of<UserSpaceViewModel>(context, listen: false).userDataProvider!.userLogout();
    if (context.mounted) {
      await Provider.of<TokenManager>(context, listen: false).updateToken();
    }
  }

  void onChangeAccountName() async {
    debugPrint("This is not yet implemented.");
  }

  Future<void> onTagAddedButtonPressed() async {
    var vm = Provider.of<SettingPageViewModel>(context, listen: false);
    vm.isValidToAddNewTag
      ? vm.onTagAddButtonPressed()
      : debugPrint("You can't add more tags.");
  }

  void onNightViewToggled(bool value) {
    debugPrint("isNightView: $value");
    Provider.of<SettingPageViewModel>(context, listen: false).onNightViewToggled(value);
  }

  void onChangeThemeColor(Color color) async {
    debugPrint("This is not yet implemented.");
    debugPrint("String interpretation of Color.value: ${widget.frameColor.value}");
  }

  Widget _getAccountBody() {
    UserSpaceViewModel userPageViewModel =
        Provider.of<UserSpaceViewModel>(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TitleWithContent(
        title: "個人帳號設定",
        content: "設定個人帳號",
      ),
      const Divider(height: 10, thickness: 1),
      ColorFillingCardWidget(
        primaryColor: getThemePrimaryColor,
        title: "帳號名稱",
        content: userPageViewModel.currentUser?.name ?? "這裡應為帳號名稱",
        child: UserActionButton.primary(
          onPressed: () => onChangeAccountName(),
          label: "更換帳號名稱",
          primaryColor: userPageViewModel.selectedProfile.spaceColor,
          icon: const Icon(Icons.restart_alt),
        ),
      ),
      const Gap(10),
      ColorFillingCardWidget(
        primaryColor: getThemePrimaryColor,
        title: "綁定信箱",
        content: userPageViewModel.currentUser?.account ?? "這裡應為信箱",
      ),
      const Gap(10),
      ColorFillingCardWidget(
        primaryColor: getThemePrimaryColor,
        title: "帳號密碼",
        content: "如遺失帳號密碼需更換密碼請點選密碼更換",
      ),
      const Gap(10),
      ColorFillingCardWidget(
        primaryColor: getThemePrimaryColor,
        title: "帳號登出",
        content: "登出此帳號",
        child: UserActionButton.secondary(
          onPressed: onLogout,
          label: "登出",
          primaryColor: Colors.red,
          icon: const Icon(Icons.logout),
        ),
      ),
      const Gap(10),
    ]);
  }

  Widget _getPersonalDataBody() {
    return Consumer<SettingPageViewModel>(
      builder: (context, viewModel, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TitleWithContent(
              title: "個人資料設定",
              content: "修改頭像、暱稱以及個人標籤，一個人最多建立四個標籤",
              child: UserActionButton.secondary(
                onPressed: () async => 
                  viewModel.isValidToAddNewTag
                    ? viewModel.onTagAddButtonPressed()
                    : null,
                icon: const Icon(Icons.add),
                label: "創建新標籤",
                primaryColor: getThemePrimaryColor
              ),
            ),
            const Divider(height: 10, thickness: 1),
            ..._getExistingTags(context, viewModel),
          ] 
        ),
    );
  }

  List<Widget> _getExistingTags(BuildContext context, SettingPageViewModel vm) {
    return [
      ...List.generate(
         vm.userTags.length, 
         (index) => Padding(
           padding: const EdgeInsets.symmetric(vertical: 5),
           child: vm.tagIsEdited(index)
              ? UserTagEditingFrame(
                  primaryColor: getThemePrimaryColor,
                  firstEditTitle: "標籤名稱",
                  secondEditTitle: "標籤資訊",
                  firstEditingContent: vm.firstEditedFiled,
                  secondEditingContent: vm.secondEditedFiled,
                  onDeleteAction: () async => await vm.onTagDelete(index),
                  onEditingCancel: vm.cancelTagEditing,
                  onEditingDone: () async => await vm.updateUserTag(),
                  onTagKeyChange: (value) => vm.setFirstEditedFiled = value!,
                  onTagValueChange: (value) => vm.setSecondEditedFiled = value!,
              )
              : ColorFillingCardWidget(
                  primaryColor: getThemePrimaryColor,
                  title: vm.getTagByIndex(index).title,
                  content: vm.getTagByIndex(index).content,
                  child: IconButton(
                    icon: const Icon(Icons.create_outlined),
                    color: getThemePrimaryColor,
                    onPressed: () => vm.onEditPressed(index),
                  ),
                ),
         ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Visibility(
          visible: vm.isAddingNewTag,
          child: UserTagEditingFrame(
              primaryColor: getThemePrimaryColor,
              firstEditTitle: "標籤名稱",
              secondEditTitle: "標籤資訊",
              firstEditingContent: "",
              secondEditingContent: "",
              enableDelete: false,
              onEditingCancel: () => vm.cancelTagAdding(),
              onEditingDone: () async => await vm.createNewTag(),
              onTagKeyChange: (value) => vm.setFirstEditedFiled = value!,
              onTagValueChange: (value) => vm.setSecondEditedFiled = value!,
            ),
        ),
      ),
    ];
  }  
  

  Widget _getPersonalDashboardBody() {
    SettingPageViewModel settingPageViewModel =
        Provider.of<SettingPageViewModel>(context);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TitleWithContent(
            title: "個人儀錶板設定",
            content: "你可以自訂義儀表板設定",
          ),
          const Divider(height: 10, thickness: 1),
          ColorFillingCardWidget(
            primaryColor: getThemePrimaryColor,
            title: "佈景主題",
            content: "夜覽模式",
            child: CupertinoSwitch(
                activeColor: getThemePrimaryColor,
                value: settingPageViewModel.isNightView,
                onChanged: (value) => onNightViewToggled(value)),
          ),
          const Gap(10),
          ColorFillingCardWidget(
            primaryColor: getThemePrimaryColor,
            title: "佈景顏色",
            content: "更改佈景主題顏色",
            child: UserActionButton.secondary(
                //TODO:place true color selection
                onPressed: () => onChangeThemeColor(Colors.amber),
                icon: const Icon(Icons.square_rounded),
                label: "顏色",
                primaryColor: getThemePrimaryColor),
          )
        ]);
  }

  Color get getThemePrimaryColor => widget.frameColor;

  @override
  Color get getBackGroundColor => getThemePrimaryColor.withOpacity(0.05);

  @override
  Color get getTextBoxFillingColor => getThemePrimaryColor.withOpacity(0.1);

  @override
  Color get getTitleColor => getThemePrimaryColor;
}
