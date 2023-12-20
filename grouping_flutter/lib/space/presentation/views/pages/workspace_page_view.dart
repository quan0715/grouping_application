import 'package:flutter/material.dart';
import 'package:grouping_project/space/presentation/view_models/workspace_view_model.dart';
import 'package:grouping_project/space/presentation/view_models/user_page_view_model.dart';
import 'package:grouping_project/space/presentation/views/components/layout/dashboard_frame_layout.dart';
import 'package:grouping_project/space/presentation/views/components/layout/dashboard_layout.dart';
import 'package:grouping_project/space/presentation/views/frames/navigate_rail_frame.dart';
import 'package:grouping_project/space/presentation/views/frames/worksapce/workspace_info_frame.dart';
import 'package:grouping_project/space/presentation/views/pages/user_page_view.dart';
import 'package:grouping_project/threads/presentations/widgets/chat_thread_body.dart';
import 'package:provider/provider.dart';

class WorkspacePageView extends StatefulWidget {
  const WorkspacePageView({super.key, required this.pageType});
  final DashboardPageType pageType;

  @override
  State<WorkspacePageView> createState() => _WorkspacePageViewState();

}

class _WorkspacePageViewState extends State<WorkspacePageView> {

  late final SpaceViewModel spaceViewModel;

  @override
  void initState(){
    super.initState();
    var userData = Provider.of<UserDataProvider>(context, listen: false);
    var groupData = Provider.of<GroupDataProvider>(context, listen: false);
    spaceViewModel = SpaceViewModel()
      ..updateGroup(groupData)
      ..updateUser(userData)
      ..init();
    // viewModel.init();
  }

  @override
  void dispose(){
    spaceViewModel.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context){
    return MultiProvider(
      providers: [
        ChangeNotifierProxyProvider2<UserDataProvider, GroupDataProvider, SpaceViewModel>(
          create: (context) => spaceViewModel,
          update: (context, userDataProvider, groupDataProvider, spaceViewModel) => 
            spaceViewModel!
              ..updateUser(userDataProvider)
              ..updateGroup(groupDataProvider),
        ),

      ],
      child: _buildBody(),
    );
  }

  Widget _tempFrame(String title, int flex){
    return Expanded(
      flex: flex,
      child: DashboardFrameLayout(
        frameColor: spaceViewModel.spaceColor,
        child: Center(
          child: Text(title),
        )
      ),
    );
  }

  List<Widget> _getFrames(){
    var color = spaceViewModel.spaceColor;
    return switch (widget.pageType) {
      DashboardPageType.home => [
        Expanded(
          flex: 1,
          child: WorkspaceInfoFrame(
            frameColor: color,
          )
        ),
        _tempFrame("home", 3),
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
            frameColor: color,
            child: const ChatThreadBody(
            threadTitle: "Test Thread",
          ))),
      ],
      DashboardPageType.settings => [
        _tempFrame("setting", 1)
      ],
      DashboardPageType.none => [
        _tempFrame("error", 1)
      ],
    };
  }

  Widget _buildBody() {
    return Consumer<SpaceViewModel>(
        builder: (context, spaceViewModel, child) => 
          spaceViewModel.isLoading
            ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : 
          DashboardView(
            backgroundColor: Colors.white,
            frames: [
              const NavigateRailFrame(),
              ..._getFrames(),
            ],
            direction: Axis.horizontal,
        ),
    );
  }
}


