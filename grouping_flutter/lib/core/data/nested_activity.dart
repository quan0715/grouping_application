import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:grouping_project/core/data/models/member_model.dart';
import 'package:grouping_project/core/data/models/nest_workspace.dart';
import 'package:grouping_project/core/errors/failure.dart';
import 'package:grouping_project/space/data/repositories/activity_repository_impl.dart';
import 'package:grouping_project/space/domain/entities/activity_entity.dart';
import 'package:grouping_project/space/domain/entities/event_entity.dart';
import 'package:grouping_project/space/domain/entities/mission_entity.dart';
import 'package:grouping_project/space/domain/usecases/activity_usecases/activity_usecase_lib.dart';

abstract class NestedActivity {
  Future toEntity({ActivityRepositoryImpl? repositoryImpl});
}

class NestedEvent extends NestedActivity {
  late ActivityRepositoryImpl repo;

  final int id;
  final String title;
  final String startTime;
  final String endTime;
  final NestWorkspace belongWorkspace;

  NestedEvent(
      {required this.id,
      required this.title,
      required this.startTime,
      required this.endTime,
      required this.belongWorkspace});

  factory NestedEvent.fromJson({required Map<String, dynamic> data}) {
    return NestedEvent(
        id: data["id"],
        title: data["title"],
        startTime: data["event"]["start_time"],
        endTime: data["event"]["end_time"],
        belongWorkspace:
            NestWorkspace.fromJson(data: data["belong_workspace"]));
  }
  // TODO: this is all false datas for demo

  @override
  Future<EventEntity?> toEntity(
      {ActivityRepositoryImpl? repositoryImpl}) async {
    try {
      Either<Failure, EventEntity> failureOrEvent =
          await GetEventUseCase(activityRepository: repo).call(id);
      failureOrEvent.fold((failure) {
        debugPrint(failure.errorMessage);
        throw Exception(failure.errorMessage);
      }, (eventEntity) {
        return eventEntity;
      });
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e.toString());
    }
  }
}

class NestedMission extends NestedActivity {
  late ActivityRepositoryImpl repo;

  final int id;
  final String title;
  final String deadline;
  final NestWorkspace belongWorkspace;

  NestedMission(
      {required this.id,
      required this.title,
      required this.deadline,
      required this.belongWorkspace});

  factory NestedMission.fromJson({required Map<String, dynamic> data}) =>
      NestedMission(
          id: data["id"],
          title: data["title"],
          deadline: data["mission"]["deadline"],
          belongWorkspace:
              NestWorkspace.fromJson(data: data["belong_workspace"]));

  @override
  Future<MissionEntity?> toEntity(
      {ActivityRepositoryImpl? repositoryImpl}) async {
    try {
      Either<Failure, MissionEntity> failureOrMission =
          await GetMissionUseCase(activityRepository: repo).call(id);
      failureOrMission.fold((failure) {
        debugPrint(failure.errorMessage);
        throw Exception(failure.errorMessage);
      }, (eventEntity) {
        return eventEntity;
      });
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e.toString());
    }
  }
}
