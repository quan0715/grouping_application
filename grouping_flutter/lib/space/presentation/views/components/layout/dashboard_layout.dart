import 'package:flutter/material.dart';
import 'package:grouping_project/space/presentation/views/components/app/dashboard_app_bar.dart';

class DashboardView extends StatelessWidget{

  // final String dashboardTitle;
  final List<Widget> frames;
  // final Color themePrimaryColor;
  final Color backgroundColor;
  final DashboardAppBar appBar;
  final Widget drawer;
  // this for mobile
  // final Widget bottomNavigationBar;
  

  const DashboardView({
    super.key,
    // required this.dashboardTitle,
    this.frames = const [],
    required this.appBar,
    required this.drawer,
    this.backgroundColor = Colors.white,
    // this.bottomNavigationBar,
    // this.themePrimaryColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) => _buildBody(context);

  Widget _buildBody(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      drawer: drawer,
      body: Center(
        child: _buildDashBoard(context, frames),
      ),
    );
  }

  Widget _buildDashBoard(BuildContext context, List<Widget> frames) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: SizedBox(
        // color: viewModel.selectedProfile.spaceColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: frames,
        ),
      ),
    );
  }
}
