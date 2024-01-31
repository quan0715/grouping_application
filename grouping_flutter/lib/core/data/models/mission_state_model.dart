import 'package:grouping_project/core/data/models/simple_workspace.dart';

import 'mission_state_stage.dart';

/// ## [MissionState] 為 mission 當前的 state 的 data struct
/// [MissionState] 擁有自己的 [id], [stateName] 以及此 state 當前的 [MissionStage] \
/// 另外此 [MissionState] 也會有自己對應的 [belongWorkspace]
class MissionState {
  int id;
  MissionStage stage;
  String stateName;
  SimpleWorkspace? belongWorkspace;

  MissionState({required this.id, required this.stage, required this.stateName, this.belongWorkspace});

  Map<String, dynamic> toJson() => <String, dynamic>{
        // 'id': this.id,
        'stage': stage.label,
        'name': stateName,
        'belong_workspace': belongWorkspace?.id,
      };

  factory MissionState.fromJson({required Map<String, dynamic> data}) =>
      MissionState(
          id: data['id'],
          stage: MissionStage.fromLabel(data['stage']),
          stateName: data['name'],
          belongWorkspace: data['belong_workspace'] != null ? SimpleWorkspace.fromJson(data: data['belong_workspace']) : null);

  @override
  String toString() {
    return {"id": id, "stage": stage.label, "state name": stateName}.toString();
  }
}
