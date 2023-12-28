import 'package:dartz/dartz.dart';
import 'package:grouping_project/core/errors/failure.dart';
import 'package:grouping_project/space/domain/entities/event_entity.dart';
import 'package:grouping_project/space/domain/repositories/activity_repository.dart';

class UpdateEventUseCase{
  final ActivityRepository _activityRepository;
  
  UpdateEventUseCase(
      {required ActivityRepository activityRepository,})
      : _activityRepository = activityRepository;

  Future<Either<Failure, EventEntity>> call(EventEntity entity) async {
    return await _activityRepository.updateEvent(entity);
    // final failureOrEvent = await _activityRepository.updateEvent(entity);

    /*
    return failureOrEvent.fold((failure) {
      return Left(failure);
    }, (event) async {
      // Workspace
      final failureOrWorkspace =
          await _workspaceRepository.getWorkspace(event.belongWorkspaceID);

      failureOrWorkspace.fold((failure) {
        return Left(failure);
      }, (workspace) => event.belongWorkspace = workspace);

      // Creator
      final failureOrCreator = await _userRepository.getUser(event.creatorID);

      failureOrCreator.fold((failure) {
        return Left(failure);
      }, (creator) => event.creator = creator);

      // Contributors
      event.contributorIDs.map((contributorID) async {
        final failureOrContributor =
            await _userRepository.getUser(contributorID);

        failureOrContributor.fold((failure) {
          return Left(failure);
        }, (contributor) {
          event.contributors.add(contributor);
        });
      });

      // Child Missions
      event.childMissionIDs.map((childMissionID) async {
        final failureOrChild =
            await _activityRepository.getMission(childMissionID);

        failureOrChild.fold((failure) {
          return Left(failure);
        }, (childMission) {
          event.childMissions.add(childMission);
        });
      });

      // Parent Missions
      event.parentMissions = [];

      return Right(event);
    });
    */
  }
}