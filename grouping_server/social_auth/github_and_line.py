import requests
from .helper_methods import SocialLogin, TokenExchangeError

class GitHubAndLineToken:
    def requestProfile(userPorfileEndpoint, accessToken):
        try:
            user = requests.get(userPorfileEndpoint,
                                headers={
                                    'Accept': 'application/json',
                                    'Authorization': 'Bearer '+accessToken
                                    },
                                )
            user=user.json()
            print("User: =======================>")
            print(user)
            if 'id' in user:
                result = SocialLogin.registerAndLogin(
                    account = user['id'],
                    name = user['login'])
            elif 'userId' in user:
                result = SocialLogin.registerAndLogin(
                    account = user['userId'],
                    name = user['displayName'])
            return result
        except:
            return TokenExchangeError.errorFormatter(
                TokenExchangeError.REQUEST_PROFILE_ERROR
            )