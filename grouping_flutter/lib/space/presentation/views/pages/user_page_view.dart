import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grouping_project/core/theme/color.dart';
import 'package:grouping_project/space/domain/entities/user_entity.dart';
import 'package:grouping_project/space/presentation/view_models/create_workspace_view_model.dart';
import 'package:grouping_project/space/presentation/views/components/app/dashboard_app_bar.dart';
import 'package:grouping_project/space/presentation/view_models/setting_view_model.dart';
import 'package:grouping_project/space/presentation/view_models/user_page_view_model.dart';
import 'package:grouping_project/space/presentation/views/components/app/dashboard_drawer.dart';
import 'package:grouping_project/space/presentation/views/components/layout/dashboard_frame_layout.dart';
import 'package:grouping_project/space/presentation/views/components/layout/dashboard_layout.dart';
import 'package:grouping_project/space/presentation/views/components/profile_avatar.dart';
import 'package:grouping_project/space/presentation/views/frames/create_workspace_dialog.dart';
import 'package:grouping_project/space/presentation/views/frames/user_setting_frame.dart';
import 'package:grouping_project/space/presentation/views/frames/user_space_info_frame.dart';
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
  late final SettingPageViewModel settingPageViewModel;
  late final CreateWorkspaceViewModel createWorkspaceViewModel;

  @override
  void initState() {
    super.initState();
    var userData = Provider.of<UserDataProvider>(context, listen: false);
    userPageViewModel = UserSpaceViewModel()
      ..userDataProvider = userData;
    
    settingPageViewModel = SettingPageViewModel()
      ..userDataProvider = userData;
    
    createWorkspaceViewModel = CreateWorkspaceViewModel()
      ..update(userData);
  }

  @override
  Widget build(BuildContext context){
    return MultiProvider(
      providers: [
        ChangeNotifierProxyProvider<UserDataProvider, UserSpaceViewModel>(
          create: (context) => userPageViewModel..init(),
          update: (context, userDataProvider, userSpaceViewModel) => userSpaceViewModel!..update(userDataProvider),
        ),
        ChangeNotifierProxyProvider<UserDataProvider, SettingPageViewModel>(
          create: (context) => settingPageViewModel..init(),
          update: (context, userDataProvider, userSpaceSettingViewModel) => userSpaceSettingViewModel!..update(userDataProvider),
        ),
        ChangeNotifierProxyProvider<UserDataProvider, CreateWorkspaceViewModel>(
          create: (context) => createWorkspaceViewModel,
          update: (context, userDataProvider, createWorkspaceViewModel) => createWorkspaceViewModel!..update(userDataProvider),
        ),
      ],
      child: _buildBody(),
    );
  }


  int getPageIndex(BuildContext context) {
    // get current page index from path
    final RouteMatch lastMatch = GoRouter.of(context).routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch 
      ? lastMatch.matches 
      : GoRouter.of(context).routerDelegate.currentConfiguration;
    final String location = matchList.uri.toString();
    for(var data in pageData){
      if(location.endsWith(data['path'] as String)){
        return data['index'] as int ;
      }
    }
    return 0;
  }

  final pageData = [
    {"path": "home", "index": 0, "title": "主頁", "iconData": Icons.home},
    {"path": "activities", "index": 1, "title": "活動", "iconData": Icons.local_activity},
    {"path": "threads", "index": 2, "title": "訊息", "iconData": Icons.chat_bubble_outline},
    {"path": "settings", "index": 3, "title": "設定", "iconData": Icons.settings},
  ];

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

  _onCreateGroup(BuildContext context, UserEntity creator) async {
    // open create group dialog
    await showDialog(
      context: context,
      builder: (context) => ChangeNotifierProvider.value(
        value: createWorkspaceViewModel,
        child: CreateWorkspaceDialog()
      )
    );

  }
  Widget navigationRailFrame(){
   return DashboardFrameLayout(
      frameColor: userPageViewModel.spaceColor,
      child: Column(
        children: [
          Expanded(
            child: NavigationRail(
              labelType: NavigationRailLabelType.all,
              backgroundColor: Colors.transparent,
              indicatorColor: userPageViewModel.spaceColor,
              selectedIconTheme: const IconThemeData(color: Colors.white),
              onDestinationSelected: (index) {
                  int? userIndex = Provider.of<UserDataProvider>(context, listen: false).currentUser!.id;
                  String path = '/app/user/$userIndex/${pageData[index]['path'] as String}';
                  GoRouter.of(context).go(path);
                },
              destinations: pageData.map((data) => NavigationRailDestination(
                icon: Icon(data['iconData'] as IconData),
                label: Text(data['title'] as String),
              )).toList(),
              selectedIndex: getPageIndex(context),
            ),
          ),
          ...userPageViewModel.currentUser!.joinedWorkspaces.map((workspace) => Padding(
                padding: const EdgeInsets.all(4.0),
                child: Tooltip(
                  preferBelow: false,
                  verticalOffset: - (54 / 4),
                  margin: const EdgeInsets.only(left: 54 * 1.8),
                  message: workspace.name,
                  child: InkWell(
                    onTap: () {
                      GoRouter.of(context).go('/app/workspace/${workspace.id}/home');
                    },
                    child: ProfileAvatar(
                      themePrimaryColor: AppColor.getWorkspaceColorByIndex(workspace.themeColor),
                      imageUrl: workspace.photo != null && workspace.photo!.imageUri.isNotEmpty 
                        ? workspace.photo!.imageUri
                        : "",
                      label: workspace.name,
                      avatarSize: 54,
                    ),
                  ),
                ),
              )),
          Tooltip(
            message: "新增工作小組",
            preferBelow: false,
            verticalOffset: - (28 / 4),
            margin: const EdgeInsets.only(left: 28 * 3),
            child: IconButton(
              color: userPageViewModel.spaceColor,
              onPressed: () => _onCreateGroup(
                context, 
                userPageViewModel.currentUser!), 
              icon: const Icon(Icons.add, size: 28,),
            ),
          ),
          Tooltip(
            verticalOffset: - (28 / 4),
            preferBelow: false,
            margin: const EdgeInsets.only(left: 28 * 3),
            message: "加入工作小組",
            child: IconButton(
              color: userPageViewModel.spaceColor,
              onPressed: (){}, icon: const Icon(Icons.group_add, size: 28,),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getFrames(){
    var color = userPageViewModel.spaceColor;
    return switch (widget.pageType) {
      DashboardPageType.home => [
        SpaceInfoFrame(
          frameColor: color,
          frameHeight: MediaQuery.of(context).size.height,
          frameWidth: MediaQuery.of(context).size.width * 0.25,
        ),
        _tempFrame("home", 1),
      ],
      DashboardPageType.activities => [
        _tempFrame("Calendar", 2),
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
              frames: [
                navigationRailFrame(),
                ..._getFrames(),
              ],
              drawer: _getDrawer(context),
              direction: Axis.horizontal,
        ),
    );
  }

  Widget _getDrawer(BuildContext context){
    var user = Provider.of<UserDataProvider>(context, listen: false);
    return DashboardDrawer(
      primaryColor: userPageViewModel.spaceColor,
      userProfiles: user.currentUser!,
      workspaceProfiles: user.currentUser!.joinedWorkspaces,
      selectedProfileId: user.currentUser!.id,
    );
  }

  SpaceAppBar _getAppBar() {
    var user = Provider.of<UserDataProvider>(context, listen: false);
    return SpaceAppBar(
      color: userPageViewModel.spaceColor,
      spaceName:  user.currentUser?.name ?? "",
      spaceProfilePicURL: user.currentUser?.photo != null ? userPageViewModel.currentUser!.photo!.imageUri : "",
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