class Config {
  static String frontEndUrlWeb = 'http://localhost:5000';
  static String frontEndUrlMobile = 'http://10.0.2.2:5000';
  static String baseUriWeb = 'http://localhost:8000';
  static String baseUriMobile = 'http://10.0.2.2:8000';

  static Uri googleAuthEndpoint =
      Uri.parse('https://accounts.google.com/o/oauth2/v2/auth');
  static Uri googleTokenEndpoint =
      Uri.parse('https://oauth2.googleapis.com/token');
  static Uri googleUserProfileEndpoint =
      Uri.parse('https://oauth2.googleapis.com/tokeninfo');

  static Uri gitHubAuthEndpoint =
      Uri.parse('https://github.com/login/oauth/authorize');
  static Uri gitHubTokenEndpoint =
      Uri.parse('https://github.com/login/oauth/access_token');
  static Uri gitHubUserProfileEndpoint =
      Uri.parse('https://api.github.com/user');

  static Uri lineAuthEndPoint =
      Uri.parse("https://access.line.me/oauth2/v2.1/authorize");
  static Uri lineTokenEndpoint =
      Uri.parse("https://api.line.me/oauth2/v2.1/token");
  static Uri lineUserProfileEndpoint =
      Uri.parse('https://api.line.me/v2/profile');
}
