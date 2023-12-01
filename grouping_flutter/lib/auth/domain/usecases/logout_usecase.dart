import 'package:grouping_project/auth/domain/repositories/auth_login_repositories.dart';

class LogoutUseCase {
  final AuthRepository _userRepository;
  LogoutUseCase(this._userRepository);

  Future<void> call() async {
    return _userRepository.logOut();
  }
}
