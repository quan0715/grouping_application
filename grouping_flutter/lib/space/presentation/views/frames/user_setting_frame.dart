import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import 'package:grouping_project/core/shared/color_widget_interface.dart';
import 'package:grouping_project/app/presentation/components/data_display/title_with_content.dart';
import 'package:grouping_project/app/presentation/providers/token_manager.dart';
import 'package:grouping_project/space/presentation/view_models/setting_view_model.dart';
import 'package:grouping_project/space/presentation/view_models/user_page_view_model.dart';
import 'package:grouping_project/space/presentation/views/components/color_card_with_fillings.dart';
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => _buildBody();

  Widget _buildBody() {
    return Consumer<SettingPageViewModel>(
      builder: (context, viewModel, child) => Consumer<UserPageViewModel>(
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
    await Provider.of<UserPageViewModel>(context, listen: false).logout();
    if (context.mounted) {
      await Provider.of<TokenManager>(context, listen: false).updateToken();
    }
  }

  void onChangeTag() async {
    debugPrint("This is not yet implemented.");
  }

  void onChangeAccountName() async {
    debugPrint("This is not yet implemented.");
  }

  void onNightViewToggled(bool value) {
    debugPrint("isNightView: $value");
    Provider.of<SettingPageViewModel>(context, listen: false)
        .onNightViewToggled(value);
  }

  void onChangeThemeColor() async {
    debugPrint("This is not yet implemented.");
    debugPrint(
        "String interpretation of Color.value: ${widget.frameColor.value}");
    debugPrint(
        "Is the current user in SeTTingPageVM there? ${Provider.of<SettingPageViewModel>(context, listen: false).currentUser != null}");
  }

  Widget _getAccountBody() {
    UserPageViewModel userPageViewModel =
        Provider.of<UserPageViewModel>(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const TitleWithContent(
        title: "個人帳號設定",
        content: "設定個人帳號",
      ),
      const Divider(height: 10, thickness: 1),
      ColorFillingCardWidget(
        primaryColor: getThemePrimaryColor,
        title: "帳號名稱",
        content: userPageViewModel.currentUser?.nickname ?? "這裡應為帳號名稱",
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
              const TitleWithContent(
                  title: "個人資料設定", content: "修改頭像、暱稱以及個人標籤，一個人最多建立四個標籤"),
              const Divider(height: 10, thickness: 1)
            ] +
            _getExsistedTags(context));
  }

  List<Widget> _getExsistedTags(BuildContext context) {
    UserPageViewModel userPageViewModel =
        Provider.of<UserPageViewModel>(context);
    if (mounted && userPageViewModel.currentUser != null) {
      List<Widget> temp = [];
      for (int i = 0; i < userPageViewModel.currentUser!.tags.length; i++) {
        temp += [
          ColorFillingCardWidget(
            primaryColor: getThemePrimaryColor,
            title: userPageViewModel.currentUser!.tags[i].tag,
            content: userPageViewModel.currentUser!.tags[i].content,
            child: IconButton(
              icon: const Icon(Icons.create_outlined),
              onPressed: () => onChangeTag(),
            ),
          ),
          const Gap(10)
        ];
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
          const TitleWithContent(title: "個人儀錶板設定", content: "你可以自訂義儀表板設定"),
          const Divider(height: 10, thickness: 1),
          ColorFillingCardWidget(
            primaryColor: getThemePrimaryColor,
            title: "佈景主題",
            content: "夜覽模式",
            child: CupertinoSwitch(
                value: settingPageViewModel.isNightView,
                onChanged: (value) => onNightViewToggled(value)),
          ),
          const Gap(10),
          ColorFillingCardWidget(
            primaryColor: getThemePrimaryColor,
            title: "佈景顏色",
            content: "更改佈景主題顏色",
            child: UserActionButton.secondary(
                onPressed: () => onChangeThemeColor(),
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
