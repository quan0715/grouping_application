
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:grouping_project/core/errors/failure.dart';
import 'package:grouping_project/core/exceptions/exceptions.dart';
import 'package:grouping_project/space/data/datasources/local_data_source/activity_local_data_source.dart';
import 'package:grouping_project/space/data/datasources/remote_data_source/activity_remote_data_source.dart';
import 'package:grouping_project/space/data/models/event_model.dart';
import 'package:grouping_project/space/data/models/mission_model.dart';
import 'package:grouping_project/space/domain/entities/event_entity.dart';
import 'package:grouping_project/space/domain/entities/mission_entity.dart';
import 'package:grouping_project/space/domain/repositories/activity_repository.dart';

/// ## 這個 ActivityRepositoryImpl 主要是負責處理 event, mission 的功能操作
/// 
/// 此 repository 可以 get, create, update, delete event 或 mission
///
class ActivityRepositoryImpl extends ActivityRepository {

  final ActivityRemoteDataSource remoteDataSource;
  final ActivityLocalDataSource localDataSource;

  ActivityRepositoryImpl({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, EventEntity>> getEvent(int eventID) async {
    try {
      final EventModel model = await remoteDataSource.getActivityData(activityID: eventID) as EventModel;
      
      final EventEntity event = model.toEntity();

      return Right(event);
    } on ServerException catch(error){
      return Left(ServerFailure(errorMessage: error.exceptionMessage));
    } on TypeError {
      return Left(ServerFailure(errorMessage: 'Given ID is not event ID'));
    }
  }

  @override
  Future<Either<Failure, MissionEntity>> getMission(int missionID) async {
    try {
      final MissionModel model = await remoteDataSource.getActivityData(activityID: missionID) as MissionModel;

      final MissionEntity mission = model.toEntity();

      return Right(mission);
    } on ServerException catch(error){
      return Left(ServerFailure(errorMessage: error.exceptionMessage));
    } on TypeError {
      return Left(ServerFailure(errorMessage: 'Given ID is not mission ID'));
    }
  }

  @override
  Future<Either<Failure, EventEntity>> createEvent(EventEntity entity) async {
    try {
      final EventModel model = await remoteDataSource.createActivityData(activity: entity.toModel()) as EventModel;

      final EventEntity event = model.toEntity();

      return Right(event);
    } on ServerException catch(error){
      return Left(ServerFailure(errorMessage: error.exceptionMessage));
    } on TypeError {
      return Left(ServerFailure(errorMessage: "Given entity is not event entity"));
    }
  }

  @override
  Future<Either<Failure, MissionEntity>> createMission(MissionEntity entity) async {
    try {
      final MissionModel model = await remoteDataSource.createActivityData(activity: entity.toModel()) as MissionModel;

      final MissionEntity mission = model.toEntity();

      return Right(mission);
    } on ServerException catch(error){
      return Left(ServerFailure(errorMessage: error.exceptionMessage));
    } on TypeError {
      return Left(ServerFailure(errorMessage: "Given entity is not mission entity"));
    }
  }

  @override
  Future<Either<Failure, EventEntity>> updateEvent(EventEntity entity) async {
    try {
      final EventModel model = await remoteDataSource.updateActivityData(activity: entity.toModel()) as EventModel;

      final EventEntity event = model.toEntity();

      return Right(event);
    } on ServerException catch(error){
      return Left(ServerFailure(errorMessage: error.exceptionMessage));
    } on TypeError {
      return Left(ServerFailure(errorMessage: "Given entity is not event entity"));
    }
  }

  @override
  Future<Either<Failure, MissionEntity>> updateMission(MissionEntity entity) async {
    try {
      debugPrint("before update: ${entity.deadline}");
      final MissionModel model = await remoteDataSource.updateActivityData(activity: entity.toModel()) as MissionModel;
      debugPrint("after update: ${model.deadline}");

      final MissionEntity mission = model.toEntity();

      return Right(mission);
    } on ServerException catch(error){
      return Left(ServerFailure(errorMessage: error.exceptionMessage));
    } on TypeError {
      return Left(ServerFailure(errorMessage: "Given entity is not mission entity"));
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteActivity(int activityID) async {
    try {
      await remoteDataSource.deleteActivityData(activityID: activityID);
      return const Right(null);
    } on ServerException catch(error) {
      return Left(ServerFailure(errorMessage: error.exceptionMessage));
    }
  }
}