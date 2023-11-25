import 'package:flutter/material.dart';
import 'package:grouping_project/space/presentation/view_models/workspace_view_model.dart';

class ActivityView extends StatefulWidget {
  const ActivityView({super.key, required this.viewModel});

  final WorkspaceViewModel viewModel;

  @override
  State<ActivityView> createState() => _ActivityViewState();
}

class _ActivityViewState extends State<ActivityView> {
  @override
  Widget build(BuildContext context) {
    WorkspaceViewModel viewModel = widget.viewModel;
    // return const Center(child: Text('building activity page...'),);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              // height: 30,
              width: double.infinity,
              decoration: BoxDecoration(border: Border.all()),
              child: const Text('calendar'),
            ),
          ),
          Expanded(
              flex: 8,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(border: Border.all()),
                // child: Center(child: Text('event')),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '事件 (${viewModel.eventNumber})',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(viewModel.currentWorkspaceColor)),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.add,
                                color: Color(viewModel.currentWorkspaceColor),
                              ))
                        ],
                      ),
                      // TODO: get event and create chip
                    ]),
              )),
          Expanded(
              flex: 10,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(border: Border.all()),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '任務 (${viewModel.missionNumber})',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(viewModel.currentWorkspaceColor)),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.add,
                                color: Color(viewModel.currentWorkspaceColor),
                              ))
                        ],
                      ),
                      // TODO: get mission and create chip
                    ]),
              ))
        ],
      ),
    );
  }
}
