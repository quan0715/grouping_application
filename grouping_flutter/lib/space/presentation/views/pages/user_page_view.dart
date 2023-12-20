import 'package:flutter/material.dart';
import 'package:grouping_project/space/presentation/view_models/create_workspace_view_model.dart';
import 'package:grouping_project/space/presentation/view_models/join_workspace_view_model.dart';
import 'package:grouping_project/space/presentation/view_models/setting_view_model.dart';
import 'package:grouping_project/space/presentation/view_models/user_page_view_model.dart';
import 'package:grouping_project/space/presentation/views/components/layout/dashboard_frame_layout.dart';
import 'package:grouping_project/space/presentation/views/components/layout/dashboard_layout.dart';
import 'package:grouping_project/space/presentation/views/frames/navigate_rail_frame.dart';
import 'package:grouping_project/space/presentation/views/frames/activity_list_frame.dart';
import 'package:grouping_project/space/presentation/views/frames/user_space/user_setting_frame.dart';
import 'package:grouping_project/space/presentation/views/frames/user_space/user_space_info_frame.dart';
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
  
  late final SpaceViewModel userPageViewModel;
  late final SettingPageViewModel settingPageViewModel;
  late final CreateWorkspaceViewModel createWorkspaceViewModel;
  late final JoinWorkspaceViewModel joinWorkspaceViewModel;

  @override
  void initState() {
    super.initState();
    var userData = Provider.of<UserDataProvider>(context, listen: false);
    userPageViewModel = SpaceViewModel()
      ..userDataProvider = userData;
    
    settingPageViewModel = SettingPageViewModel()
      ..userDataProvider = userData;
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   userPageViewModel.dispose();
  //   settingPageViewModel.dispose();
  // }

  @override
  Widget build(BuildContext context){
    return MultiProvider(
      providers: [
        ChangeNotifierProxyProvider<UserDataProvider, SpaceViewModel>(
          create: (context) => userPageViewModel..init(),
          update: (context, userDataProvider, userSpaceViewModel) => userSpaceViewModel!..updateUser(userDataProvider),
        ),
        ChangeNotifierProxyProvider<UserDataProvider, SettingPageViewModel>(
          create: (context) => settingPageViewModel,
          update: (context, userDataProvider, userSpaceSettingViewModel) => userSpaceSettingViewModel!..update(userDataProvider),
        ),
        
      ],
      child: _buildBody(),
    );
  }

  Widget _tempFrame(String title, int flex){
    return Expanded(
      flex: flex,
      child: DashboardFrameLayout(
        frameColor: userPageViewModel.spaceColor,
        child: Center(
          child: Text(title),
        )
      ),
    );
  }

  List<Widget> _getFrames(){
    // var spaceInfoAndNavigatorFrame = SpaceInfoAndNavigatorFrame(
    //   frameColor: userPageViewModel.selectedProfile.spaceColor,
    //   frameWidth: MediaQuery.of(context).size.width * 0.25,
    // );
    // var userSettingFrame = UserSettingFrame(
    //   frameColor: userPageViewModel.selectedProfile.spaceColor,
    //   frameHeight: MediaQuery.of(context).size.height,
    // );
    // var threadFrame = const ChatThreadBody(
    //   threadTitle: "Test Thread",
    // );
    // Widget gap = const Gap(10);
    var color = userPageViewModel.spaceColor;
    return switch (widget.pageType) {
      DashboardPageType.home => [
        Expanded(
          flex: 1,
          child: SpaceInfoFrame(
            frameColor: color,
            // frameWidth: MediaQuery.of(context).size.width * 0.25,
          ),
        ),
        _tempFrame("home", 3),
      ],
      DashboardPageType.activities => [
        Expanded(
          flex: 1,
          child: DashboardFrameLayout(
          frameColor: color,
          child: ActivityListFrame(color: color,)
        )),
        _tempFrame("Activities Detail", 3),
      ],
      DashboardPageType.threads => [
        _tempFrame("thread list", 1),
        Expanded(
          flex: 3,
          child: DashboardFrameLayout(
            frameColor: userPageViewModel.spaceColor,
            child: const ChatThreadBody(
            threadTitle: "Test Thread",
          ))),
      ],
      DashboardPageType.settings => [
        Expanded(child: UserSettingFrame(
          frameColor: color,
          frameHeight: MediaQuery.of(context).size.height,
          frameWidth: MediaQuery.of(context).size.width,
        ))
      ],
      DashboardPageType.none => [
        _tempFrame("error", 1)
      ],
    };
  }

  Widget _buildBody() {
    return Consumer<SpaceViewModel>(
        builder: (context, userSpaceViewModel, child) => 
          userSpaceViewModel.isLoading
            ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
            : DashboardView(
              backgroundColor: Colors.white,
              //appBar: _getAppBar(),
              frames: [
                const NavigateRailFrame(),
                ..._getFrames(),
              ],
              // drawer: _getDrawer(context),
              direction: Axis.horizontal,
        ),
    );
  }

  // Widget _getDrawer(BuildContext context){
  //   var user = Provider.of<UserDataProvider>(context, listen: false);
  //   return DashboardDrawer(
  //     primaryColor: userPageViewModel.spaceColor,
  //     userProfiles: user.currentUser!,
  //     workspaceProfiles: user.currentUser!.joinedWorkspaces,
  //     selectedProfileId: user.currentUser!.id,
  //   );
  // }

  // SpaceAppBar _getAppBar() {
  //   var user = Provider.of<UserDataProvider>(context, listen: false);
  //   return SpaceAppBar(
  //     color: userPageViewModel.spaceColor,
  //     spaceName:  user.currentUser?.name ?? "",
  //     spaceProfilePicURL: user.currentUser?.photo != null ? userPageViewModel.currentUser!.photo!.imageUri : "",
  //   );
  // }

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

