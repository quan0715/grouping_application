import 'package:flutter/material.dart';
import 'package:grouping_project/space/data/models/workspace_model_lib.dart';
import 'package:grouping_project/space/domain/entities/activity_entity.dart';
import 'package:grouping_project/space/domain/entities/mission_entity.dart';
import 'package:grouping_project/space/presentation/view_models/activity_list_view_model.dart';
import 'package:provider/provider.dart';

enum ActivityType {
  event,
  mission;
}

class ActivityLayOut extends StatelessWidget {
  final List<ActivityEntity> activities;
  final String title;
  final bool isWorkspace;
  final ActivityType type;

  const ActivityLayOut({
    super.key,
    required this.activities,
    required this.title,
    this.isWorkspace = true,
    this.type = ActivityType.event,
  });

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("$title (${activities.length})"),
            const Spacer(),
            _createButton(),
          ],
        ),
        type == ActivityType.mission
            ? Expanded(flex: 1, child: _buildMissionNavigator(context))
            : const SizedBox(),
        const Expanded(flex: 6, child: Padding(padding: EdgeInsets.all(5.0), child: Placeholder()))
      ],
    );
  }

  Widget _typeNavigatorTitle(
      {required String typeTitle,
      MissionStage? stage,
      required bool isSeleted}) {
    int length = stage != null
        ? (activities as List<MissionEntity>)
            .where((mission) => mission.state.stage == stage)
            .length
        : activities.length;

    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: isSeleted ? Colors.amber : Colors.black45))),
      child: Center(child: Text("$typeTitle ($length)")),
    );
  }

  Widget _buildMissionNavigator(BuildContext context) {
    ActivityListViewModel activityListViewModel =
        Provider.of<ActivityListViewModel>(context, listen: false);

    final List<Map<String, dynamic>> typeTitle = [
      {"title": "ALL", "stage": null},
      {"title": "未開始", "stage": MissionStage.pending},
      {"title": "進行中", "stage": MissionStage.progress},
      {"title": "待回覆", "stage": MissionStage.progress},
      {"title": "已完成", "stage": MissionStage.close}
    ];

    // NavigationBar bar = NavigationBar(
    //   selectedIndex: selectPage,
    //   destinations: [
    //     _typeNavigatorTitle(typeTitle: "ALL", isSeleted: selectPage == 0),
    //     _typeNavigatorTitle(typeTitle: "未開始", stage: MissionStage.pending, isSeleted: selectPage == 1),
    //     _typeNavigatorTitle(typeTitle: "進行中", stage: MissionStage.progress, isSeleted: selectPage == 2),
    //     _typeNavigatorTitle(
    //         typeTitle: "待回覆",
    //         stage: MissionStage.close,
    //         isSeleted: selectPage == 3), // TODO: need new stage
    //     _typeNavigatorTitle(typeTitle: "已完成", stage: MissionStage.close, isSeleted: selectPage == 4),
    //   ]);
    return ListView.builder(
        itemCount: 5,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => InkWell(
              onTap: () {
                activityListViewModel.setMissionTypePage(index);
              },
              child: _typeNavigatorTitle(
                  typeTitle: typeTitle[index]["title"],
                  isSeleted:
                      index == activityListViewModel.getMissionTypePage(),
                  stage: typeTitle[index]["stage"]),
            ));
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
