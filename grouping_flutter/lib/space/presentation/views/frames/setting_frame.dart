import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grouping_project/app/presentation/providers/token_manager.dart';

import 'package:grouping_project/core/shared/color_widget_interface.dart';
import 'package:grouping_project/space/presentation/view_models/user_page_view_model.dart';
import 'package:grouping_project/space/presentation/views/components/color_card_with_fillings.dart';
import 'package:grouping_project/space/presentation/views/components/setting_title_widget.dart';
import 'package:grouping_project/space/presentation/views/components/user_action_button.dart';
import 'package:provider/provider.dart';

/*
cd grouping_flutter
flutter run --web-port 5000

*/

class SettingFrame extends StatefulWidget implements WithThemeSettingColor {
  const SettingFrame({super.key, required this.viewModel});

  final UserPageViewModel viewModel;
  @override
  Color get getTitleColor =>
      Color.lerp(viewModel.selectedProfile.spaceColor, Colors.black, 0.15)!;
  @override
  Color get getTextBoxFillingColor =>
      Color.lerp(viewModel.selectedProfile.spaceColor, Colors.white, 0.9)!;
  @override
  Color get getBackGroundColor =>
      Color.lerp(viewModel.selectedProfile.spaceColor, Colors.white, 0.95)!;

  @override
  State<SettingFrame> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingFrame> {
  List<Widget> _getAccountSettingWidget(BuildContext context) {
    return <Widget>[
      const SettingTitle(title: "個人帳號設定", content: "設定個人帳號"),
      const Padding(
          padding: EdgeInsets.symmetric(vertical: 5), child: Divider()),
      ColorFillingCardWidget(
        fillingColor: widget.getTextBoxFillingColor,
        titleColor: widget.getTitleColor,
        title: "帳號名稱",
        content: widget.viewModel.currentUser?.name ?? "這裡應為帳號名稱",
        child: UserActionButton.primary(
          onPressed: () {
            debugPrint("This is not yet implemented.");
          },
          label: "更換帳號名稱",
          primaryColor: widget.viewModel.selectedProfile.spaceColor,
          icon: const Icon(Icons.restart_alt),
        ),
      ),
      const Gap(10),
      ColorFillingCardWidget(
        fillingColor: widget.getTextBoxFillingColor,
        titleColor: widget.getTitleColor,
        title: "綁定信箱",
        content: widget.viewModel.currentUser?.account ?? "這裡應為信箱",
      ),
      const Gap(10),
      ColorFillingCardWidget(
        fillingColor: widget.getTextBoxFillingColor,
        titleColor: widget.getTitleColor,
        title: "帳號密碼",
        content: "如遺失帳號密碼需更換密碼請點選密碼更換",
      ),
      const Gap(10),
      ColorFillingCardWidget(
        fillingColor: widget.getTextBoxFillingColor,
        titleColor: widget.getTitleColor,
        title: "帳號登出",
        content: "登出此帳號",
        child: UserActionButton.secondary(
          onPressed: () async {
            widget.viewModel.logOut().whenComplete(() {
              Provider.of<TokenManager>(context, listen: false).updateToken();
              GoRouter.of(context).go('/');
            });
          },
          label: "登出",
          primaryColor: Colors.red,
          icon: const Icon(Icons.logout),
        ),
      ),
      const Gap(10),
    ];
  }

  List<Widget> _getAccountTagWidget() {
    List<Widget> tmp = <Widget>[
      const SettingTitle(title: "個人資料設定", content: "修改頭像、暱稱以及個人標籤，一個人最多建立四個標籤"),
      const Padding(
          padding: EdgeInsets.symmetric(vertical: 5), child: Divider()),
    ];
    int length = widget.viewModel.currentUser?.tags.length ?? 0;
    for (int i = 0; i < length; i++) {
      tmp += [
        ColorFillingCardWidget(
          fillingColor: widget.getTextBoxFillingColor,
          titleColor: widget.getTitleColor,
          title: widget.viewModel.currentUser?.tags[i].tag ?? "",
          content: widget.viewModel.currentUser?.tags[i].content ?? "",
        ),
        const Gap(10)
      ];
    }

    return tmp;
  }

  void moveToSignInPage(BuildContext context) {
    debugPrint("Logout back to login page");
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    // WorkspaceViewModel viewModel = widget.viewModel;
    return SafeArea(
      child: Container(
        color: widget.getBackGroundColor,
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 30,
              horizontal: MediaQuery.of(context).size.width * 0.06),
          child: Column(
              children:
                  _getAccountSettingWidget(context) + _getAccountTagWidget()),
        ),
      ),
    );
  }
}
