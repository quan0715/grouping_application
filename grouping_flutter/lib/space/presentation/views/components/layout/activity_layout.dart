import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
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
            Text("$title ($len)",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: color, fontWeight: FontWeight.bold)),
            const Spacer(),
            _createButton(),
          ],
        ),
        type == ActivityType.event
            ? Expanded(flex: 6, child: _displayEventBody(activityListViewModel))
            : Expanded(
                flex: 7,
                child: _displayMissionBody(context, activityListViewModel))
        //     ? Expanded(
        //         flex: 1,
        //         child: _buildMissionNavigator(context, activityListViewModel))
        //     : const SizedBox(),
        // Expanded(
        //     flex: 6,
        //     child: Padding(
        //       padding: EdgeInsets.all(5.0),
        //       child: type == ActivityType.event
        //           ? _displayEvent(activityListViewModel)
        //           : _displayMission(activityListViewModel),
        //     ))
      ],
    );
  }

  Widget _displayMissionBody(
      BuildContext context, ActivityListViewModel activityListViewModel) {
   
    List<List<MissionEntity>> missionsType = [
      activityListViewModel.missions!,
      activityListViewModel.pengingMissions,
      activityListViewModel.progressingMissions,
      activityListViewModel.progressingMissions,
      activityListViewModel.finishMissions
    ];

    // debugPrint(missionsType.toString());


    return LayoutBuilder(builder: (context, constraints) {
      return DefaultTabController(
        initialIndex: 0,
        length: 5,
        child: Column(children: [
          TabBar(
            tabs: [
              Tab(
                child: Text("ALL (${missionsType[0].length})",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
              ),
              Tab(
                child: Text("未開始 (${missionsType[1].length})",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
              ),
              Tab(
                child: Text("進行中 (${missionsType[2].length})",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
              ),
              Tab(
                child: Text("待回覆 (${missionsType[3].length})",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
              ),
              Tab(
                child: Text("已完成 (${missionsType[4].length})",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
              )
            ],
          ),
          Expanded(
              child: TabBarView(children: [
            _buildMission(activityListViewModel, missionsType[0]),
            _buildMission(activityListViewModel, missionsType[1]),
            _buildMission(activityListViewModel, missionsType[2]),
            _buildMission(activityListViewModel, missionsType[3]),
            _buildMission(activityListViewModel, missionsType[4]),
          ])),
        ]),
      );
      // return ListView.builder(
      //     itemCount: 5,
      //     scrollDirection: Axis.horizontal,
      //     itemBuilder: (context, index) => InkWell(
      //           onTap: () {
      //             activityListViewModel.setMissionTypePage(index);
      //           },
      //           child: _typeNavigatorTitle(
      //               typeTitle: typeTitle[index]["title"],
      //               missions: typeTitle[index]["missions"],
      //               isSeleted:
      //                   index == activityListViewModel.getMissionTypePage(),
      //               width: width),
      //         ));
    });
  }

  Widget _displayEventBody(ActivityListViewModel activityListViewModel) {
    List<EventEntity> events = activityListViewModel.events!;

    return LayoutBuilder(builder: (context, constraints) {
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
                child: SizedBox(
                  height: 50, // TODO: dynamic give height
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("@ ${belongWorkspace.name}",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(
                                      color: displayColor,
                                      fontWeight: FontWeight.bold)),
                          Text(
                            events[index].title,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Spacer(),
                          Text(format.format(events[index].startTime),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                          Text(format.format(events[index].endTime),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black45)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildMission(ActivityListViewModel activityListViewModel,
      List<MissionEntity> missions) {
    // List<List<MissionEntity>> missionsType = [
    //   activityListViewModel.missions!,
    //   activityListViewModel.pengingMissions,
    //   activityListViewModel.progressingMissions,
    //   activityListViewModel.progressingMissions,
    //   activityListViewModel.finishMissions
    // ];

    // int currentMissionTypePage = activityListViewModel.getMissionTypePage();

    return ListView.builder(
      itemCount: missions.length,
      itemBuilder: (context, index) {
        // List<MissionEntity> missions = missionsType[currentMissionTypePage];
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
                debugPrint("unimplemnted yet, show detailed of mission");
                debugPrint(missions[index].deadline.toString());
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
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(
                                  color: displayColor,
                                  fontWeight: FontWeight.bold),
                        ),
                        Text(
                          missions[index].title,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(fontWeight: FontWeight.bold),
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
