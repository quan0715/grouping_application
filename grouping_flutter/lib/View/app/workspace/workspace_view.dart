import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grouping_project/View/app/workspace/activity_view.dart';
import 'package:grouping_project/View/app/workspace/dashboard_view.dart';
import 'package:grouping_project/View/app/workspace/message.view.dart';
import 'package:grouping_project/View/app/workspace/setting_view.dart';
import 'package:grouping_project/View/components/components.dart';
import 'package:grouping_project/ViewModel/workspace/workspace_view_model.dart';
import 'package:grouping_project/model/auth/account_model.dart';
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
    // this is test use workspace model
    WorkspaceModel workspace =
        WorkspaceModel(name: 'test workspace', themeColor: 0xFF7D5800);

    return ChangeNotifierProvider<WorkspaceViewModel>(
      create: (context) => WorkspaceViewModel(
          WorkspaceModel(), AccountModel(joinedWorkspaces: [workspace])),
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
                        Text('工作小組 (${viewModel.workspaceNumber})'),
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
            bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: viewModel.getPage(),
                onTap: viewModel.setPage,
                selectedItemColor: const Color(0xFF7D5800),
                selectedIconTheme:
                    const IconThemeData(color: Color(0xFF7D5800), size: 25),
                unselectedItemColor: Colors.black,
                unselectedIconTheme:
                    const IconThemeData(color: Colors.black, size: 20),
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.dashboard), label: '儀錶板'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.calendar_today), label: '活動'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.message), label: '訊息'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.settings), label: '設定')
                ]),
            // resizeToAvoidBottomInset: false,
          );
        },
      ),
    );
  }
}
