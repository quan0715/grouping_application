import 'package:dartz/dartz.dart';
import 'package:grouping_project/core/errors/failure.dart';
import 'package:grouping_project/core/util/base_usecase.dart';
import 'package:grouping_project/space/domain/repositories/activity_repository.dart';

class DeleteActivityUseCase extends BaseUseCase<void, int> {
  final ActivityRepository _activityRepository ;
  
  DeleteActivityUseCase(this._activityRepository);

  /// 給予 [activityID] 來去刪除此 [Activity] 的資料
  @override
  Future<Either<Failure, void>> call(int activityID) async {
    return await _activityRepository.deleteActivity(activityID);
  } 
}