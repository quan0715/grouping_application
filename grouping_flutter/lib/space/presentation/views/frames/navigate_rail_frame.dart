import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grouping_project/core/theme/color.dart';
import 'package:grouping_project/space/presentation/view_models/create_workspace_view_model.dart';
import 'package:grouping_project/space/presentation/view_models/join_workspace_view_model.dart';
import 'package:grouping_project/space/presentation/view_models/user_page_view_model.dart';
import 'package:grouping_project/space/presentation/views/components/layout/dashboard_frame_layout.dart';
import 'package:grouping_project/space/presentation/views/components/profile_avatar.dart';
import 'package:grouping_project/space/presentation/views/frames/create_workspace_dialog.dart';
import 'package:grouping_project/space/presentation/views/frames/join_worksapce_dialog.dart';
import 'package:provider/provider.dart';

class NavigateRailFrame extends StatefulWidget{
  const NavigateRailFrame({
    super.key,
    this.frameColor = Colors.white,
    this.frameHeight,
    this.frameWidth,
  });

  final Color frameColor;
  final double? frameHeight;
  final double? frameWidth;

  @override
  State<NavigateRailFrame> createState() => _NavigateRailFrameState();
}

class _NavigateRailFrameState extends State<NavigateRailFrame> {
  final pageData = [
    {"path": "home", "index": 0, "title": "主頁", "iconData": Icons.home},
    {"path": "activities", "index": 1, "title": "活動", "iconData": Icons.local_activity},
    {"path": "threads", "index": 2, "title": "訊息", "iconData": Icons.chat_bubble_outline},
    {"path": "settings", "index": 3, "title": "設定", "iconData": Icons.settings},
  ];

  late final CreateWorkspaceViewModel createWorkspaceViewModel;
  late final JoinWorkspaceViewModel joinWorkspaceViewModel;

  @override
  void initState() {
    super.initState();
    var userData = Provider.of<UserDataProvider>(context, listen: false);
    createWorkspaceViewModel = CreateWorkspaceViewModel()
      ..update(userData);
    
    joinWorkspaceViewModel = JoinWorkspaceViewModel()
      ..update(userData);
  }

  @override
  void dispose() {
    super.dispose();
    createWorkspaceViewModel.dispose();
    joinWorkspaceViewModel.dispose();
  }

  _onCreateGroup(BuildContext context) async {
    // open create group dialog
    await showDialog(
      context: context,
      builder: (context) => ChangeNotifierProvider.value(
        value: createWorkspaceViewModel,
        child: CreateWorkspaceDialog()
      )
    );
  }

  _onJoinWorkspace(BuildContext context,) async {
    // open create group dialog
    await showDialog(
      context: context,
      builder: (context) => ChangeNotifierProvider.value(
        value: joinWorkspaceViewModel,
        child: JoinWorkspaceDialog())
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


  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      ChangeNotifierProxyProvider<UserDataProvider, CreateWorkspaceViewModel>(
          create: (context) => createWorkspaceViewModel,
          update: (context, userDataProvider, createWorkspaceViewModel) => createWorkspaceViewModel!..update(userDataProvider),
        ),
      ChangeNotifierProxyProvider<UserDataProvider, JoinWorkspaceViewModel>(
        create: (context) => joinWorkspaceViewModel,
        update: (context, userDataProvider, joinWorkspaceViewModel) => joinWorkspaceViewModel!..update(userDataProvider),
      ),
    ],
    child: _buildBody(context));

  Widget _buildBody(BuildContext context){
   return Consumer<UserSpaceViewModel>(
      builder: (context, userPageViewModel, child) => DashboardFrameLayout(
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
            
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
              child: InkWell(
                onTap: () {
                  GoRouter.of(context).push('/app/user/${userPageViewModel.currentUser!.id}/home');
                },
                child: ProfileAvatar(
                  themePrimaryColor: userPageViewModel.spaceColor,
                  imageUrl: userPageViewModel.currentUser!.photo != null && userPageViewModel.currentUser!.photo!.imageUri.isNotEmpty 
                    ? userPageViewModel.currentUser!.photo!.imageUri
                    : "",
                  label: userPageViewModel.currentUser!.name,
                  avatarSize: 72,
                ),
              ),
            ),

            ...userPageViewModel.currentUser!.joinedWorkspaces.map((workspace) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
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
                      avatarSize: 72,
                    ),
                  ),
                )),
            SizedBox(
              width: 72,
              height: 72,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  side: BorderSide(color: userPageViewModel.spaceColor.withOpacity(0.3)),
                ),
                color: Colors.white,
                onPressed: () => _onCreateGroup(context), 
                child: Icon(Icons.add, size: 28, color: userPageViewModel.spaceColor),
              ),
            ),
            const Gap(5),
            SizedBox(
              width: 72,
              height: 72,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  side: BorderSide(color: userPageViewModel.spaceColor.withOpacity(0.3)),
                ),
                color: Colors.white, 
                onPressed: () => _onJoinWorkspace(context), 
                child: Icon(Icons.group_add, size: 28, color: userPageViewModel.spaceColor,),
              ),
            ),
          ],
        ),
      ),
   );
  }
}

