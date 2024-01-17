import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grouping_project/app/presentation/components/chips/user_profile_chip.dart';
import 'package:grouping_project/app/presentation/components/components.dart';
import 'package:grouping_project/app/presentation/components/data_display/key_value_pair_widget.dart';
import 'package:grouping_project/core/theme/color.dart';
import 'package:grouping_project/space/presentation/view_models/activity_list_view_model.dart';
import 'package:grouping_project/space/presentation/views/components/layout/dashboard_frame_layout.dart';
import 'package:grouping_project/space/presentation/views/components/layout/time_display_with_pressable_body.dart';
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

  Widget _buildFrameToolBar(BuildContext context) {
    return Consumer<ActivityDisplayViewModel>(
      builder: (context, vm, child) {
        debugPrint(vm.isEditMode.toString());
        return vm.activityListViewModel!.isCreateMode || vm.isEditMode
            ? _buildFrameInputToolBar(
                context,
                vm.selectedActivity.belongWorkspace.name,
                vm.selectedActivity.belongWorkspace.themeColor)
            : _buildFrameDisplayToolBar(
                context,
                vm.selectedActivity.belongWorkspace.name,
                vm.selectedActivity.belongWorkspace.themeColor);
      },
    );
  }

  Widget _buildFrameDisplayToolBar(
      BuildContext context, String workspaceName, int themeColor) {
    return Row(
      children: [
        // title
        Text(
          '@ $workspaceName 事件',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColor.getWorkspaceColorByIndex(themeColor),
              ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            Provider.of<ActivityDisplayViewModel>(context, listen: false)
                .intoEditMode();
          },
          color: AppColor.getWorkspaceColorByIndex(themeColor),
          icon: const Icon(Icons.edit),
        ),
        // delete button
        IconButton(
          onPressed: () {
            Provider.of<ActivityDisplayViewModel>(context, listen: false)
                .deleteActivity();
          },
          color: AppColor.getWorkspaceColorByIndex(themeColor),
          icon: const Icon(Icons.delete),
        ),
        // notification button
        IconButton(
          onPressed: () {
            debugPrint("notification");
          },
          color: AppColor.getWorkspaceColorByIndex(themeColor),
          icon: const Icon(Icons.notifications),
        ),
      ],
    );
  }

  Widget _buildFrameInputToolBar(
      BuildContext context, String workspaceName, int themeColor) {
    return Row(
      children: [
        // title
        Text(
          '@ $workspaceName',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColor.getWorkspaceColorByIndex(themeColor),
              ),
        ),
        const Spacer(),
        // delete button
        UserActionButton.secondary(
          icon: const Icon(Icons.close),
          label: "取消",
          primaryColor: AppColor.getWorkspaceColorByIndex(themeColor),
          onPressed: () {
            final vm =
                Provider.of<ActivityDisplayViewModel>(context, listen: false);
            vm.cancelEditOrCreate();
          },
        ),
        gap,
        // notification button
        UserActionButton.primary(
          icon: const Icon(Icons.check),
          label:
              "建立${Provider.of<ActivityDisplayViewModel>(context, listen: false).isEvent ? "活動" : "任務"}",
          primaryColor: AppColor.getWorkspaceColorByIndex(themeColor),
          onPressed: () {
            final vm =
                Provider.of<ActivityDisplayViewModel>(context, listen: false);
            if (vm.activityListViewModel!.isCreateMode) {
              vm.activityListViewModel!.isCreateEvent
                  ? vm.createEventDone()
                  : vm.createMissionDone();
            } else {
              vm.editDone();
            }
          },
        ),
      ],
    );
  }

  Widget _buildActivityInfoFrame(BuildContext context) {
    return Consumer<ActivityDisplayViewModel>(
      builder: (context, vm, child) => Visibility(
        visible: !vm.isEditMode,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            gap,
            Text(
              vm.selectedActivity.title,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            gap,
            KeyValuePairWidget<String, Widget>(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                primaryColor: vm.isEvent ? vm.activityColor : Colors.red,
                keyChild: vm.isEvent
                    ? vm.isEventStartedNow
                        ? vm.isOverNow
                            ? "活動已經結束"
                            : "距離活動結束還剩 ${vm.endtimeDifference.inDays} D ${vm.endtimeDifference.inHours % 24} H ${vm.endtimeDifference.inMinutes % 60} M"
                        : "距離活動開始還剩 ${vm.timeDifference.inDays} D ${vm.timeDifference.inHours % 24} H ${vm.timeDifference.inMinutes % 60} M"
                    : vm.isOverNow
                        ? "任務已經結束"
                        : "距離任務結束還剩 ${vm.timeDifference.inDays} D ${vm.timeDifference.inHours % 24} H ${vm.timeDifference.inMinutes % 60} M",
                valueChild: Row(children: [
                  TimeDisplayWithPressibleBody(
                      activityColor: vm.activityColor, time: vm.startTime),
                  gap,
                  Visibility(
                      visible: vm.isEvent,
                      child: const Icon(Icons.arrow_forward)),
                  gap,
                  Visibility(
                    visible: vm.isEvent,
                    child: TimeDisplayWithPressibleBody(
                        activityColor: vm.activityColor, time: vm.endTime),
                  )
                ])),
            Row(
              children: vm.selectedActivity.belongWorkspace.members!
                  .map((member) => Row(children: [
                        UserProfileChip(
                            member: member, color: vm.activityColor),
                        gap
                      ]))
                  .toList(),
            ),
            gap,
            Divider(color: color.withOpacity(0.3)),
            KeyValuePairWidget(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                primaryColor: vm.activityColor,
                keyChild: "說明",
                valueChild: vm.selectedActivity.introduction),
            gap,
            Divider(color: color.withOpacity(0.3)),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityEditFrame(BuildContext context) {
    return Consumer<ActivityDisplayViewModel>(
      builder: (context, vm, child) => Visibility(
        visible: vm.isEditMode,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            gap,
            AppTextFormField(
              initialValue: vm.selectedActivity.title,
              hintText: "點擊變更標題",
              primaryColor: vm.activityColor,
              fillColor: Colors.white.withOpacity(0.4),
              textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              contentStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              onChanged: (value) {
                vm.titleInChange = value ?? "";
              },
            ),
            gap,
            KeyValuePairWidget<String, Widget>(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                primaryColor: vm.isEvent ? vm.activityColor : Colors.red,
                keyChild: "編輯時間",
                valueChild: Row(children: [
                  TimeDisplayWithPressibleBody(
                    activityColor: vm.activityColor,
                    time: vm.formattedDate.format(vm.startTimeInChange),
                    onPressed: () {
                      showDatePicker(
                              context: context,
                              initialDate: vm.startTimeDateTime,
                              firstDate: DateTime.now()
                                  .subtract(const Duration(days: 180)),
                              lastDate:
                                  DateTime.now().add(const Duration(days: 365)))
                          .then((value) => vm.setStartTimeInChange(
                              value ?? vm.startTimeDateTime));
                    },
                  ),
                  gap,
                  Visibility(
                      visible: vm.isEvent,
                      child: const Icon(Icons.arrow_forward)),
                  gap,
                  Visibility(
                    visible: vm.isEvent,
                    child: TimeDisplayWithPressibleBody(
                        activityColor: vm.activityColor,
                        time: vm.formattedDate.format(vm.endTimeInChange),
                        onPressed: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: vm.endTimeDateTime,
                                  firstDate: DateTime.now()
                                      .subtract(const Duration(days: 180)),
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 365)))
                              .then((value) => vm.setEndTimeInChange(
                                  value ?? vm.endTimeDateTime));
                        }),
                  )
                ])),
            KeyValuePairWidget<String, Widget>(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
              primaryColor: vm.activityColor,
              keyChild: "編輯參與者",
              valueChild: Row(
                  children: (vm.selectedActivity.belongWorkspace.members!
                          .map((member) => Row(children: [
                                UserProfileChip(
                                    member: member, color: vm.activityColor),
                                gap
                              ]) as Widget)
                          .toList()) +
                      [
                        TextButton.icon(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: vm.selectedActivity
                                            .belongWorkspace.members!
                                            .map((member) => Row(children: [
                                                  UserProfileChip(
                                                    member: member,
                                                    color: vm.activityColor,
                                                    selected: vm
                                                        .contributorsInChange
                                                        .contains(member.id),
                                                    onPressed: () {
                                                      debugPrint(vm
                                                          .contributorsInChange
                                                          .toString());
                                                      if (vm
                                                          .contributorsInChange
                                                          .contains(
                                                              member.id)) {
                                                        vm.removeContributer(
                                                            member.id);
                                                      } else {
                                                        vm.addContributer(
                                                            member.id);
                                                      }
                                                    },
                                                  ),
                                                  gap
                                                ]))
                                            .toList(),
                                      ),
                                    );
                                  });
                            },
                            icon: const Icon(Icons.add),
                            label: const Text("新增參與者"))
                      ]),
            ),
            gap,
            Divider(color: color.withOpacity(0.3)),
            KeyValuePairWidget<String, Widget>(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
              primaryColor: vm.activityColor,
              keyChild: "說明",
              valueChild: AppTextFormField(
                initialValue: vm.selectedActivity.introduction,
                hintText: "點擊新增${vm.isEvent ? "活動" : "任務"}說明",
                primaryColor: vm.activityColor,
                fillColor: Colors.white.withOpacity(0.4),
                onChanged: (value) {
                  vm.introductionInChange = value ?? "";
                },
              ),
            ),
            gap,
            Divider(color: color.withOpacity(0.3)),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCreateFrame(BuildContext context) {
    return Consumer<ActivityDisplayViewModel>(
      builder: (context, vm, child) => Visibility(
        visible: vm.activityListViewModel!.isCreateMode,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            gap,
            Text(
              vm.selectedActivity.title,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            gap,
            KeyValuePairWidget<String, Widget>(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                primaryColor: vm.isEvent ? vm.activityColor : Colors.red,
                keyChild: "編輯時間",
                valueChild: Row(children: [
                  TimeDisplayWithPressibleBody(
                    activityColor: vm.activityColor,
                    time: vm.formattedDate.format(DateTime.now()),
                    onPressed: () {
                      showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now()
                                  .subtract(const Duration(days: 180)),
                              lastDate:
                                  DateTime.now().add(const Duration(days: 365)))
                          .then((value) => vm.setStartTimeInChange(
                              value ?? vm.startTimeDateTime));
                    },
                  ),
                  gap,
                  Visibility(
                      visible: vm.activityListViewModel!.isCreateEvent,
                      child: const Icon(Icons.arrow_forward)),
                  gap,
                  Visibility(
                    visible: vm.activityListViewModel!.isCreateEvent,
                    child: TimeDisplayWithPressibleBody(
                        activityColor: vm.activityColor,
                        time: vm.formattedDate.format(
                            DateTime.now().add(const Duration(hours: 1))),
                        onPressed: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: vm.endTimeDateTime,
                                  firstDate: DateTime.now()
                                      .subtract(const Duration(days: 180)),
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 365)))
                              .then((value) => vm.setEndTimeInChange(
                                  value ?? vm.endTimeDateTime));
                        }),
                  )
                ])),
            Row(
              children: [
                ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    onPressed: () {},
                    label: const Text("新增參與者"))
              ],
            ),
            gap,
            Divider(color: color.withOpacity(0.3)),
            KeyValuePairWidget<String, Widget>(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
              primaryColor: vm.activityColor,
              keyChild: "說明",
              valueChild: AppTextFormField(
                initialValue: vm.introductionInChange,
                hintText: "點擊新增${vm.isEvent ? "活動" : "任務"}說明",
                primaryColor: vm.activityColor,
                onChanged: (value) {
                  vm.introductionInChange = value ?? "";
                },
              ),
            ),
            gap,
            Divider(color: color.withOpacity(0.3)),
          ],
        ),
      ),
    );
  }

  Widget _buildRelatedActivityFrame(BuildContext context) {
    return Consumer<ActivityDisplayViewModel>(
      builder: (context, vm, child) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          KeyValuePairWidget<String, Widget>(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            primaryColor: vm.activityColor,
            keyChild: "相關任務",
            valueChild: TextButton.icon(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                icon: const Icon(
                  Icons.add,
                  color: Colors.black54,
                ),
                label: Text("連結子任務",
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
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
        frameColor: color,
        child: Column(
          children: [
            _buildFrameToolBar(context),
            // gap,
            // Divider(color: color.withOpacity(0.3)),
            // gap,
            _buildActivityInfoFrame(context),
            _buildActivityEditFrame(context),
            _buildActivityCreateFrame(context),
            gap,
            _buildRelatedActivityFrame(context),
          ],
        ),
      ),
    );
  }
}
