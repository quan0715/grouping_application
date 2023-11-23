import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grouping_project/dashboard/presentation/views/components/dashboard_app_bar.dart';
import 'package:grouping_project/dashboard/presentation/view_models/user_page_view_model.dart';
import 'package:grouping_project/dashboard/presentation/views/components/dashboard_drawer.dart';
import 'package:grouping_project/dashboard/presentation/views/components/mobile_bottom_navigation_bar.dart';
import 'package:provider/provider.dart';


class UserPageView extends StatelessWidget {
  const UserPageView({super.key});
  
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => UserPageViewModel(),
    child: _buildBody()
  );

  Widget _buildBody(){
    return Consumer<UserPageViewModel>(
      builder: (context, viewModel, child) => Scaffold(
        appBar: _getAppBar(context, viewModel),
        body: const Center(
          child: Text('User Page'),
        ),
        bottomNavigationBar: _getNavigationBar(context, viewModel),
        drawer: DashboardDrawer(
          selectedProfile: viewModel.selectedProfile,
          userProfiles: viewModel.userProfiles,
          workspaceProfiles: viewModel.workspaceProfiles,
        ),
      ),
    );
  }

  DashboardAppBar _getAppBar(BuildContext context, UserPageViewModel viewModel){
    return DashboardAppBar(
      // color: viewModel.selectedProfile.spaceColor,
      profile: viewModel.selectedProfile,
    );
  }
  
  Widget? _getNavigationBar(BuildContext context, UserPageViewModel viewModel){
    if(kIsWeb){
      return null;
    }else{
      debugPrint("is not web, return bottom navigation bar");
      return MobileBottomNavigationBar(
          currentIndex: viewModel.currentPageIndex,
          themePrimaryColor: viewModel.selectedProfile.spaceColor,
          onTap: (index) => viewModel.updateCurrentIndex(index),
      );
    }
  }
}