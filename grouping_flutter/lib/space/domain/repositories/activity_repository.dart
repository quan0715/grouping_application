import 'package:dartz/dartz.dart';
import 'package:grouping_project/core/errors/failure.dart';
import 'package:grouping_project/space/domain/entities/event_entity.dart';
import 'package:grouping_project/space/domain/entities/mission_entity.dart';

abstract class ActivityRepository {
  // Future<Either<Failure, EditableCardEntity>> getActivity(int activityID);
  // Future<Either<Failure, EditableCardEntity>> createActivity(EditableCardEntity editableCard);
  // Future<Either<Failure, EditableCardEntity>> updateActivity(EditableCardEntity editableCard);
  Future<Either<Failure, EventEntity>> getEvent(int eventID);
  Future<Either<Failure, EventEntity>> createEvent(EventEntity entity);
  Future<Either<Failure, EventEntity>> updateEvent(EventEntity entity);
  Future<Either<Failure, MissionEntity>> getMission(int missionID);
  Future<Either<Failure, MissionEntity>> createMission(MissionEntity entity);
  Future<Either<Failure, MissionEntity>> updateMission(MissionEntity entity);
  Future<Either<Failure, void>> deleteActivity(int activityID);
}