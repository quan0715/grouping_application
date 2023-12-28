// ignore_for_file: unnecessary_this
// import 'data_model.dart';
import 'mission_state_stage.dart';

/// ## a data model for misison state
/// * to upload/download, use `DataController`
class MissionState {
  int id;
  MissionStage stage;
  String stateName;
  int belongWorkspaceID;

  ///the default unknown state
  static final MissionState defaultUnknownState = MissionState._default(
      id: -1,
      stage: MissionStage.progress,
      stateName: 'unknown',
      belongWorkspaceID: -1);

  ///the default state of progress stage, called progress
  static final MissionState defaultProgressState = MissionState._default(
      id: -1,
      stage: MissionStage.progress,
      stateName: 'in progress',
      belongWorkspaceID: -1);

  ///the default state of pending stage, called pending
  static final MissionState defaultPendingState = MissionState._default(
      id: -1,
      stage: MissionStage.pending,
      stateName: 'pending',
      belongWorkspaceID: -1);

  static final MissionState defaultReplyState = MissionState._default(
      id: -1,
      stage: MissionStage.reply,
      stateName: 'reply',
      belongWorkspaceID: -1);

  ///the default state of close stage, called finish
  static final MissionState defaultFinishState = MissionState._default(
      id: -1,
      stage: MissionStage.close,
      stateName: 'finish',
      belongWorkspaceID: -1);

  ///the default state of progress stage, called time out
  static final MissionState defaultTimeOutState = MissionState._default(
      id: -1,
      stage: MissionStage.pending,
      stateName: 'time out',
      belongWorkspaceID: -1);

  MissionState._default(
      {required this.id,
      required this.stage,
      required this.stateName,
      required this.belongWorkspaceID});

  /// ## a data model for misison state
  /// * to upload/download, use `DataController`
  MissionState(
      {int? id, MissionStage? stage, String? stateName, int? belongWorkspaceID})
      : this.id = id ?? defaultProgressState.id,
        this.stage = stage ?? defaultProgressState.stage,
        this.stateName = stateName ?? defaultProgressState.stateName,
        this.belongWorkspaceID =
            belongWorkspaceID ?? defaultProgressState.belongWorkspaceID;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': this.id,
        'stage': this.stage.label,
        'name': this.stateName,
        'belong_workspace': this.belongWorkspaceID,
      };

  factory MissionState.fromJson({required Map<String, dynamic> data}) =>
      MissionState(
          id: data['id'],
          stage: MissionStage.fromLabel(data['stage']),
          stateName: data['name'],
          belongWorkspaceID: data['belong_workspace']);
}
