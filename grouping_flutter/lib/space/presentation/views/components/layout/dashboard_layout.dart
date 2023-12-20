import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grouping_project/space/presentation/views/components/app/dashboard_app_bar.dart';

class DashboardView extends StatelessWidget{

  final List<Widget> frames;
  final Color backgroundColor;
  final SpaceAppBar? appBar;
  final Widget? drawer;
  final Axis direction;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const DashboardView({
    super.key,    
    this.frames = const [],
    this.appBar,
    this.drawer,
    this.backgroundColor = Colors.transparent,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.direction = Axis.horizontal,
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
  final gap = const Gap(10);
  
  List<Widget> _buildFrames(BuildContext context) {
    // add gap between each frame
    List<Widget> framesWithGap = [];
    for(int i = 0; i < frames.length; i++){
      framesWithGap.add(frames[i]);
      if(i < frames.length - 1){
        framesWithGap.add(gap);
      }
    }
    return framesWithGap;
  }

  Widget _buildDashBoard(BuildContext context, List<Widget> frames) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: SizedBox(
        // color: viewModel.selectedProfile.spaceColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: 
        direction == Axis.vertical
        ? Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildFrames(context),
        ): Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildFrames(context),
        ),
      ),
    );
  }
}
