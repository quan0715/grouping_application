import 'package:dartz/dartz.dart';
import 'package:grouping_project/core/errors/failure.dart';
import 'package:grouping_project/space/domain/entities/user_entity.dart';
import 'package:grouping_project/space/domain/entities/workspace_entity.dart';
import 'package:grouping_project/space/domain/repositories/workspace_repository.dart';
import 'package:image_picker/image_picker.dart';

class CreateCurrentWorkspaceUseCase{
  final WorkspaceRepository _workspaceRepository ;
  
  CreateCurrentWorkspaceUseCase(this._workspaceRepository);

  Future<Either<Failure, WorkspaceEntity>> call({
    required UserEntity creator,
    required WorkspaceEntity entity, XFile? image}) async {
    return _workspaceRepository.createWorkspace(entity, image);
  } 
}