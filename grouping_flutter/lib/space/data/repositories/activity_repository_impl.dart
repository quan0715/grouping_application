
import 'package:dartz/dartz.dart';
import 'package:grouping_project/core/errors/failure.dart';
import 'package:grouping_project/core/exceptions/exceptions.dart';
import 'package:grouping_project/space/data/datasources/local_data_source/activity_local_data_source.dart';
import 'package:grouping_project/space/data/datasources/remote_data_source/activity_remote_data_source.dart';
import 'package:grouping_project/space/data/models/editable_card_model.dart';
import 'package:grouping_project/space/data/models/workspace_model_lib.dart';
import 'package:grouping_project/space/domain/entities/editable_card_entity.dart';
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
  Future<Either<Failure, EditableCardEntity>> getActivity(int activityID) async {
    try {
      final EditableCardModel activity = await remoteDataSource.getActivityData(activityID: activityID);
      return Right(activity.toEntity());
    } on ServerException catch(error){
      return Left(ServerFailure(errorMessage: error.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, EditableCardEntity>> createActivity(EditableCardEntity entity) async {
    try {
      bool isEvent = (entity is EventEntity);
      final EditableCardModel activity = await remoteDataSource.createActivityData(activity: isEvent ? EventModel.fromEntity(entity) : MissionModel.fromEntity(entity as MissiontEntity));
      return Right(activity.toEntity());
    } on ServerException catch(error){
      return Left(ServerFailure(errorMessage: error.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, EditableCardEntity>> updateActivity(EditableCardEntity entity) async {
    try {
      bool isEvent = (entity is EventEntity);
      final EditableCardModel activity = await remoteDataSource.updateActivityData(activity: isEvent ? EventModel.fromEntity(entity) : MissionModel.fromEntity(entity as MissiontEntity));
      return Right(activity.toEntity());
    } on ServerException catch(error){
      return Left(ServerFailure(errorMessage: error.exceptionMessage));
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