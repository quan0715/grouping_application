import 'package:dartz/dartz.dart';
import 'package:grouping_project/core/errors/failure.dart';
import 'package:grouping_project/space/domain/entities/editable_card_entity.dart';

abstract class ActivityRepository {
  // Future<Either<Failure, EditableCardEntity>> getActivity(int activityID);
  // Future<Either<Failure, EditableCardEntity>> createActivity(EditableCardEntity editableCard);
  // Future<Either<Failure, EditableCardEntity>> updateActivity(EditableCardEntity editableCard);
  Future<Either<Failure, EditableCardEntity>> getActivity(int activityID);
  Future<Either<Failure, EditableCardEntity>> createActivity(EditableCardEntity editableCard);
  Future<Either<Failure, EditableCardEntity>> updateActivity(EditableCardEntity editableCard);
  // Future<Either<Failure, EditableCardEntity>> getActivity(int activityID);
  // Future<Either<Failure, EditableCardEntity>> createActivity(EditableCardEntity editableCard);
  // Future<Either<Failure, EditableCardEntity>> updateActivity(EditableCardEntity editableCard);
  Future<Either<Failure, void>> deleteActivity(int activityID);
}