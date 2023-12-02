import 'package:grouping_project/auth/domain/repositories/auth_login_repositories.dart';

class LogOutUseCase {
  final AuthRepository _authRepository;

  LogOutUseCase(this._authRepository);

  Future<void> call() async {
    return await _authRepository.logOut();
  }
}