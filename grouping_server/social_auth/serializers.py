import requests
from rest_framework import serializers
from rest_framework.exceptions import AuthenticationFailed
from rest_framework.fields import empty
from rest_framework_simplejwt.tokens import RefreshToken, TokenError

# from grouping_project_backend.models import UserManager, User
from dotenv import load_dotenv
from Crypto.Cipher import AES
import urllib.parse
import base64

from google.auth.transport import requests as googleRequest
from google.oauth2 import id_token

import os

from . import register
from .config import Config

load_dotenv()

class PlatformSerializer(serializers.Serializer):
    platform = serializers.CharField(max_length=255)
    def validate(self, attrs):
        os.environ['PLATFORM'] = attrs.get('platform')

        os.unsetenv("VERIFIER")
        os.unsetenv("AUTH_CODE")
        os.unsetenv('STATE')

        print('PLATFORM: '+os.environ['PLATFORM'])
        return super().validate(attrs)

class VerifierSerializer(serializers.Serializer):
    verifier = serializers.CharField(max_length=255)
    def validate(self, attrs):
        cipher = AES.new(b'haha8787 I am not sure fjkfjkfjk',AES.MODE_ECB)
        os.environ['VERIFIER'] = cipher.decrypt(base64.b64decode(attrs.get("verifier"))).decode('utf-8')
        # print("VERIFIER: "+os.environ.get("VERIFIER"))
        return super().validate(attrs)
    
class StateSerializer(serializers.Serializer):
    state = serializers.CharField(max_length=255)
    def validate(self, attrs):
        cipher = AES.new(b'haha8787 I am not sure fjkfjkfjk',AES.MODE_ECB)
        os.environ['STATE'] = cipher.decrypt(base64.b64decode(attrs.get("state"))).decode('utf-8')
        # print("STATE: "+os.environ.get("STATE"))
        return super().validate(attrs)

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
                              tokenEndpoint=Config.googleTokenEndpoint ,userPorfileEndpoint=Config.googleUserProfileEndpoint,grant_type='authorization_code')


class LineSocialAuthSerializer(serializers.Serializer):
    def validate(self, attrs):
        if os.environ.get('PLATFORM') == 'web':
            return oauth2_token_exchange(client_id=os.environ.get('LINE_CLIENT_ID_WEB'), client_secret=os.environ.get('LINE_CLIENT_SECRET_WEB'), 
                              tokenEndpoint=Config.lineTokenEndpoint,userPorfileEndpoint=Config.lineUserProfileEndpoint,grant_type='authorization_code')
        else:
            return oauth2_token_exchange(client_id=os.environ.get('LINE_CLIENT_ID_MOBILE'), client_secret=os.environ.get('LINE_CLIENT_SECRET_MOBILE'), 
                              tokenEndpoint=Config.lineTokenEndpoint,userPorfileEndpoint=Config.lineUserProfileEndpoint,grant_type='authorization_code')

class GitHubSocialAuthSerializer(serializers.Serializer):

    def validate(self, attrs):
        if os.environ.get('PLATFORM') == 'web':
            return oauth2_token_exchange(client_id=os.environ.get('GITHUB_CLIENT_ID_WEB'), client_secret=os.environ.get('GITHUB_CLIENT_SECRET_WEB'), 
                              tokenEndpoint=Config.gitHubTokenEndpoint,userPorfileEndpoint=Config.gitHubUserProfileEndpoint)
        else:
            return oauth2_token_exchange(client_id=os.environ.get('GITHUB_CLIENT_ID_MOBILE'), client_secret=os.environ.get('GITHUB_CLIENT_SECRET_MOBILE'), 
                              tokenEndpoint=Config.gitHubTokenEndpoint,userPorfileEndpoint=Config.gitHubUserProfileEndpoint)
        

class CallbackSerializer(serializers.Serializer):

    code = serializers.CharField(max_length=255)
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

def oauth2_token_exchange(client_id:str, tokenEndpoint:str, userPorfileEndpoint:str, client_secret:str = '',grant_type = ''):

    if not os.environ.get('AUTH_CODE'):
        return {
            'error-code': 'no_code',
            'error' : 'No code in temparary storage, please send the oauth request again'
        }
    else:
        header = {'Accept': 'application/json'}
        body = {
                    'client_id':client_id,
                    'client_secret':client_secret,
                    'code':os.environ.get('AUTH_CODE'),
                }
        print("AUTH_CODE: "+os.environ.get('AUTH_CODE'))
        if os.environ.get('platform') == 'web':
            body['redirect_uri'] =Config.baseUriWeb+"/auth/callback/"          
        else:
            body['redirect_uri'] =Config.baseUriMobile+"/auth/callback/"
        if 'VERIFIER' in os.environ:
                body['code_verifier']=os.environ.get('VERIFIER')
        if (grant_type != ''):
            body['grant_type'] = grant_type
            print('grant_type: '+body['grant_type'])
        if 'STATE' in os.environ:
            body['state'] = os.environ.get("STATE")
            # header = {'Accept': 'application/x-www-form-urlencoded'}
            # body
        try:
            result = requests.post(tokenEndpoint,data=body,headers=header)
            result = result.json()

        except:
            return {
            'error-code': 'handling_error',
            'error' : 'Error happend when exchanging code.'
        }
        print("Result: =======================>")
        print(result)
        try:
            if 'access_token' in result and tokenEndpoint != Config.googleTokenEndpoint:
                user = requests.get(userPorfileEndpoint,
                                    headers={
                                        'Accept': 'application/json',
                                        'Authorization': 'Bearer '+result['access_token']
                                        },
                                    )
                user=user.json()
                print("User: =======================>")
                print(user)
                if 'id' in user:
                    result = register.login_user(
                        account = user['id'])
                    if 'error' in result:
                        result = register.register_user(
                            account = user['id'],
                            name = user['login'])
                elif 'userId' in user:
                    result = register.login_user(
                        account = user['userId'])
                    if 'error' in result:
                        result = register.register_user(
                            account = user['userId'],
                            name = user['displayName'])
                return result
            elif 'id_token' in result:
                user = id_token.verify_oauth2_token(
                    result['id_token'], googleRequest.Request(),clock_skew_in_seconds = 2)

                print("User: =======================>")
                print(user)

                if 'accounts.google.com' in user['iss']:
                    if 'sub' in user:
                        result = register.login_user(
                        account = user['sub'])
                        if 'error' in result:
                            result = register.register_user(
                                account = user['sub'],
                                name = user['name'])
                    return result
                else:
                    return {
                    'error-code': 'google_id_token_verify_error',
                    'error':'when google id token verify, unexpected error happended'
                }
        except:
            return {
                'error-code': 'request_profile_error',
                'error' : 'When requesting profile, error occured'
            }
        return {
            'error-code': 'no_access_code',
            'error':'code handle process failed'
        }