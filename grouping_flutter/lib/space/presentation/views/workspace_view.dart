import 'package:flutter/material.dart';
import 'package:grouping_project/space/data/models/event_model.dart';
import 'package:grouping_project/space/data/models/mission_model.dart';
import 'package:grouping_project/space/data/models/workspace_model.dart';
import 'package:grouping_project/space/presentation/view_models/workspace_view_model.dart';
import 'package:grouping_project/space/presentation/views/activity_view.dart';
import 'package:grouping_project/space/presentation/views/components/mobile_bottom_navigation_bar.dart';
import 'package:grouping_project/space/presentation/views/dashboard_view.dart';
import 'package:grouping_project/space/presentation/views/message.view.dart';
import 'package:grouping_project/space/presentation/views/setting_view.dart';
// import 'package:grouping_project/View/shared/components/components.dart';
import 'package:grouping_project/space/data/models/account_model.dart';
import 'package:provider/provider.dart';

class WorkspaceView extends StatefulWidget {
  const WorkspaceView({Key? key}) : super(key: key);

  @override
  State<WorkspaceView> createState() => _WorkspaceViewState();
}

class _WorkspaceViewState extends State<WorkspaceView> {
  @override
  Widget build(BuildContext context) {
    // this is test-use data
    WorkspaceModel current = WorkspaceModel(name: '張', themeColor: 0xFF7D5800);

    WorkspaceModel workspace = WorkspaceModel(name: 'test workspace', themeColor: 0xFF7D5800);
    EventModel event = EventModel(title: 'test event');
    MissionModel mission = MissionModel(title: 'test mission');
    AccountModel account = AccountModel(
        joinedWorkspaces: [workspace],
        contributingActivities: [event, mission]);
    // end of test

    return ChangeNotifierProvider<WorkspaceViewModel>(
      create: (context) => WorkspaceViewModel(workspace: current, user: account),
      child: Consumer<WorkspaceViewModel>(
        builder: (context, viewModel, child) {
          List<Widget> pages = [
            DashboardView(viewModel: viewModel),
            ActivityView(viewModel: viewModel),
            MessageView(viewModel: viewModel),
            SettingView(viewModel: viewModel),
          ];
          return Scaffold(
            drawer: Drawer(
              child: Padding(
                padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                        const Text(
                          'User',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        viewModel.ownWorkspace,
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          '工作小組 (${viewModel.workspaceNumber})',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ] +
                      viewModel.workspaces,
                ),
              ),
            ),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text('張百寬的工作區'),
              centerTitle: false,
              titleSpacing: 5,
              titleTextStyle: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              leadingWidth: 50,
              leading: const Padding(
                padding: EdgeInsets.all(6.0),
                child: CircleAvatar(
                  radius: 16,
                  child: Text("張"),
                ),
              ),
              actions: [
                Builder(builder: (context) {
                  return IconButton(
                    onPressed: () => Scaffold.maybeOf(context)!.openDrawer(),
                    icon: const Icon(Icons.menu),
                  );
                }),
              ],
            ),
            body: pages[viewModel.getPage()],
            bottomNavigationBar: MobileBottomNavigationBar(
              currentIndex: viewModel.getPage(),
              themePrimaryColor: Colors.amber,
              onTap: (index) => viewModel.setPage(index),
            )
          );
        },
      ),
    );
  }
}
