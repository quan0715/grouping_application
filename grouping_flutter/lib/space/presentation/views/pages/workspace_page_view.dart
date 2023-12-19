import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grouping_project/app/presentation/providers/token_manager.dart';
import 'package:grouping_project/space/presentation/view_models/workspace_view_model.dart';
import 'package:grouping_project/space/presentation/views/components/app/dashboard_app_bar.dart';
import 'package:grouping_project/space/presentation/view_models/user_page_view_model.dart';
import 'package:grouping_project/space/presentation/views/components/app/dashboard_drawer.dart';
import 'package:grouping_project/space/presentation/views/components/app/mobile_bottom_navigation_bar.dart';
import 'package:grouping_project/space/presentation/views/frames/workspace_info_and_navigator_frame.dart';
import 'package:provider/provider.dart';

class WorkspacePageView extends StatefulWidget {
  const WorkspacePageView({super.key});

  @override
  State<WorkspacePageView> createState() => _WorkspacePageViewState();

}

class _WorkspacePageViewState extends State<WorkspacePageView> {

  late final WorkspaceViewModel viewModel;

  @override
  void initState(){
    super.initState();
    viewModel = WorkspaceViewModel(tokenModel: Provider.of<TokenManager>(context, listen: false).tokenModel);
    viewModel.init();
  }
  
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<WorkspaceViewModel>.value(
    value: viewModel,
    child: _buildBody()
  );

  Widget _buildDashBoard(BuildContext context, List<Widget> frames){
    return Consumer<WorkspaceViewModel>(
      builder: (context, viewModel, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: SizedBox(
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
    return Consumer2<UserSpaceViewModel, WorkspaceViewModel>(
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
          primaryColor: workspaceVM.workspaceProfile.spaceColor,
          userProfiles: userVM.currentUser!,
          isSelectedUserSpace: false,
          selectedProfileId: 0,
          workspaceProfiles: userVM.currentUser!.joinedWorkspaces,
        ),
      ),
    );
  }

  SpaceAppBar _getAppBar(BuildContext context, WorkspaceViewModel viewModel){
    return SpaceAppBar(
      color: viewModel.workspaceProfile.spaceColor,
      spaceName: viewModel.workspaceProfile.spaceName,
      spaceProfilePicURL: "",
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


