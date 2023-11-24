class Config {
  static String frontEndUrlWeb = 'http://localhost:5000';
  static String frontEndUrlMobile = 'http://10.0.2.2:5000';
  static String baseUriWeb = 'http://localhost:8000';
  static String baseUriMobile = 'http://localhost:8000';

  // /// **This is used for testing ngrok setup**
  // static String frontEndUrlWeb = 'https://63c0-114-25-167-2.ngrok-free.app';

  // /// **This is used for testing ngrok setup**
  // static String frontEndUrlMobile = 'https://63c0-114-25-167-2.ngrok-free.app';

  // /// **This is used for testing ngrok setup**
  // static String baseUriWeb = 'https://6fc6-114-25-167-2.ngrok-free.app';

  // /// **This is used for testing ngrok setup**
  // static String baseUriMobile = 'https://6fc6-114-25-167-2.ngrok-free.app';

  static Uri googleAuthEndpoint =
      Uri.parse('https://accounts.google.com/o/oauth2/v2/auth');
  static Uri googleTokenEndpoint =
      Uri.parse('https://oauth2.googleapis.com/token');
  static Uri googleUserProfileEndpoint =
      Uri.parse('https://oauth2.googleapis.com/tokeninfo');
  static List<String> googleScopes = ['profile', 'email'];

  static Uri gitHubAuthEndpoint =
      Uri.parse('https://github.com/login/oauth/authorize');
  static Uri gitHubTokenEndpoint =
      Uri.parse('https://github.com/login/oauth/access_token');
  static Uri gitHubUserProfileEndpoint =
      Uri.parse('https://api.github.com/user');
  static List<String> gitHubScopes = ['read:user', 'user:email'];

  static Uri lineAuthEndPoint =
      Uri.parse("https://access.line.me/oauth2/v2.1/authorize");
  static Uri lineTokenEndpoint =
      Uri.parse("https://api.line.me/oauth2/v2.1/token");
  static Uri lineUserProfileEndpoint =
      Uri.parse('https://api.line.me/v2/profile');
  static List<String> lineScopes = [
    'profile',
    'openid',
  ];
}
