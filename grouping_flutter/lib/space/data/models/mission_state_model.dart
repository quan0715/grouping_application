// ignore_for_file: unnecessary_this
// import 'data_model.dart';
import 'mission_state_stage.dart';

/// ## a data model for misison state
/// * to upload/download, use `DataController`
class MissionStateModel{
  int id;
  MissionStage stage;
  String stateName;

  ///the default unknown state
  static final MissionStateModel defaultUnknownState =
      MissionStateModel._default(
          id: -1, stage: MissionStage.progress, stateName: 'unknown');

  ///the default state of progress stage, called progress
  static final MissionStateModel defaultProgressState =
      MissionStateModel._default(
          id: -1,
          stage: MissionStage.progress,
          stateName: '進行中');

  ///the default state of pending stage, called pending
  static final MissionStateModel defaultPendingState =
      MissionStateModel._default(
          id: -1,
          stage: MissionStage.pending,
          stateName: '審查中');

  ///the default state of close stage, called finish
  static final MissionStateModel defaultFinishState =
      MissionStateModel._default(
          id: -1,
          stage: MissionStage.close,
          stateName: '已完成');

  ///the default state of progress stage, called time out
  static final MissionStateModel defaultTimeOutState =
      MissionStateModel._default(
          id: -1,
          stage: MissionStage.pending,
          stateName: '已逾期');

  MissionStateModel._default(
      {required this.id, required this.stage, required this.stateName});

  /// ## a data model for misison state
  /// * to upload/download, use `DataController`
  MissionStateModel({int? id, MissionStage? stage, String? stateName})
      : this.id = id ?? defaultProgressState.id,
        this.stage = stage ?? defaultProgressState.stage,
        this.stateName = stateName ?? defaultProgressState.stateName;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': this.id,
    'stage': this.stage.label,
    'state_name': this.stateName,
  };

  factory MissionStateModel.fromJson({required Map<String, dynamic> data}) => MissionStateModel(
    id: data['id'],
    stage: MissionStage.fromLabel(data['stage']),
    stateName: data['stateName'],
  );
}