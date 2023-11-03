void main() {
  // group('account login check', () {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   AuthService authService = AuthService();
  //   FlutterSecureStorage storage = FlutterSecureStorage();
  //   test('signup', () async {
  //     authService
  //         .signUp(account: 'test', password: 'testtest')
  //         .whenComplete(() {
  //       storage
  //           .containsKey(key: 'auth-token')
  //           .then((value) => expect(value, true));
  //     }).onError((error, stackTrace) {
  //       error as AuthServiceException;
  //       expect(error.code == 'user_already_exist', true);
  //       log(error.toString());
  //     });
  //   });

  //   test('logout', () async {
  //     authService.logOut().whenComplete(() {
  //       storage
  //           .containsKey(key: 'auth-token')
  //           .then((value) => expect(value, false));
  //     });
  //   });

  //   test('wrong password', () async {
  //     authService
  //         .signIn(account: 'test', password: '878787')
  //         .onError((error, stackTrace) {
  //       error as AuthServiceException;
  //       expect(error.code == 'wrong_password', true);
  //     });
  //   });

  //   test('sign in', () async {
  //     authService
  //         .signIn(account: 'test', password: 'testtest')
  //         .whenComplete(() {
  //       storage
  //           .containsKey(key: 'auth-token')
  //           .then((value) => expect(value, true));
  //     });
  //   });
  // });
  // group('Google login test', () {
  //   AuthService authService = AuthService();
  //   authService.googleSignIn().then((value) => Placeholder());
  // });
}
