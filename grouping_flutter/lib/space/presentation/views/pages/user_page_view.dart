import 'package:flutter/material.dart';
import 'package:grouping_project/space/presentation/view_models/activity_list_view_model.dart';
import 'package:grouping_project/space/presentation/view_models/setting_view_model.dart';
import 'package:grouping_project/space/presentation/view_models/space_view_model.dart';
import 'package:grouping_project/space/presentation/provider/user_data_provider.dart';
import 'package:grouping_project/space/presentation/views/components/layout/dashboard_frame_layout.dart';
import 'package:grouping_project/space/presentation/views/components/layout/dashboard_layout.dart';
import 'package:grouping_project/space/presentation/views/frames/frames.dart';
import 'package:grouping_project/threads/presentations/widgets/chat_thread_body.dart';
import 'package:provider/provider.dart';

enum DashboardPageType {
  home,
  activities,
  threads,
  settings,
  none,
}

class UserPageView extends StatelessWidget {
  const UserPageView({super.key, required this.pageType});
  final DashboardPageType pageType;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProxyProvider<UserDataProvider, SpaceViewModel>(
          create: (context) => SpaceViewModel()
            ..updateUser(Provider.of<UserDataProvider>(context, listen: false))
            ..init(),
          update: (context, userDataProvider, userSpaceViewModel) =>
              userSpaceViewModel!..updateUser(userDataProvider),
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
      builder: (context, userSpaceViewModel, child) =>
          userSpaceViewModel.isLoading
              ? _getLoadingWidget()
              : switch (pageType) {
                  DashboardPageType.home => const UserHomepageView(),
                  DashboardPageType.activities => const UserActivityPageView(),
                  DashboardPageType.threads => const UserThreadsPageView(),
                  DashboardPageType.settings => const UserSettingPageView(),
                  DashboardPageType.none => const UserHomepageView(),
                },
    );
  }
}

class UserActivityPageView extends StatelessWidget {
  const UserActivityPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProxyProvider<UserDataProvider, ActivityListViewModel>(
          create: (context) => ActivityListViewModel(
              userDataProvider:
                  Provider.of<UserDataProvider>(context, listen: false))
            ..init(),
          update: (context, userDataProvider, activityListViewModel) =>
              activityListViewModel!..updateUser(userDataProvider),
        ),
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

class UserSettingPageView extends StatelessWidget {
  const UserSettingPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<UserDataProvider, SettingPageViewModel>(
      create: (context) => SettingPageViewModel()
        ..update(Provider.of<UserDataProvider>(context, listen: false)),
      update: (context, userDataProvider, userSpaceSettingViewModel) =>
          userSpaceSettingViewModel!..update(userDataProvider),
      builder: (context, child) => _buildBody(context),
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
          flex: 3,
          child: UserSettingFrame(
            frameColor: color,
          ),
        )
      ],
      // drawer: _getDrawer(context),
      direction: Axis.horizontal,
    );
  }
}

class UserHomepageView extends StatelessWidget {
  const UserHomepageView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<UserDataProvider, SettingPageViewModel>(
      create: (context) => SettingPageViewModel()
        ..update(Provider.of<UserDataProvider>(context, listen: false)),
      update: (context, userDataProvider, userSpaceSettingViewModel) =>
          userSpaceSettingViewModel!..update(userDataProvider),
      builder: (context, child) => _buildBody(context),
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
          child: SpaceInfoFrame(
            frameColor: color,
          ),
        ),
        Expanded(
          flex: 3,
          child: DashboardFrameLayout(
              frameColor: color,
              child: const Center(
                child: Text("home"),
              )),
        )
      ],
      // drawer: _getDrawer(context),
      direction: Axis.horizontal,
    );
  }
}

class UserThreadsPageView extends StatelessWidget {
  const UserThreadsPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
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
          child: DashboardFrameLayout(
              frameColor: color,
              child: const Center(
                child: Text("threads list"),
              )),
        ),
        Expanded(
            flex: 3,
            child: DashboardFrameLayout(
                frameColor: Provider.of<SpaceViewModel>(context, listen: false)
                    .spaceColor,
                child: const ChatThreadBody(
                  threadTitle: "Test Thread",
                )))
      ],
      // drawer: _getDrawer(context),
      direction: Axis.horizontal,
    );
  }
}
