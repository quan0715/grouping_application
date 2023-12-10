import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:provider/provider.dart';

import 'package:grouping_project/core/shared/color_widget_interface.dart';
import 'package:grouping_project/app/presentation/components/data_display/title_with_content.dart';
import 'package:grouping_project/space/presentation/views/components/two_info_edit_card.dart';
import 'package:grouping_project/app/presentation/providers/token_manager.dart';
import 'package:grouping_project/space/presentation/view_models/setting_view_model.dart';
import 'package:grouping_project/space/presentation/view_models/user_page_view_model.dart';
import 'package:grouping_project/space/presentation/views/components/color_card_with_fillings.dart';
import 'package:grouping_project/space/presentation/views/components/layout/dashboard_frame_layout.dart';
import 'package:grouping_project/space/presentation/views/components/user_action_button.dart';

class UserSettingFrame extends StatefulWidget {
  const UserSettingFrame(
      {this.frameColor = Colors.white,
      this.frameHeight,
      this.frameWidth,
      super.key});

  final Color frameColor;
  final double? frameHeight;
  final double? frameWidth;

  @override
  State<UserSettingFrame> createState() => _SettingViewState();
}

class _SettingViewState extends State<UserSettingFrame>
    implements WithThemeSettingColor {
  @override
  Widget build(BuildContext context) => _buildBody();

  Widget _buildBody() {
    return Consumer<SettingPageViewModel>(
      builder: (context, viewModel, child) => Consumer<UserSpaceViewModel>(
        builder: (context, userPageViewModel, child) => SingleChildScrollView(
          child: Container(
            width: widget.frameWidth,
            height: widget.frameHeight,
            decoration: BoxDecoration(
                color: getBackGroundColor,
                borderRadius: const BorderRadius.all(Radius.circular(10.0))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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

  Future<void> onTagAddPressed() async {
    if (Provider.of<SettingPageViewModel>(context, listen: false)
            .currentUser!
            .tags
            .length <
        4) {
      await Provider.of<SettingPageViewModel>(context, listen: false)
          .onTagAddPressed();
    } else {
      debugPrint("You can't add more tags.");
    }
  }

  Future<void> onTagDelete(int i) async {
    await Provider.of<SettingPageViewModel>(context, listen: false)
        .onTagDelete(i);
  }

  void onEditPressed(int i) async {
    Provider.of<SettingPageViewModel>(context, listen: false).onEditPressed(i);
    debugPrint(Provider.of<SettingPageViewModel>(context, listen: false)
        .onTagChanging
        .toString());
  }

  void onEditingCancel() {
    Provider.of<SettingPageViewModel>(context, listen: false).onEditingCancel();
  }

  void onEditingDone() {
    Provider.of<SettingPageViewModel>(context, listen: false).onEditingDone();
  }

  void onNightViewToggled(bool value) {
    debugPrint("isNightView: $value");
    Provider.of<SettingPageViewModel>(context, listen: false)
        .onNightViewToggled(value);
  }

  void onChangeThemeColor(Color color) async {
    debugPrint("This is not yet implemented.");
    debugPrint(
        "String interpretation of Color.value: ${widget.frameColor.value}");
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
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
              TitleWithContent(
                title: "個人資料設定",
                content: "修改頭像、暱稱以及個人標籤，一個人最多建立四個標籤",
                child: UserActionButton.secondary(
                    onPressed: () => onTagAddPressed(),
                    icon: const Icon(Icons.add),
                    label: "創建新標籤",
                    primaryColor: getThemePrimaryColor),
              ),
              const Divider(height: 10, thickness: 1)
            ] +
            _getExsistedTags(context));
  }

  List<Widget> _getExsistedTags(BuildContext context) {
    UserSpaceViewModel userPageViewModel =
        Provider.of<UserSpaceViewModel>(context);
    SettingPageViewModel settingPageViewModel =
        Provider.of<SettingPageViewModel>(context);
    if (mounted && userPageViewModel.currentUser != null) {
      List<Widget> temp = [];
      for (int i = 0; i < userPageViewModel.currentUser!.tags.length; i++) {
        temp += [
          settingPageViewModel.onTagChanging &&
                  settingPageViewModel.indexOfChangingTag == i
              ? TwoInfoEditCardWidget(
                  primaryColor: getThemePrimaryColor,
                  firstEditTitle: "標籤名稱",
                  secondEditTitle: "標籤資訊",
                  firstEditingContent:
                      userPageViewModel.currentUser!.tags[i].title,
                  secondEditingContent:
                      userPageViewModel.currentUser!.tags[i].content,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      UserActionButton.secondary(
                          icon: const Icon(Icons.delete),
                          onPressed: () async => await onTagDelete(i),
                          label: "刪除",
                          primaryColor: getThemePrimaryColor),
                      const Gap(10),
                      UserActionButton.secondary(
                          icon: const Icon(Icons.close),
                          onPressed: () => onEditingCancel(),
                          label: "放棄修改",
                          primaryColor: getThemePrimaryColor),
                      const Gap(10),
                      UserActionButton.primary(
                          icon: const Icon(Icons.done),
                          onPressed: () async => onEditingDone(),
                          label: "儲存",
                          primaryColor: getThemePrimaryColor)
                    ],
                  ),
                )
              : ColorFillingCardWidget(
                  primaryColor: getThemePrimaryColor,
                  title: userPageViewModel.currentUser!.tags[i].title,
                  content: userPageViewModel.currentUser!.tags[i].content,
                  child: IconButton(
                    icon: const Icon(
                      Icons.create_outlined,
                    ),
                    color: getThemePrimaryColor,
                    onPressed: () => onEditPressed(i),
                  ),
                ),
          const Gap(10)
        ];
      }
      if (settingPageViewModel.indexOfChangingTag ==
          settingPageViewModel.currentUser!.tags.length) {
        temp += [
          TwoInfoEditCardWidget(
            primaryColor: getThemePrimaryColor,
            firstEditTitle: "標籤名稱",
            secondEditTitle: "標籤資訊",
            firstEditingContent: "",
            secondEditingContent: "",
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                UserActionButton.secondary(
                    icon: const Icon(Icons.close),
                    onPressed: () => onEditingCancel(),
                    label: "放棄",
                    primaryColor: getThemePrimaryColor),
                const Gap(10),
                UserActionButton.primary(
                    icon: const Icon(Icons.done),
                    onPressed: () async => onEditingDone(),
                    label: "儲存",
                    primaryColor: getThemePrimaryColor)
              ],
            ),
          ),
        ];
      }
      if (userPageViewModel.currentUser!.tags.length == 0) {
        temp += [const Gap(10)];
      }
      return temp;
    } else {
      return [const SizedBox()];
    }
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
