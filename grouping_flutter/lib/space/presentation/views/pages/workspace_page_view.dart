import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grouping_project/app/presentation/providers/token_manager.dart';
import 'package:grouping_project/app/presentation/views/app.dart';
import 'package:grouping_project/core/theme/color.dart';
import 'package:grouping_project/space/presentation/view_models/workspace_view_model.dart';
import 'package:grouping_project/space/presentation/views/components/app/dashboard_app_bar.dart';
import 'package:grouping_project/space/presentation/view_models/user_page_view_model.dart';
import 'package:grouping_project/space/presentation/views/components/app/dashboard_drawer.dart';
import 'package:grouping_project/space/presentation/views/components/app/mobile_bottom_navigation_bar.dart';
import 'package:grouping_project/space/presentation/views/components/layout/dashboard_layout.dart';
import 'package:grouping_project/space/presentation/views/frames/navigate_rail_frame.dart';
import 'package:grouping_project/space/presentation/views/frames/workspace_info_and_navigator_frame.dart';
import 'package:grouping_project/space/presentation/views/pages/user_page_view.dart';
import 'package:provider/provider.dart';

class WorkspacePageView extends StatefulWidget {
  const WorkspacePageView({super.key, required DashboardPageType pageType});

  @override
  State<WorkspacePageView> createState() => _WorkspacePageViewState();

}

class _WorkspacePageViewState extends State<WorkspacePageView> {

  late final WorkspaceViewModel viewModel;

  @override
  void initState(){
    super.initState();
    viewModel = WorkspaceViewModel();
    viewModel.init();
  }
  
  @override
  Widget build(BuildContext context){
    return MultiProvider(
      providers: [
        ChangeNotifierProxyProvider<UserDataProvider, WorkspaceViewModel>(
          create: (context) => viewModel,
          update: (context, userDataProvider, workspaceViewModel) => 
            workspaceViewModel!..update(userDataProvider),
        ),

      ],
      child: _buildBody(),
    );
  }

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

  Widget _buildBody() {
    return Consumer<WorkspaceViewModel>(
        builder: (context, userSpaceViewModel, child) => 
          // userSpaceViewModel.isLoading
          //   ? const Scaffold(
          //     body: Center(
          //       child: CircularProgressIndicator(),
          //     ),
          //   )
          // : 
          const DashboardView(
            backgroundColor: Colors.white,
            // appBar: _getAppBar(context, viewModel),
            frames: [
              // NavigateRailFrame(),
              // ..._getFrames(),
            ],
            // drawer: _getDrawer(context),
            direction: Axis.horizontal,
        ),
    );
  }
}


