import 'package:flutter/material.dart';
import 'package:grouping_project/ViewModel/workspace/workspace_view_model.dart';

class MessageView extends StatefulWidget{
  const MessageView({super.key, required this.viewModel});

  final WorkspaceViewModel viewModel;

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView>{

  @override
  Widget build(BuildContext context){
    // WorkspaceViewModel viewModel = widget.viewModel;
    return const Center(child: Text('building message page...'),);
  }
}