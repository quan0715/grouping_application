import 'package:grouping_project/core/data/models/mission_state_model.dart';
import 'package:grouping_project/core/data/models/simple_activity.dart';
import 'package:grouping_project/core/data/models/simple_workspace.dart';

class SimpleMission extends SimpleActivity {
  DateTime deadline;
  MissionState state;

  SimpleMission(
      {required super.id,
      required super.title,
      required super.belongWorkspace,
      required this.deadline,
      required this.state});

  factory SimpleMission.fromJson({required Map<String, dynamic> data}) =>
      SimpleMission(
          id: data["id"],
          title: data["title"],
          belongWorkspace:
              SimpleWorkspace.fromJson(data: data["belong_workspace"]),
          deadline: DateTime.parse(data["mission"]["deadline"]),
          state: MissionState.fromJson(data: data["misson"]["state"]));

  
  @override
  String toString() => "title: $title,\nbelong workspace: $belongWorkspace,\ndeadline: $deadline,\nstate: $state";
}
