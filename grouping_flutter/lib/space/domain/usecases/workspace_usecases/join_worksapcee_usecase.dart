import 'package:dartz/dartz.dart';
import 'package:grouping_project/core/data/models/member_model.dart';
import 'package:grouping_project/core/errors/failure.dart';
import 'package:grouping_project/space/domain/entities/user_entity.dart';
import 'package:grouping_project/space/domain/entities/workspace_entity.dart';
import 'package:grouping_project/space/domain/repositories/workspace_repository.dart';

class JoinWorkspaceUseCase {
  final WorkspaceRepository _workspaceRepository;
  

  JoinWorkspaceUseCase(this._workspaceRepository);

  Future<Either<Failure, WorkspaceEntity>> call(WorkspaceEntity workspaceId, UserEntity joinUser) async {
    workspaceId.members.add(
      Member(id: joinUser.id! , userName: joinUser.name)
    );
    return await _workspaceRepository.updateWorkspace(workspaceId);
  }
}