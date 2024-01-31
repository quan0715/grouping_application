import 'package:grouping_project/core/data/models/simple_activity.dart';
import 'package:grouping_project/core/data/models/simple_workspace.dart';

class SimpleEvent extends SimpleActivity {
  DateTime startTime;
  DateTime endTime;

  SimpleEvent(
      {required super.id,
      required super.title,
      required super.belongWorkspace,
      required this.startTime,
      required this.endTime});

  factory SimpleEvent.fromJson(
          {required Map<String, dynamic> data}) =>
      SimpleEvent(
          id: data["id"],
          title: data["title"] as String,
          belongWorkspace:
              SimpleWorkspace.fromJson(data: data["belong_workspace"]),
          startTime: DateTime.parse(data["event"]["start_time"]),
          endTime: DateTime.parse(data["event"]["end_time"]));

  @override
  String toString() => "title: $title,\nbelong workspace: $belongWorkspace,\nstart time: $startTime,\nend time: $endTime";
}
