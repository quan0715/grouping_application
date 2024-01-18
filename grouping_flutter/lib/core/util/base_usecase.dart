import 'package:dartz/dartz.dart';
import 'package:grouping_project/core/errors/failure.dart';

///
/// [BaseUseCase] 是一個抽象 class
/// 理論上所有的 model 都需要實現這個 class 的 [call]
/// 在 implements 時，給予的為回傳的 [Return] type 以及使用參數的 [Param] type
///
abstract class BaseUseCase<Return, Param> {
  Future<Either<Failure, Return>> call(Param param);
}