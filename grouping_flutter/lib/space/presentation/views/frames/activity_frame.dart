import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grouping_project/space/presentation/views/components/layout/dashboard_frame_layout.dart';

class ActivityDetailFrame extends StatelessWidget {
  const ActivityDetailFrame({
    super.key,
    this.color = Colors.white,
    this.frameWidth,
    this.frameHeight,
  });
  
  final Color color;
  final double? frameWidth;
  final double? frameHeight;

  final gap = const Gap(5);

  @override
  Widget build(BuildContext context) => _buildBody(context);

  Widget _buildFrameToolBar(BuildContext context){
    return Row(
      children: [
        // title
        Text('@ Grouping 專題小組 事件', style: Theme.of(context).textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.bold,
          color: color,
        ),),
        const Spacer(),
        // delete button
        IconButton(
          onPressed: (){},
          color: color,
          icon: const Icon(Icons.delete),
        ),
        // notification button
        IconButton(
          onPressed: (){},
          color: color,
          icon: const Icon(Icons.notifications),
        ),
      ],
    );
  }

  Widget _buildActivityInfoFrame(BuildContext context){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Coding spring event", style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
          ),),
          gap,
          Text("距離開始還剩 00 D 10 H 10 M ", style: Theme.of(context).textTheme.labelLarge!.copyWith(
            color: color,
          ),),
          gap,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: (){}, 
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: color,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0), 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  // padding: const EdgeInsets.only(right: 10),
                ),
                icon: Icon(Icons.timer_sharp, color: color,), 
                label: Text("11 月 11 日 星期六 18:00", style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: Colors.black87,
                ))),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.arrow_forward, color: color,),
              ),
              ElevatedButton.icon(
                onPressed: (){}, 
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: color,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0), 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  // padding: const EdgeInsets.only(right: 10),
                ),
                icon: Icon(Icons.timer_sharp, color: color,), 
                label: Text("11 月 11 日 星期六 18:00", style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: Colors.black87,
                ))),
            ],
          ) 
        ],
      ),
    );
  }

  Widget _buildRelatedActivityFrame(BuildContext context){
    return Container();
  }

  Widget _buildBody(BuildContext context) {
    return DashboardFrameLayout(
      frameColor: color,
      frameWidth: frameWidth,
      frameHeight: frameHeight,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        children: [
          _buildFrameToolBar(context),
          // gap,
          Divider(color: color.withOpacity(0.5)),
          // gap,
          _buildActivityInfoFrame(context),
          gap,
          _buildRelatedActivityFrame(context),
        ],
      ),
    );
  }
}
