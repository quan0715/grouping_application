// ignore_for_file: unnecessary_this
// import 'data_model.dart';
import 'mission_state_stage.dart';


class MissionState {
  int id;
  MissionStage stage;
  String stateName;
  int belongWorkspaceID;

  ///the default unknown state
  // static final MissionState defaultUnknownState = MissionState._default(
  //     id: -1,
  //     stage: MissionStage.progress,
  //     stateName: 'unknown',
  //     belongWorkspaceID: -1);

  // ///the default state of progress stage, called progress
  // static final MissionState defaultProgressState = MissionState._default(
  //     id: -1,
  //     stage: MissionStage.progress,
  //     stateName: '進行中',
  //     belongWorkspaceID: -1);

  // ///the default state of pending stage, called pending
  // static final MissionState defaultPendingState = MissionState._default(
  //     id: -1,
  //     stage: MissionStage.pending,
  //     stateName: '未開始',
  //     belongWorkspaceID: -1);

  // static final MissionState defaultReplyState = MissionState._default(
  //     id: -1,
  //     stage: MissionStage.reply,
  //     stateName: '待回覆',
  //     belongWorkspaceID: -1);

  // ///the default state of close stage, called finish
  // static final MissionState defaultFinishState = MissionState._default(
  //     id: -1,
  //     stage: MissionStage.close,
  //     stateName: '已完成',
  //     belongWorkspaceID: -1);

  // ///the default state of progress stage, called time out
  // static final MissionState defaultTimeOutState = MissionState._default(
  //     id: -1,
  //     stage: MissionStage.pending,
  //     stateName: '已逾期',
  //     belongWorkspaceID: -1);

  // MissionState._default(
  //     {required this.id,
  //     required this.stage,
  //     required this.stateName,
  //     required this.belongWorkspaceID});


  // MissionState(
  //     {int? id, MissionStage? stage, String? stateName, int? belongWorkspaceID})
  //     : this.id = id ?? defaultProgressState.id,
  //       this.stage = stage ?? defaultProgressState.stage,
  //       this.stateName = stateName ?? defaultProgressState.stateName,
  //       this.belongWorkspaceID =
  //           belongWorkspaceID ?? defaultProgressState.belongWorkspaceID;
  MissionState({required this.id, required this.stage, required this.stateName, required this.belongWorkspaceID});

  Map<String, dynamic> toJson() => <String, dynamic>{
        // 'id': this.id,
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
