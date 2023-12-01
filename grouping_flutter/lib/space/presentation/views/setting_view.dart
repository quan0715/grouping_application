import 'package:flutter/material.dart';
import 'package:grouping_project/core/shared/color_widget_interface.dart';
import 'package:grouping_project/space/presentation/view_models/workspace_view_model.dart';
import 'package:grouping_project/space/presentation/views/components/color_card_with_fillings.dart';

/*
cd grouping_flutter
flutter run --web-port 5000
2

*/

class SettingView extends StatefulWidget implements WithThemeSettingColor {
  const SettingView({super.key, required this.viewModel});

  final WorkspaceViewModel viewModel;
  @override
  Color get getTitleColor =>
      Color.lerp(Color(viewModel.currentWorkspaceColor), Colors.black, 0.15)!;
  @override
  Color get getTextBoxFillingColor =>
      Color.lerp(Color(viewModel.currentWorkspaceColor), Colors.white, 0.9)!;
  @override
  Color get getBackGroundColor =>
      Color.lerp(Color(viewModel.currentWorkspaceColor), Colors.white, 0.95)!;

  List<ColorFillingCardWidget> get accountSetting {
    List<ColorFillingCardWidget> tmp = [
      ColorFillingCardWidget(
        // TODO: change this into workspace color
        fillingColor: getTextBoxFillingColor,
        titleColor: getTitleColor,
        title: "帳號登出",
        content: "登出此帳號",
        child: TextButton(
          onPressed: () {},
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.resolveWith((states) => Colors.white),
          ),
          child: Text("登出-製作中",
              style: TextStyle(
                  color: Colors.red.shade400,
                  fontSize: 13,
                  fontWeight: FontWeight.bold)),
        ),
      )
    ];

    return tmp;
  }

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  @override
  Widget build(BuildContext context) {
    // WorkspaceViewModel viewModel = widget.viewModel;
    return SafeArea(
        child: Container(
            color: widget.getBackGroundColor,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: MediaQuery.of(context).size.width * 0.06),
              child: Column(children: widget.accountSetting),
            )));
  }
}
