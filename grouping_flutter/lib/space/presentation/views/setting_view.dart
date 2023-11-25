import 'package:flutter/material.dart';
import 'package:grouping_project/space/presentation/view_models/workspace_view_model.dart';

class SettingView extends StatefulWidget{
  const SettingView({super.key, required this.viewModel});

  final WorkspaceViewModel viewModel;

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView>{

  @override
  Widget build(BuildContext context){
    // WorkspaceViewModel viewModel = widget.viewModel;
    return const Center(child: Text('building setting page...'),);
  }
}