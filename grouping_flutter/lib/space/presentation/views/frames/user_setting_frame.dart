import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grouping_project/app/presentation/components/data_display/title_with_content.dart';
import 'package:grouping_project/app/presentation/providers/token_manager.dart';

import 'package:grouping_project/core/shared/color_widget_interface.dart';
import 'package:grouping_project/space/presentation/view_models/user_page_view_model.dart';
import 'package:grouping_project/space/presentation/views/components/color_card_with_fillings.dart';
import 'package:grouping_project/space/presentation/views/components/user_action_button.dart';
import 'package:provider/provider.dart';

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
  void onLogout() async {
    await Provider.of<UserPageViewModel>(context, listen: false).logout();
    if (context.mounted) {
      await Provider.of<TokenManager>(context, listen: false).updateToken();
    }
  }

  Widget _getAccountSettingBody() {
    return Consumer<UserPageViewModel>(
        builder: (context, viewModel, child) =>
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const TitleWithContent(
                title: "個人帳號設定",
                content: "設定個人帳號",
              ),
              const Divider(height: 10, thickness: 1),
              ColorFillingCardWidget(
                primaryColor: getThemePrimaryColor,
                title: "帳號名稱",
                content: viewModel.currentUser?.nickname ?? "這裡應為帳號名稱",
                child: UserActionButton.primary(
                  onPressed: () {
                    debugPrint("This is not yet implemented.");
                  },
                  label: "更換帳號名稱",
                  primaryColor: viewModel.selectedProfile.spaceColor,
                  icon: const Icon(Icons.restart_alt),
                ),
              ),
              const Gap(10),
              ColorFillingCardWidget(
                primaryColor: getThemePrimaryColor,
                title: "綁定信箱",
                content: viewModel.currentUser?.account ?? "這裡應為信箱",
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
            ]));
  }

  Widget _getAccountTagWidget() {
    return Consumer<UserPageViewModel>(
        builder: (context, viewModel, child) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                  const TitleWithContent(
                      title: "個人資料設定", content: "修改頭像、暱稱以及個人標籤，一個人最多建立四個標籤"),
                  const Divider(height: 10, thickness: 1)
                ] +
                _getExsistedTags(context)));
  }

  List<Widget> _getExsistedTags(BuildContext context) {
    UserPageViewModel viewModel = Provider.of<UserPageViewModel>(context);
    if (mounted && viewModel.currentUser != null) {
      List<Widget> temp = [];
      for (int i = 0; i < viewModel.currentUser!.tags.length; i++) {
        temp += [
          ColorFillingCardWidget(
            primaryColor: getThemePrimaryColor,
            title: viewModel.currentUser!.tags[i].tag,
            content: viewModel.currentUser!.tags[i].content,
            child: IconButton(
              icon: const Icon(Icons.create_outlined),
              onPressed: () {
                return debugPrint("Not implemented yet...");
              },
            ),
          ),
          const Gap(10)
        ];
      }
      return temp;
      // return ListView.builder(itemBuilder: (context, index) {
      //   return Column(children: [
      //     ColorFillingCardWidget(
      //       primaryColor: getThemePrimaryColor,
      //       title: viewModel.currentUser!.tags[index].tag,
      //       content: viewModel.currentUser!.tags[index].content,
      //     ),
      //     const Gap(10)
      //   ]);
      // });
    } else {
      return [SizedBox()];
    }
  }

  @override
  Widget build(BuildContext context) => _buildBody();

  Widget _buildBody() {
    return Container(
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
            _getAccountSettingBody(),
            _getAccountTagWidget(),
          ],
        ),
      ),
    );
  }

  Color get getThemePrimaryColor => widget.frameColor;

  @override
  Color get getBackGroundColor => getThemePrimaryColor.withOpacity(0.05);

  @override
  Color get getTextBoxFillingColor => getThemePrimaryColor.withOpacity(0.1);

  @override
  Color get getTitleColor => getThemePrimaryColor;
}
