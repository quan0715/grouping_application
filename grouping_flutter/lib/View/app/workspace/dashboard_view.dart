import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grouping_project/View/components/components.dart';
import 'package:grouping_project/ViewModel/workspace/workspace_view_model.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key, required this.viewModel});

  final WorkspaceViewModel viewModel;

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    WorkspaceViewModel viewModel = widget.viewModel;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Expanded(
            flex: 4,
            child: Center(
              child: Text('current workspace'),
            )),
        const Expanded(flex: 1, child: Divider()),
        Expanded(
            flex: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        '工作小組 (${viewModel.workspaceNumber})',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(viewModel.currentWorkspaceColor)),
                      ),
                    ),
                    Expanded(
                        flex: 3,
                        child: ElevatedButton.icon(
                            onPressed: () {
                              debugPrint("創建小組");
                            },
                            icon: const Icon(Icons.add),
                            label: Text(
                              '創建小組',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Color(viewModel.currentWorkspaceColor)),
                            ))),
                    Expanded(
                        flex: 3,
                        child: ElevatedButton.icon(
                            onPressed: () {
                              debugPrint("加入團隊");
                            },
                            icon: const Icon(Icons.group_add),
                            label: Text(
                              '加入團隊',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Color(viewModel.currentWorkspaceColor)),
                            ))),
                  ],
                ),
              ] + viewModel.workspaces,
            ))
      ]),
    );
    // return Stack(
    //         children: [
    //           Align(
    //             alignment: kIsWeb ? Alignment.topRight : Alignment.topCenter,
    //             child: MessagesList(messageService: viewModel.messageService),
    //           ),
    //           Center(
    //             child: TextButton(onPressed: ()async => {
    //               viewModel.onPress(),
    //               // await showMessage(viewModel.messageService)
    //               }, child: const Text("Switch workspace"))
    //           ),

    //         ],
    //       );
  }
}
