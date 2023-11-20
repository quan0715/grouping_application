enum AuthProvider {
  account(string: 'account'),
  google(string: 'google'),
  github(string: 'github'),
  line(string: 'line');

  final String string;
  const AuthProvider({required this.string});
}
