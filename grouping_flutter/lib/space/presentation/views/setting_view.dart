import 'package:flutter/material.dart';
import 'package:grouping_project/core/shared/color_widget_interface.dart';
import 'package:grouping_project/space/presentation/view_models/workspace_view_model.dart';
import 'package:grouping_project/space/presentation/views/components/color_card_with_fillings.dart';

/*
cd grouping_flutter
flutter run --web-port 5000
2

*/

class SettingView extends StatefulWidget {
  const SettingView({super.key, required this.viewModel});

  final WorkspaceViewModel viewModel;

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  @override
  Widget build(BuildContext context) {
    // WorkspaceViewModel viewModel = widget.viewModel;
    return const Placeholder();
  }
}
