import 'package:flutter/material.dart';
import 'package:grouping_project/ViewModel/workspace/workspace_view_model.dart';

class ActivityView extends StatefulWidget{
  const ActivityView({super.key, required this.viewModel});

  final WorkspaceViewModel viewModel;

  @override
  State<ActivityView> createState() => _ActivityViewState();
}

class _ActivityViewState extends State<ActivityView>{

  @override
  Widget build(BuildContext context){
    WorkspaceViewModel viewModel = widget.viewModel;
    return const Center(child: Text('building activity page...'),);
  }
}