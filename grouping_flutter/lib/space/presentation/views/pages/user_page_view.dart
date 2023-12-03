import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grouping_project/space/presentation/views/components/dashboard_app_bar.dart';
import 'package:grouping_project/space/presentation/view_models/user_page_view_model.dart';
import 'package:grouping_project/space/presentation/views/components/dashboard_drawer.dart';
import 'package:grouping_project/space/presentation/views/components/mobile_bottom_navigation_bar.dart';
import 'package:grouping_project/space/presentation/views/frames/setting_frame.dart';
import 'package:grouping_project/space/presentation/views/frames/space_info_and_navigator_frame.dart';
import 'package:provider/provider.dart';

class UserPageView extends StatelessWidget {
  const UserPageView({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => UserPageViewModel()..init(), child: _buildBody());

  Widget _buildDashBoard(BuildContext context, List<Widget> frames) {
    return Consumer<UserPageViewModel>(
        builder: (context, viewModel, child) => Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Container(
                // color: viewModel.selectedProfile.spaceColor,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Row(
                  children: frames,
                ),
              ),
            ));
  }

  Widget _buildBody() {
    return Consumer<UserPageViewModel>(
      builder: (context, viewModel, child) => Scaffold(
        backgroundColor: Colors.white,
        appBar: _getAppBar(context, viewModel),
        body: Center(
          child: _buildDashBoard(context, [
            // TODO: add frames
            SpaceInfoAndNavigatorFrame(
              frameColor: viewModel.selectedProfile.spaceColor,
              frameWidth: MediaQuery.of(context).size.width * 0.25,
            ),
            SettingFrame(viewModel: viewModel)
          ]),
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

  DashboardAppBar _getAppBar(
      BuildContext context, UserPageViewModel viewModel) {
    return DashboardAppBar(
      // color: viewModel.selectedProfile.spaceColor,
      profile: viewModel.selectedProfile,
    );
  }

  Widget? _getNavigationBar(BuildContext context, UserPageViewModel viewModel) {
    if (kIsWeb) {
      return null;
    } else {
      debugPrint("is not web, return bottom navigation bar");
      return MobileBottomNavigationBar(
        currentIndex: viewModel.currentPageIndex,
        themePrimaryColor: viewModel.selectedProfile.spaceColor,
        onTap: (index) => viewModel.updateCurrentIndex(index),
      );
    }
  }
}
