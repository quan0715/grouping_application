import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grouping_project/app/presentation/components/chips/user_profile_chip.dart';
import 'package:grouping_project/app/presentation/components/data_display/key_value_pair_widget.dart';
import 'package:grouping_project/core/theme/color.dart';
import 'package:grouping_project/space/presentation/view_models/activity_list_view_model.dart';
import 'package:grouping_project/space/presentation/views/components/layout/dashboard_frame_layout.dart';
import 'package:provider/provider.dart';

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
    return Consumer<ActivityDisplayViewModel>(
      builder: (context, vm, child) => Row(
        children: [
          // title
          Text('@ ${vm.selectedActivity.belongWorkspace.name} 事件', style: Theme.of(context).textTheme.titleSmall!.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColor.getWorkspaceColorByIndex(vm.selectedActivity.belongWorkspace.themeColor),
          ),),
          const Spacer(),
          // delete button
          IconButton(
            onPressed: (){},
            color: AppColor.getWorkspaceColorByIndex(vm.selectedActivity.belongWorkspace.themeColor),
            icon: const Icon(Icons.delete),
          ),
          // notification button
          IconButton(
            onPressed: (){},
            color: AppColor.getWorkspaceColorByIndex(vm.selectedActivity.belongWorkspace.themeColor),
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityInfoFrame(BuildContext context){
    return Consumer<ActivityDisplayViewModel>(
      builder: (context, vm, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            gap,
            // AppTextFormField(
            //   filled: false,
            //   primaryColor: vm.activityColor,
            //   // initialValue: vm.selectedActivity.title,
            //   hintText: '請輸入標題',
            //   contentStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
            //     fontWeight: FontWeight.bold,
            //   ),
            //   onChanged: (value) => vm.selectedActivity.title = value!,
            //   onSubmit: (value) => vm.selectedActivity.title = value!,
            // ),
            Text(vm.selectedActivity.title, style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              
            ),),
            gap,
            KeyValuePairWidget<String, Widget>(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
              primaryColor: vm.activityColor,
              keyChild: vm.isEvent ? "開始時間" : "死線",
              valueChild: ElevatedButton(
                  onPressed: (){}, 
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: vm.activityColor,
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0), 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(vm.startTime, style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ))),
            ),
            Visibility(
              visible: vm.isEvent,
              child: KeyValuePairWidget<String, Widget>(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                primaryColor: vm.activityColor,
                keyChild: '結束時間',
                valueChild: ElevatedButton(
                    onPressed: (){}, 
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: vm.activityColor,
                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0), 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(vm.endTime, style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ))),
              ),
            ),
            KeyValuePairWidget<String, Widget>(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
              primaryColor: vm.activityColor,
              keyChild: '參與者',
              valueChild: Wrap(
                spacing: 5,
                runSpacing: 5,
                children: vm.selectedActivity.belongWorkspace.members
                .map((member) => UserProfileChip(
                  member: member,
                  color: vm.activityColor)).toList(),
              ),
            ),
            // Divider(color: color.withOpacity(0.3)),
            KeyValuePairWidget(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
              primaryColor: vm.activityColor,
              keyChild: "說明", 
              valueChild: vm.selectedActivity.introduction
            )
          ],
      ),
    );
  }

  Widget _buildRelatedActivityFrame(BuildContext context){
    return Consumer<ActivityDisplayViewModel>(
      builder: (context, vm, child) => Column(
        mainAxisAlignment: MainAxisAlignment.start ,
        children: [
          KeyValuePairWidget<String, Widget>(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            primaryColor: vm.activityColor,
            keyChild: "相關任務", 
            valueChild: TextButton.icon(
              onPressed: (){}, 
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0), 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              icon: const Icon(Icons.add, color: Colors.black54,), 
              label: Text("連結子任務", style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: Colors.black54,
              ))),
          )
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return DashboardFrameLayout(
      frameColor: color,
      frameWidth: frameWidth,
      frameHeight: frameHeight,
      // padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: DashboardFrameLayout(
        frameColor: Colors.white,
        child: Column(
          children: [
            _buildFrameToolBar(context),
            // gap,
            // Divider(color: color.withOpacity(0.3)),
            // gap,
            _buildActivityInfoFrame(context),
            gap,
            _buildRelatedActivityFrame(context),
          ],
        ),
      ),
    );
  }
}
