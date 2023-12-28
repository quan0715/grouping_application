import 'package:dartz/dartz.dart';
import 'package:grouping_project/core/errors/failure.dart';
import 'package:grouping_project/space/domain/entities/mission_entity.dart';
import 'package:grouping_project/space/domain/repositories/activity_repository.dart';

class UpdateMissionUseCase{
  final ActivityRepository _activityRepository;
  
  UpdateMissionUseCase(
      {required ActivityRepository activityRepository,})
      : _activityRepository = activityRepository;

  Future<Either<Failure, MissionEntity>> call(MissionEntity entity) async {
    return await _activityRepository.updateMission(entity);
    // final failureOrMission = await _activityRepository.updateMission(entity);

    /*
    return failureOrMission.fold((failure) {
      return Left(failure);
    }, (mission) async {
      // Workspace
      final failureOrWorkspace =
          await _workspaceRepository.getWorkspace(mission.belongWorkspaceID);

      failureOrWorkspace.fold((failure) {
        return Left(failure);
      }, (workspace) => mission.belongWorkspace = workspace);

      // Creator
      final failureOrCreator = await _userRepository.getUser(mission.creatorID);

      failureOrCreator.fold((failure) {
        return Left(failure);
      }, (creator) => mission.creator = creator);

      // Contributors
      mission.contributorIDs.map((contributorID) async {
        final failureOrContributor =
            await _userRepository.getUser(contributorID);

        failureOrContributor.fold((failure) {
          return Left(failure);
        }, (contributor) {
          mission.contributors.add(contributor);
        });
      });

      // Child Missions
      mission.childMissionIDs.map((childMissionID) async {
        final failureOrChild =
            await _activityRepository.getMission(childMissionID);

        failureOrChild.fold((failure) {
          return Left(failure);
        }, (childMission) {
          mission.childMissions.add(childMission);
        });
      });

      // Parent Missions
      mission.parentMissionIDs.map((parentMissionID) async {
        final failureOrParent =
            await _activityRepository.getMission(parentMissionID);

        failureOrParent.fold((failure) {
          return Left(failure);
        }, (parentMission) {
          mission.parentMissions.add(parentMission);
        });
      });

      return Right(mission);
    });
    */
  } 
}