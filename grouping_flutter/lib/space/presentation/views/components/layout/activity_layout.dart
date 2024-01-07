import 'package:flutter/material.dart';
import 'package:grouping_project/app/presentation/components/chips/color_tag_chip.dart';
import 'package:grouping_project/app/presentation/components/data_display/color_card_widget.dart';
import 'package:grouping_project/core/theme/color.dart';
import 'package:grouping_project/space/domain/entities/event_entity.dart';
import 'package:grouping_project/space/domain/entities/mission_entity.dart';
import 'package:grouping_project/space/presentation/view_models/activity_list_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

enum ActivityType {
  event,
  mission;
}

class ActivityLayout extends StatelessWidget {
  final String title;
  final bool isWorkspace;
  final ActivityType type;
  final Color color;

  const ActivityLayout({
    super.key,
    required this.title,
    required this.color,
    this.isWorkspace = true,
    this.type = ActivityType.event,
  });

  @override
  Widget build(BuildContext context) => _buildBody(context);

  Widget _buildBody(BuildContext context) {
    ActivityListViewModel activityListViewModel =
        Provider.of<ActivityListViewModel>(context, listen: false);
    int len = type == ActivityType.event
        ? activityListViewModel.events.length
        : activityListViewModel.missions.length;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("$title ($len)",
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: color, fontWeight: FontWeight.bold)),
            const Spacer(),
            _createButton(context, type),
          ],
        ),
        Expanded(
            child: type == ActivityType.event
                ? _displayEventBody(activityListViewModel)
                : _displayMissionBody(context, activityListViewModel)),
      ],
    );
  }

  Widget _displayMissionBody(
      BuildContext context, ActivityListViewModel activityListViewModel) {
    List<String> missionGroupLabel = ["ALL", "未開始", "進行中", "待回覆", "已完成"];

    List<List<MissionEntity>> missionsGroupList = [
      activityListViewModel.missions,
      activityListViewModel.progressingMissions,
      activityListViewModel.progressingMissions,
      activityListViewModel.progressingMissions,
      activityListViewModel.finishMissions
    ];

    return LayoutBuilder(builder: (context, constraints) {
      return DefaultTabController(
        initialIndex: 0,
        length: 5,
        child: Column(children: [
          TabBar(
              labelPadding: const EdgeInsets.symmetric(horizontal: 5),
              tabs: List.generate(
                  missionsGroupList.length,
                  (index) => Tab(
                        child: Text(
                          "${missionGroupLabel[index]} ${missionsGroupList[index].length}",
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ))),
          Expanded(
              child: TabBarView(
                  children: missionsGroupList
                      .map((missionGroup) =>
                          _buildMission(activityListViewModel, missionGroup))
                      .toList())),
        ]),
      );
    });
  }

  Widget _displayEventBody(ActivityListViewModel activityListViewModel) {
    List<EventEntity> events = activityListViewModel.events!;

    return LayoutBuilder(builder: (context, constraints) {
      return ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          var belongWorkspace = events[index].belongWorkspace.toEntity();
          var displayColor =
              AppColor.getWorkspaceColorByIndex(belongWorkspace.themeColor);
          DateFormat format = DateFormat("hh:mm");
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: InkWell(
                onTap: () {
                  activityListViewModel.selectActivity(events[index]);
                },
                child: ActivityCard.event(
                  color: displayColor,
                  belongingGroup: belongWorkspace.name,
                  activityTitle: events[index].title,
                  isSelected: events[index].id ==
                      activityListViewModel.selectedActivity!.id,
                  startTime: Text(
                    format.format(events[index].startTime),
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  endTime: Text(
                    format.format(events[index].endTime),
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ));
        },
      );
    });
  }

  Widget _buildMission(ActivityListViewModel activityListViewModel,
      List<MissionEntity> missions) {
    return ListView.builder(
      itemCount: missions.length,
      itemBuilder: (context, index) {
        var belongWorkspace = missions[index].belongWorkspace.toEntity();
        var displayColor =
            AppColor.getWorkspaceColorByIndex(belongWorkspace.themeColor);
        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: InkWell(
              onTap: () {
                activityListViewModel.selectActivity(missions[index]);
              },
              child: ActivityCard.mission(
                color: displayColor,
                belongingGroup: belongWorkspace.name,
                activityTitle: missions[index].title,
                status: missions[index].state.stateName,
                statusColor: missions[index].state.stage.color,
                isSelected: missions[index].id ==
                    activityListViewModel.selectedActivity!.id,
              ),
            ));
      },
    );
  }

  Widget _createButton(BuildContext context, ActivityType type) {
    return Visibility(
      visible: isWorkspace,
      child: IconButton(
          onPressed: () {
            ActivityListViewModel vm =
                Provider.of<ActivityListViewModel>(context, listen: false);
            vm.setCreateMode(type == ActivityType.event);
          },
          icon: const Icon(
            Icons.add_outlined,
          )),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final Color color;
  final String belongingGroup;
  final String activityTitle;
  final Widget? status;
  final bool isSelected;
  // for event status might display start time and end time
  // for mission status might display progress status

  const ActivityCard({
    super.key,
    this.color = Colors.white,
    required this.belongingGroup,
    required this.activityTitle,
    this.isSelected = false,
    this.status,
  });

  factory ActivityCard.mission({
    final color = Colors.white,
    required belongingGroup,
    required activityTitle,
    required String status,
    required Color statusColor,
    bool isSelected = false,
  }) =>
      ActivityCard(
        color: color,
        belongingGroup: belongingGroup,
        activityTitle: activityTitle,
        isSelected: isSelected,
        status: StatusChip(
          statusLabel: status,
          statusColor: statusColor,
        ),
      );

  factory ActivityCard.event({
    final color = Colors.white,
    required belongingGroup,
    required activityTitle,
    required Widget startTime,
    required Widget endTime,
    bool isSelected = false,
  }) =>
      ActivityCard(
        color: color,
        belongingGroup: belongingGroup,
        activityTitle: activityTitle,
        isSelected: isSelected,
        status: Column(
          children: [
            startTime,
            const SizedBox(
              width: 5,
            ),
            endTime
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => _buildBody(context);

  TextStyle _getTitleStyle(BuildContext context) => Theme.of(context)
      .textTheme
      .labelLarge!
      .copyWith(fontWeight: FontWeight.bold);

  TextStyle _getGroupTextStyle(BuildContext context) => Theme.of(context)
      .textTheme
      .labelMedium!
      .copyWith(fontWeight: FontWeight.bold, color: color);

  Widget _buildBody(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: isSelected ? color : Colors.transparent,
      ),
      child: ColorCardWidget(
        color: color,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("@ $belongingGroup", style: _getGroupTextStyle(context)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      activityTitle,
                      style: _getTitleStyle(context),
                    ),
                    // status ?? const SizedBox.shrink()
                  ],
                ),
                status ?? const SizedBox.shrink()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
