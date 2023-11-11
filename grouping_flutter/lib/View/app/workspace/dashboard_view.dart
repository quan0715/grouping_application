import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grouping_project/View/components/app_log_message_card.dart';
import 'package:grouping_project/ViewModel/workspace/workspace_view_model.dart';

class DashboardView extends StatefulWidget{

  const DashboardView({super.key, required this.viewModel});

  final WorkspaceViewModel viewModel;

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView>{


  @override
  Widget build(BuildContext context){
    WorkspaceViewModel viewModel = widget.viewModel;
    return Stack(
            children: [
              Align(
                alignment: kIsWeb ? Alignment.topRight : Alignment.topCenter,
                child: MessagesList(messageService: viewModel.messageService),
              ),
              Center(
                child: TextButton(onPressed: ()async => {
                  viewModel.onPress(),
                  // await showMessage(viewModel.messageService)
                  }, child: const Text("Switch workspace"))
              ),
              
            ],
          );
  }
}