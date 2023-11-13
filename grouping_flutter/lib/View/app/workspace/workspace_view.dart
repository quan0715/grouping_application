import 'package:flutter/material.dart';
import 'package:grouping_project/View/app/workspace/activity_view.dart';
import 'package:grouping_project/View/app/workspace/dashboard_view.dart';
import 'package:grouping_project/View/app/workspace/message.view.dart';
import 'package:grouping_project/View/app/workspace/setting_view.dart';
import 'package:grouping_project/ViewModel/workspace/workspace_view_model.dart';
import 'package:grouping_project/model/auth/account_model.dart';
import 'package:grouping_project/model/workspace/event_model.dart';
import 'package:grouping_project/model/workspace/mission_model.dart';
import 'package:grouping_project/model/workspace/workspace_model.dart';
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
    WorkspaceModel current = WorkspaceModel(name: '張', themeColor: 0xFFFFC107);

    WorkspaceModel workspace =
        WorkspaceModel(name: 'test workspace', themeColor: 0xFF7D5800);
    EventModel event = EventModel(title: 'test event');
    MissionModel mission = MissionModel(title: 'test mission');
    AccountModel account = AccountModel(
        joinedWorkspaces: [workspace],
        contributingActivities: [event, mission]);
    // end of test

    return ChangeNotifierProvider<WorkspaceViewModel>(
      create: (context) => WorkspaceViewModel(current, account),
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
            bottomNavigationBar: NavigationBarTheme(
              data: NavigationBarThemeData(
                  labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
                      (Set<MaterialState> states) => TextStyle(
                          color: Color(viewModel.currentWorkspaceColor)))),
              child: NavigationBar(
                onDestinationSelected: viewModel.setPage,
                indicatorColor: Color(viewModel.currentWorkspaceColor),
                selectedIndex: viewModel.getPage(),
                destinations: [
                  NavigationDestination(
                      selectedIcon: const Icon(Icons.dashboard),
                      icon: Icon(
                        Icons.dashboard_outlined,
                        color: Color(viewModel.currentWorkspaceColor),
                      ),
                      label: '儀錶板'),
                  NavigationDestination(
                      selectedIcon: const Icon(Icons.calendar_today),
                      icon: Icon(
                        Icons.calendar_today_outlined,
                        color: Color(viewModel.currentWorkspaceColor),
                      ),
                      label: '活動'),
                  NavigationDestination(
                      selectedIcon: const Icon(Icons.message),
                      icon: Icon(
                        Icons.message_outlined,
                        color: Color(viewModel.currentWorkspaceColor),
                      ),
                      label: '訊息'),
                  NavigationDestination(
                      selectedIcon: const Icon(Icons.settings),
                      icon: Icon(
                        Icons.settings_outlined,
                        color: Color(viewModel.currentWorkspaceColor),
                      ),
                      label: '設定')
                ],
              ),
            ),
            // bottomNavigationBar: BottomNavigationBar(
            //     type: BottomNavigationBarType.fixed,
            //     currentIndex: viewModel.getPage(),
            //     onTap: viewModel.setPage,
            //     selectedItemColor: const Color(0xFF7D5800),
            //     selectedIconTheme:
            //         const IconThemeData(color: Color(0xFF7D5800), size: 25),
            //     unselectedItemColor: Colors.black,
            //     unselectedIconTheme:
            //         const IconThemeData(color: Colors.black, size: 20),
            //     items: const [
            //       BottomNavigationBarItem(
            //           icon: Icon(Icons.dashboard), label: '儀錶板'),
            //       BottomNavigationBarItem(
            //           icon: Icon(Icons.calendar_today), label: '活動'),
            //       BottomNavigationBarItem(
            //           icon: Icon(Icons.message), label: '訊息'),
            //       BottomNavigationBarItem(
            //           icon: Icon(Icons.settings), label: '設定')
            //     ]),
            // resizeToAvoidBottomInset: false,
          );
        },
      ),
    );
  }
}
