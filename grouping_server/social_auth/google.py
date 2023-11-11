from google.auth.transport import requests as googleRequest
from google.oauth2 import id_token

from .helper_methods import SocialLogin, TokenExchangeError
from .register import login_user

class GoogleTokenExchange:
    def requestProfile(idToken):
        print('Google User!!!!!')
        user = id_token.verify_oauth2_token(
                    idToken, googleRequest.Request(),clock_skew_in_seconds = 2)
        # print(user)

        if 'sub' in user and 'name' in user:
            return SocialLogin.registerAndLogin(
                account = user['sub'],
                name = user['name'])
        else:
            return TokenExchangeError.errorFormatter(
                TokenExchangeError.GOOGLE_ID_TOKEN_VERIFY_ERROR
            )
        