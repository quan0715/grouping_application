import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grouping_project/core/shared/color_widget_interface.dart';
import 'package:grouping_project/space/presentation/view_models/user_page_view_model.dart';
import 'package:grouping_project/space/presentation/views/components/layout/dashboard_frame_layout.dart';
import 'package:grouping_project/space/presentation/views/components/navigated_profile_info_card.dart';
import 'package:grouping_project/space/presentation/views/components/profile_avatar.dart';
import 'package:grouping_project/space/presentation/views/components/user_action_button.dart';
import 'package:grouping_project/space/presentation/views/frames/create_workspace_dialog.dart';
import 'package:provider/provider.dart';

class SpaceInfoAndNavigatorFrame extends StatelessWidget implements WithThemePrimaryColor{
  // SpaceInfoAndNavigatorFrame, display space info with expanded user information card and navigator route list 
  final Color frameColor;
  final double? frameHeight;
  final double? frameWidth;

  const SpaceInfoAndNavigatorFrame({
    this.frameColor = Colors.white,
    this.frameHeight,
    this.frameWidth,
    super.key
  });

  int getPageIndex(BuildContext context) {
    // var r = GoRouter.of(context).configuration. .last;
    final RouteMatch lastMatch = GoRouter.of(context).routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = 
      lastMatch is ImperativeRouteMatch 
        ? lastMatch.matches 
        : GoRouter.of(context).routerDelegate.currentConfiguration;
    final String location = matchList.uri.toString();
    if(location.endsWith('home')){
      return 0;
    }
    if(location.endsWith('activities')){
      return 1;
    }
    if(location.endsWith('threads')){
      return 2;
    }
    if(location.endsWith('settings')){
      return 3;
    }
    return 0;
  }


  @override
  Widget build(BuildContext context) => _buildBody(context);

  Widget _buildBody(BuildContext context){
    return DashboardFrameLayout(
      frameWidth: frameWidth,
      frameHeight: frameHeight,
      frameColor: frameColor.withOpacity(0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSpaceInfo(context),
          const Spacer(),
          _buildNavigator(context)
        ],
      ),
    );
  }

  Widget _buildNavigator(BuildContext context) {
    const double tileHeight = 40;
    int pageIndex = getPageIndex(context);
    final onSelectedTextStyle = Theme.of(context).textTheme.labelLarge!.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );
    return SizedBox(
      height: tileHeight * 5,
      child: NavigationDrawerTheme(
        data: NavigationDrawerThemeData(
          tileHeight: tileHeight,
          elevation: 0, 
          indicatorColor: getThemePrimaryColor,
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          child: NavigationDrawer(
            selectedIndex: getPageIndex(context),
            tilePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            onDestinationSelected: (index) {
              int? userIndex = Provider.of<UserDataProvider>(context, listen: false).currentUser!.id;
              String path = switch(index){
                0 => '/app/user/$userIndex/home',
                1 => '/app/user/$userIndex/activities',
                2 => '/app/user/$userIndex/threads',
                3 => '/app/user/$userIndex/settings',
                _ => '/app/user/$userIndex/home',
              };
              GoRouter.of(context).go(path);
            },
            children:[
              NavigationDrawerDestination(
                icon: const Icon(Icons.dashboard),
                selectedIcon: const Icon(Icons.dashboard, color: Colors.white,),
                label: Text('主頁', style: pageIndex == 0 ? onSelectedTextStyle : null)
              ),
              NavigationDrawerDestination(
                icon: const Icon(Icons.calendar_month),
                selectedIcon: const Icon(Icons.calendar_month, color: Colors.white,),
                label: Text('活動', style: pageIndex == 1 ? onSelectedTextStyle : null)
              ),
              NavigationDrawerDestination(
                icon: const Icon(Icons.message),
                selectedIcon: const Icon(Icons.message,color: Colors.white,),
                label: Text('訊息', style: pageIndex == 2 ? onSelectedTextStyle : null)
              ),
              NavigationDrawerDestination(
                icon: const Icon(Icons.settings),
                selectedIcon: const Icon(Icons.settings, color: Colors.white,),
                label: Text('設定', style: pageIndex == 3 ? onSelectedTextStyle : null)
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSpaceInfo(BuildContext context) {
    final userData = Provider.of<UserDataProvider>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileAvatar(
          themePrimaryColor: getThemePrimaryColor,
          label: userData.currentUser?.name ?? "",
          avatarSize: 55,
          labelFontSize: 20,
        ),
        const Gap(10),
        Text("@user-5-${userData.currentUser?.name ?? ""}", style: Theme.of(context).textTheme.labelLarge!.copyWith(
          color: getThemePrimaryColor,
          fontWeight: FontWeight.bold,
        )),
        const Gap(10),
        Text(userData.currentUser?.name ?? "", style: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        )),
        Divider(color: getThemePrimaryColor.withOpacity(0.2), thickness: 2,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("工作小組 (${userData.getWorkspaceList().length})",
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: getThemePrimaryColor,
                fontWeight: FontWeight.bold,
            )),
            const Spacer(),
            
          ],
        ),
        const Gap(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: UserActionButton.secondary(
                onPressed: () => _onCreateGroup(context),
                label: "創建小組",
                primaryColor: getThemePrimaryColor,
                icon: const Icon(Icons.add),
              ),
            ),
            const Gap(5),
            Expanded(
              child: UserActionButton.secondary(
                onPressed: (){},
                label: "加入小組",
                primaryColor: getThemePrimaryColor,
                icon: const Icon(Icons.group_add),
              ),
            ),
          ],
        ),
        const Gap(10),
        ...userData.getWorkspaceList().map((profile) => Padding(
          padding: const EdgeInsets.all(4.0),
          child: NavigatedProfileInfoCardButton(profile: profile,),
        )),
        // const Divider(),
        
      ],
    );
  }
  


  @override
  Color get getThemePrimaryColor => frameColor;
  
  _onCreateGroup(BuildContext context) async {
    // open create group dialog
    await showDialog(
      context: context,
      builder: (context) => const CreateWorkspaceDialog()
    );
  }
}

