import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grouping_project/app/presentation/components/data_display/color_card_widget.dart';
import 'package:grouping_project/space/domain/entities/event_entity.dart';
import 'package:grouping_project/space/domain/entities/mission_entity.dart';
import 'package:grouping_project/space/domain/entities/workspace_entity.dart';
import 'package:grouping_project/space/presentation/view_models/activity_list_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

enum ActivityType {
  event,
  mission;
}

class ActivityLayOut extends StatelessWidget {
  // final List<ActivityEntity> activities;
  final String title;
  final bool isWorkspace;
  final ActivityType type;
  final Color color;

  const ActivityLayOut({
    super.key,
    // required this.activities,
    required this.title,
    required this.color,
    this.isWorkspace = true,
    this.type = ActivityType.event,
  });

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    ActivityListViewModel activityListViewModel =
        Provider.of<ActivityListViewModel>(context, listen: false);
    int len = type == ActivityType.event
        ? activityListViewModel.events!.length
        : activityListViewModel.missions!.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "$title ($len)",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold)
            ),
            const Spacer(),
            _createButton(),
          ],
        ),
        type == ActivityType.mission
            ? Expanded(
                flex: 1,
                child: _buildMissionNavigator(context, activityListViewModel))
            : const SizedBox(),
        // const Expanded(
        //     flex: 6,
        //     child: Padding(padding: EdgeInsets.all(5.0), child: Placeholder()))
        Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: type == ActivityType.event
                  ? _displayEvent(activityListViewModel)
                  : _displayMission(activityListViewModel),
            ))
      ],
    );
  }

  Widget _typeNavigatorTitle(
      {required String typeTitle,
      required List<MissionEntity> missions,
      required bool isSeleted,
      required double width,
      required BuildContext context}) {
    int length = missions.length;

    Color displayColor = isSeleted ? color : Colors.black45;

    return Container(
      width: width,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: displayColor, width: 2))),
      child: Center(
          child: Text(
        "$typeTitle ($length)",
        style: Theme.of(context).textTheme.labelSmall!.copyWith(
            color: displayColor,
            fontWeight: FontWeight.bold),
      )),
    );
  }

  Widget _buildMissionNavigator(
      BuildContext context, ActivityListViewModel activityListViewModel) {
    // TODO: use another way
    final List<Map<String, dynamic>> typeTitle = [
      {"title": "ALL", "missions": activityListViewModel.missions!},
      {"title": "未開始", "missions": activityListViewModel.pengingMissions},
      {"title": "進行中", "missions": activityListViewModel.progressingMissions},
      {"title": "待回覆", "missions": activityListViewModel.progressingMissions},
      {"title": "已完成", "missions": activityListViewModel.finishMissions}
    ];

    // final List<String> typeTitle = ["ALL", "未開始", "進行中", "待回覆", "已完成"];

    return LayoutBuilder(builder: (context, constraints) {
      double width = constraints.maxWidth * 0.2;
      return ListView.builder(
          itemCount: 5,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => InkWell(
                onTap: () {
                  activityListViewModel.setMissionTypePage(index);
                },
                child: _typeNavigatorTitle(
                    context: context,
                    typeTitle: typeTitle[index]["title"],
                    missions: typeTitle[index]["missions"],
                    isSeleted:
                        index == activityListViewModel.getMissionTypePage(),
                    width: width),
              ));
    });
  }

  Widget _displayEvent(ActivityListViewModel activityListViewModel) {
    List<EventEntity> events = activityListViewModel.events!;

    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            WorkspaceEntity belongWorkspace =
                events[index].belongWorkspace.toEntity();
            Color displayColor =
                isWorkspace ? color : Color(belongWorkspace.themeColor);
            DateFormat format = DateFormat("hh:mm");
        
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: ColorCardWidget(
                color: displayColor,
                child: InkWell(
                  onTap: () {
                    debugPrint("unimplemnted yet, show detailed of event");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "@${belongWorkspace.name}",
                            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                color: displayColor, fontWeight: FontWeight.bold),
                          ),
                          const Gap(3),
                          Text(
                            events[index].title,
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            format.format(events[index].startTime),
                            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                          const Gap(3),
                          Text(
                            format.format(events[index].endTime),
                            style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold, color: Colors.black45),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
    );
  }

  Widget _displayMission(ActivityListViewModel activityListViewModel) {
    List<List<MissionEntity>> missionsType = [
      activityListViewModel.missions!,
      activityListViewModel.pengingMissions,
      activityListViewModel.progressingMissions,
      activityListViewModel.progressingMissions,
      activityListViewModel.finishMissions
    ];

    int currentMissionTypePage = activityListViewModel.getMissionTypePage();

    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView.builder(
          itemCount: missionsType[currentMissionTypePage].length,
          itemBuilder: (context, index) {
            List<MissionEntity> missions = missionsType[currentMissionTypePage];
            WorkspaceEntity belongWorkspace =
                missions[index].belongWorkspace.toEntity();
            Color displayColor =
                isWorkspace ? color : Color(belongWorkspace.themeColor);
        
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: ColorCardWidget(
                color: displayColor,
                child: InkWell(
                  onTap: () {
                    debugPrint("unimplemnted yet, show detailed of event");
                  },
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "@ ${belongWorkspace.name}",
                              style: TextStyle(
                                  color: displayColor, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              missions[index].title,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Text("狀態")
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }
    );
  }

  Widget _createButton() {
    return isWorkspace
        ? IconButton(
            onPressed: () {
              debugPrint("unimplemented yet, create activity");
            },
            icon: const Icon(Icons.add_outlined))
        : const SizedBox();
  }
}
