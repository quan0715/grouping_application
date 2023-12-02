import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grouping_project/space/presentation/view_models/workspace_view_model.dart';
import 'package:grouping_project/space/presentation/views/components/dashboard_app_bar.dart';
import 'package:grouping_project/space/presentation/view_models/user_page_view_model.dart';
import 'package:grouping_project/space/presentation/views/components/dashboard_drawer.dart';
import 'package:grouping_project/space/presentation/views/components/mobile_bottom_navigation_bar.dart';
import 'package:grouping_project/space/presentation/views/frames/workspace_info_and_navigator_frame.dart';
import 'package:provider/provider.dart';


class WorkspacePageView extends StatelessWidget {
  const WorkspacePageView({super.key});
  
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => WorkspaceViewModel()..init(),
    child: _buildBody()
  );

  Widget _buildDashBoard(BuildContext context, List<Widget> frames){
    return Consumer<WorkspaceViewModel>(
      builder: (context, viewModel, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Container(
          // color: viewModel.selectedProfile.spaceColor,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Row(
            children: frames,
          ),
        ),
      )
    );
  }

  Widget _buildBody(){
    return Consumer2<UserPageViewModel, WorkspaceViewModel>(
      builder: (context, userVM, workspaceVM, child) => Scaffold(
        backgroundColor: Colors.white,
        appBar: _getAppBar(context, workspaceVM),
        body: Center(
          child: _buildDashBoard(context, [
            // TODO: add frames
            // SpaceInfoAndNavigatorFrame(
            //   frameColor: userVM.selectedProfile.spaceColor,
            //   frameWidth: MediaQuery.of(context).size.width * 0.25,
            // ),
            WorkspaceInfoAndNavigatorFrame(
              workspace: workspaceVM.getEntity(),
              frameColor: workspaceVM.workspaceProfile.spaceColor,
              frameWidth: MediaQuery.of(context).size.width * 0.25,
            )
          ]),
        ),
        bottomNavigationBar: _getNavigationBar(context, workspaceVM),
        drawer: DashboardDrawer(
          selectedProfile: userVM.selectedProfile,
          userProfiles: userVM.userProfiles,
          workspaceProfiles: userVM.workspaceProfiles,
        ),
      ),
    );
  }

  DashboardAppBar _getAppBar(BuildContext context, WorkspaceViewModel viewModel){
    return DashboardAppBar(
      // color: viewModel.selectedProfile.spaceColor,
      profile: viewModel.workspaceProfile,
    );
  }
  
  Widget? _getNavigationBar(BuildContext context, WorkspaceViewModel viewModel){
    if(kIsWeb){
      return null;
    }else{
      debugPrint("is not web, return bottom navigation bar");
      return MobileBottomNavigationBar(
          currentIndex: viewModel.currentPageIndex,
          themePrimaryColor: viewModel.workspaceProfile.spaceColor,
          onTap: (index) => viewModel.updateCurrentIndex(index),
      );
    }
  }
}


