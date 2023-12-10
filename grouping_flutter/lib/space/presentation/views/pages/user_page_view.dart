import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grouping_project/space/presentation/views/components/app/dashboard_app_bar.dart';
import 'package:grouping_project/space/presentation/view_models/user_page_view_model.dart';
import 'package:grouping_project/space/presentation/views/components/app/dashboard_drawer.dart';
import 'package:grouping_project/space/presentation/views/components/layout/dashboard_frame_layout.dart';
import 'package:grouping_project/space/presentation/views/frames/user_setting_frame.dart';
import 'package:grouping_project/space/presentation/views/frames/user_space_info_and_navigator_frame.dart';
import 'package:grouping_project/space/presentation/views/components/layout/dashboard_layout.dart';
import 'package:grouping_project/threads/presentations/widgets/chat_thread_body.dart';
import 'package:provider/provider.dart';

enum DashboardPageType { 
  home,
  activities,
  threads,
  settings,
  none,
 }

class UserPageView extends StatefulWidget  {
  const UserPageView({super.key, required this.pageType});
  final DashboardPageType pageType;

  @override
  State<UserPageView> createState() => _UserPageViewState();
}

class _UserPageViewState extends State<UserPageView> {
  
  late final UserSpaceViewModel userPageViewModel;

  @override
  void initState() {
    super.initState();
    userPageViewModel = UserSpaceViewModel();
  }

  @override
  Widget build(BuildContext context){
    return ChangeNotifierProxyProvider<UserDataProvider, UserSpaceViewModel>(
      create: (context) => userPageViewModel
        ..userDataProvider = Provider.of<UserDataProvider>(context, listen: false)
        ..init(),
      update: (context, userDataProvider, userPageViewModel) => userPageViewModel!..update(userDataProvider),
      child: _buildBody(),
    );
  }

  List<Widget> _getFrames(){
    var spaceInfoAndNavigatorFrame = SpaceInfoAndNavigatorFrame(
      frameColor: userPageViewModel.selectedProfile.spaceColor,
      frameWidth: MediaQuery.of(context).size.width * 0.18,
    );
    var userSettingFrame = UserSettingFrame(
      frameColor: userPageViewModel.selectedProfile.spaceColor
    );
    var threadFrame = const ChatThreadBody(
      threadTitle: "Test Thread",
    );
    Widget gap = const Gap(10);
    return switch (widget.pageType) {
      DashboardPageType.home => [
        spaceInfoAndNavigatorFrame,
        gap,
        Expanded(child: DashboardFrameLayout(
          frameColor: userPageViewModel.selectedProfile.spaceColor,
          child: const Center(
            child: Text("Home"),
          )
        ))
      ],
      DashboardPageType.activities => [
        spaceInfoAndNavigatorFrame,
        gap,
        Expanded(
          flex: 2,
          child: DashboardFrameLayout(
          frameColor: userPageViewModel.selectedProfile.spaceColor,
          child: const Center(
            child: Text("Calendar"),
          )
        )),
        gap,
        Expanded(
          flex: 3,
          child: DashboardFrameLayout(
          frameColor: userPageViewModel.selectedProfile.spaceColor,
          child: const Center(
            child: Text("Activities Detail"),
          )
        )),
      ],
      DashboardPageType.threads => [
        spaceInfoAndNavigatorFrame,
        gap,
        Expanded(
          flex: 1,
          child: DashboardFrameLayout(
          frameColor: userPageViewModel.selectedProfile.spaceColor,
          child: const Center(
            child: Text("thread list"),
          )
        )),
        gap,
        Expanded(
          flex: 3,
          child: DashboardFrameLayout(
            frameColor: userPageViewModel.selectedProfile.spaceColor,
            child: threadFrame)),
      ],
      DashboardPageType.settings => [
        spaceInfoAndNavigatorFrame,
        gap,
        Expanded(child: userSettingFrame)
      ],
      DashboardPageType.none => [
        spaceInfoAndNavigatorFrame,
        gap,
        const Expanded(child: Placeholder())
      ],
    };
  }

  Widget _buildBody() {
    return Consumer<UserSpaceViewModel>(
      builder: (context, userSpaceViewModel, child) => 
        userSpaceViewModel.isLoading 
          ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
          : DashboardView(
            backgroundColor: Colors.white,
            appBar: _getAppBar(),
            frames: _getFrames(),
            drawer: _getDrawer()
      ),
    );
  }

  Widget _getDrawer(){
    var user = Provider.of<UserDataProvider>(context, listen: false);
    return DashboardDrawer(
      selectedProfile: user.getUserProfile(),
      userProfiles: user.getUserProfile(),
      workspaceProfiles: user.getWorkspaceList(),
    );
  }

  DashboardAppBar _getAppBar() {
    return DashboardAppBar(
      // color: viewModel.selectedProfile.spaceColor,
      profile: userPageViewModel.selectedProfile,
    );
  }

  // Widget? _getNavigationBar(BuildContext context, UserPageViewModel viewModel) {
  //   if (kIsWeb) {
  //     return null;
  //   } else {
  //     debugPrint("is not web, return bottom navigation bar");
  //     return MobileBottomNavigationBar(
  //       currentIndex: viewModel.currentPageIndex,
  //       themePrimaryColor: viewModel.selectedProfile.spaceColor,
  //       onTap: (index) => viewModel.updateCurrentIndex(index),
  //     );
  //   }
  // }
}
