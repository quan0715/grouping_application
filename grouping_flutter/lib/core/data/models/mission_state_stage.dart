// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grouping_project/core/theme/color.dart';

/// Stage of mission 
/// print(MissionStage.progress.label) => progress
enum MissionStage {
  
  todo(label: 'todo'),
  progress(label: 'progress'),
  pending(label: 'pending'),
  close(label: 'close');
  
  final String label;
  const MissionStage({required this.label});

  factory MissionStage.fromLabel(String label){
    switch(label){
      case 'progress':
        return MissionStage.progress;
      case 'pending':
        return MissionStage.pending;
      case 'close':
        return MissionStage.close;
      case 'todo':
        return MissionStage.todo;
      default:
        return MissionStage.progress;
    }
  }

  Color get color {
    switch(this){
      case MissionStage.todo:
        return AppColor.inProgressColor;      // TODO: give todo color
      case MissionStage.progress:
        return AppColor.inProgressColor;
      case MissionStage.pending:
        return AppColor.pendingColor;
      case MissionStage.close:
        return AppColor.completeColor;
      default:
        return AppColor.incorrect;
    }
  }
}
