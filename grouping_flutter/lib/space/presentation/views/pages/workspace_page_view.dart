import 'package:flutter/material.dart';
import 'package:grouping_project/space/presentation/provider/group_data_provider.dart';
import 'package:grouping_project/space/presentation/view_models/activity_list_view_model.dart';
import 'package:grouping_project/space/presentation/view_models/space_view_model.dart';
import 'package:grouping_project/space/presentation/provider/user_data_provider.dart';
import 'package:grouping_project/space/presentation/views/components/layout/dashboard_frame_layout.dart';
import 'package:grouping_project/space/presentation/views/components/layout/dashboard_layout.dart';
import 'package:grouping_project/space/presentation/views/frames/activity_frame.dart';
import 'package:grouping_project/space/presentation/views/frames/activity_list_frame.dart';
import 'package:grouping_project/space/presentation/views/frames/navigate_rail_frame.dart';
import 'package:grouping_project/space/presentation/views/frames/workspace/workspace_info_frame.dart';
import 'package:grouping_project/space/presentation/views/pages/user_page_view.dart';
import 'package:grouping_project/threads/presentations/widgets/chat_thread_body.dart';
import 'package:provider/provider.dart';

class WorkspacePageView extends StatefulWidget {
  const WorkspacePageView({super.key, required this.pageType});
  final DashboardPageType pageType;

  @override
  State<WorkspacePageView> createState() => _WorkspacePageViewState();
}

class _WorkspacePageViewState extends State<WorkspacePageView> {
  late final SpaceViewModel spaceViewModel;

  @override
  void initState() {
    super.initState();
    var userData = Provider.of<UserDataProvider>(context, listen: false);
    var groupData = Provider.of<GroupDataProvider>(context, listen: false);
    spaceViewModel = SpaceViewModel()
      ..updateGroup(groupData)
      ..updateUser(userData)
      ..init();
    // viewModel.init();
  }

  @override
  void dispose() {
    // spaceViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProxyProvider2<UserDataProvider, GroupDataProvider,
            SpaceViewModel>(
          create: (context) => spaceViewModel,
          update:
              (context, userDataProvider, groupDataProvider, spaceViewModel) =>
                  spaceViewModel!
                    ..updateUser(userDataProvider)
                    ..updateGroup(groupDataProvider),
        ),
      ],
      child: _buildBody(),
    );
  }

  Widget _getLoadingWidget() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<SpaceViewModel>(
      builder: (context, spaceViewModel, child) => spaceViewModel.isLoading
          ? _getLoadingWidget()
          : switch (widget.pageType) {
              DashboardPageType.home => const WorkspaceHomePageView(),
              DashboardPageType.activities => const WorkspaceActivityPageView(),
              DashboardPageType.threads => const WorkspaceThreadPageView(),
              DashboardPageType.settings => const WorkspaceSettingdPageView(),
              DashboardPageType.none => const UserHomepageView(),
            },
    );
  }
}

class WorkspaceHomePageView extends StatelessWidget {
  const WorkspaceHomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _tempFrame(String title, int flex, BuildContext context) {
    return Expanded(
      flex: flex,
      child: DashboardFrameLayout(
          frameColor: Provider.of<SpaceViewModel>(context).spaceColor,
          child: Center(
            child: Text(title),
          )),
    );
  }

  Widget _buildBody(BuildContext context) {
    var color = Provider.of<SpaceViewModel>(context, listen: false).spaceColor;
    return DashboardView(
      backgroundColor: Colors.white,
      frames: [
        const NavigateRailFrame(),
        Expanded(
            flex: 1,
            child: WorkspaceInfoFrame(
              frameColor: color,
            )),
        _tempFrame("home", 3, context),
      ],
      direction: Axis.horizontal,
    );
  }
}

class WorkspaceThreadPageView extends StatelessWidget {
  const WorkspaceThreadPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _tempFrame(String title, int flex, BuildContext context) {
    return Expanded(
      flex: flex,
      child: DashboardFrameLayout(
          frameColor: Provider.of<SpaceViewModel>(context).spaceColor,
          child: Center(
            child: Text(title),
          )),
    );
  }

  Widget _buildBody(BuildContext context) {
    var color = Provider.of<SpaceViewModel>(context, listen: false).spaceColor;
    return DashboardView(
      backgroundColor: Colors.white,
      frames: [
        const NavigateRailFrame(),
        _tempFrame("thread list", 1, context),
        Expanded(
            flex: 3,
            child: DashboardFrameLayout(
                frameColor: color,
                child: const ChatThreadBody(
                  threadTitle: "Test Thread",
                ))),
      ],
      direction: Axis.horizontal,
    );
  }
}

class WorkspaceActivityPageView extends StatelessWidget {
  const WorkspaceActivityPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProxyProvider2<UserDataProvider, GroupDataProvider,
                ActivityListViewModel>(
            create: (context) => ActivityListViewModel(
                userDataProvider:
                    Provider.of<UserDataProvider>(context, listen: false),
                workspaceDataProvider:
                    Provider.of<GroupDataProvider>(context, listen: false))
              ..init(),
            update: (context, userDataProvider, groupDataProvider,
                    activityListViewModel) =>
                activityListViewModel!
                  ..updateUser(userDataProvider)
                  ..updateWorkspace(groupDataProvider)),
        ChangeNotifierProxyProvider<ActivityListViewModel,
            ActivityDisplayViewModel>(
          create: (context) => ActivityDisplayViewModel(
              activityListViewModel:
                  Provider.of<ActivityListViewModel>(context, listen: false))
            ..init(),
          update: (context, activityListViewModel, activityDisplayViewModel) =>
              activityDisplayViewModel!..update(activityListViewModel),
        ),
      ],
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    var color = Provider.of<SpaceViewModel>(context, listen: false).spaceColor;
    return DashboardView(
      backgroundColor: Colors.white,
      //appBar: _getAppBar(),
      frames: [
        const NavigateRailFrame(),
        Expanded(
            flex: 1,
            child: CalendarFrame(
              color: color,
            )),
        Expanded(
            flex: 1,
            child: ActivityListFrame(
              color: color,
            )),
        Expanded(
            flex: 2,
            child: ActivityDetailFrame(
              color: color,
            ))
      ],
      // drawer: _getDrawer(context),
      direction: Axis.horizontal,
    );
  }
}

class WorkspaceSettingdPageView extends StatelessWidget {
  const WorkspaceSettingdPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _tempFrame(String title, int flex, BuildContext context) {
    return Expanded(
      flex: flex,
      child: DashboardFrameLayout(
          frameColor: Provider.of<SpaceViewModel>(context).spaceColor,
          child: Center(
            child: Text(title),
          )),
    );
  }

  Widget _buildBody(BuildContext context) {
    return DashboardView(
      backgroundColor: Colors.white,
      frames: [const NavigateRailFrame(), _tempFrame("setting", 1, context)],
      direction: Axis.horizontal,
    );
  }
}
