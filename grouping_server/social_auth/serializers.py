import requests
from rest_framework import serializers
from rest_framework.exceptions import AuthenticationFailed
from rest_framework.fields import empty
from . import register
# from grouping_project_backend.models import UserManager, User
from dotenv import load_dotenv
from rest_framework_simplejwt.tokens import RefreshToken, TokenError

import os

load_dotenv()

class LoginSerializer(serializers.Serializer):
    account = serializers.CharField(max_length=255)
    password = serializers.CharField(max_length=255)
    def validate(self, attrs):
        print("LoginSerializer.validate() called")
        self.account = attrs.get('account')
        self.password = attrs.get('password')
        return register.login_user(
            account = self.account,
            password = self.password
        )

class RegisterSerializer(serializers.Serializer):
    account = serializers.CharField(max_length=255)
    password = serializers.CharField(max_length=255)
    username = serializers.CharField(max_length=255,allow_blank = True)
    def validate(self, attrs):
        print("LoginSerializer.validate() called")
        self.account = attrs.get('account')
        self.password = attrs.get('password')
        if "username" in attrs:
            self.username = attrs.get('username')
        else:
            self.username = 'unknown'
        return register.register_user(
            account = self.account,
            password = self.password,
            name = self.username
        )

# The toutorial's code is at https://github.com/CryceTruly/incomeexpensesapi/tree/master/social_auth
class GoogleSocialAuthSerializer(serializers.Serializer):

    def validate(self, attrs):
        return oauth2_token_exchange(client_id=os.environ.get('GOOGLE_CLIENT_ID_WEB'), client_secret=os.environ.get('GOOGLE_CLIENT_SECRET_WEB'), 
                              tokenEndpoint='https://oauth2.googleapis.com/token',userPorfileEndpoint='https://oauth2.googleapis.com/tokeninfo',grant_type='authorization_code')


class LineSocialAuthSerializer(serializers.Serializer):
    def placeholder():
        pass

class GitHubSocialAuthSerializer(serializers.Serializer):

    def validate(self, attrs):
        return oauth2_token_exchange(client_id=os.environ.get('GITHUB_CLIENT_ID'), client_secret=os.environ.get('GITHUB_CLIENT_SECRET'), 
                              tokenEndpoint='https://github.com/login/oauth/access_token',userPorfileEndpoint='https://api.github.com/user')
        

class CallbackSerializer(serializers.Serializer):

    _dict = {}

    def __init__(self, instance=None, data=..., **kwargs):
        self._dict.update(kwargs)
        super().__init__(instance, data)

    def validate(self, attrs):
        # print(attrs)
        if 'code' not in self._dict:
            raise AuthenticationFailed('Auth consent denied')
        else:
            os.environ['AUTH_CODE'] = self._dict.get('code')
            print(self._dict.get('code'))
            return os.environ.get('AUTH_CODE')

class LogoutSerializer(serializers.Serializer):
    refresh_token = serializers.CharField()

    def validate(self, attrs):
        self.token = attrs['refresh_token']
        return attrs

    def save(self, **kwargs):
        try:
            RefreshToken(self.token).blacklist()
        except TokenError:
            return {
                'error-code': 'invalid_token',
                'error':'The token is invalid or expired. Please login again.'
            }

def oauth2_token_exchange(client_id:str, tokenEndpoint:str, userPorfileEndpoint:str, client_secret:str = '', grant_type:str = None):

    if not os.environ.get('AUTH_CODE'):
        return {
            'error-code': 'no_code',
            'error' : 'No code in temparary storage, please send the oauth request again'
        }
    else:
        print(os.environ.get('AUTH_CODE'))
        body = {
            'client_id':client_id,
            'client_secret':client_secret,
            'code':os.environ.get('AUTH_CODE'),
            'redirect_uri':'http://localhost:8000/',
        }
        if(grant_type != None):
            body['grant_type'] = grant_type
        result = requests.post(tokenEndpoint,json =  body,headers={'Accept': 'application/json'})
        result = result.json()
        print(result)
        if 'access_token' in result:
            print("Heeeeeeeeeeere it is! "+result['access_token'])
            user = requests.get(userPorfileEndpoint,
                                headers={
                                    'Accept': 'application/json',
                                    'Authorization': 'Bearer '+result['access_token']
                                    },
                                )
            user=user.json()
            print(user)
            result = register.login_user(
                account = user['id'],
                name = user['login'])
            if 'error' in result:
                result = register.register_user(
                    account = user['id'],
                    name = user['login'])
            return result
        else:
            return {
                'error-code': 'no_access_code',
                'error':'code handle process failed'
            }