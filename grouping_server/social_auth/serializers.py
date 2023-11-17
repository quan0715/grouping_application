import requests
from rest_framework import serializers
from rest_framework.exceptions import AuthenticationFailed
from rest_framework.fields import empty
from rest_framework_simplejwt.tokens import RefreshToken, TokenError
from django.core.cache import cache

# from grouping_project_backend.models import UserManager, User
from Crypto.Cipher import AES
import base64
import datetime

import os

from . import register
from .helper_methods import TokenExchangeError, UrlGetter, SocialLogin
from .google import GoogleTokenExchange
from .github_and_line import GitHubAndLineToken

class TokenExchangeParamSerializer(serializers.Serializer):
    platform = serializers.CharField(max_length=255)
    verifier = serializers.CharField(max_length=255, allow_blank=True)
    state = serializers.CharField(max_length=255, allow_blank=True)
    
    def validate(self, attrs):
        cache.set('PLATFORM', attrs.get('platform'), timeout=10000)

        cipher = AES.new(bytes(os.environ['ENCRYPT_KEY32'], 'utf-8'),AES.MODE_ECB)
        if attrs.get("verifier") != '':
            cache.set('VERIFIER', cipher.decrypt(base64.b64decode(attrs.get("verifier"))).decode('utf-8'), timeout=10000)
            # os.environ['VERIFIER'] = cipher.decrypt(base64.b64decode(attrs.get("verifier"))).decode('utf-8')
        if attrs.get('state') != '':
            cache.set('STATE', cipher.decrypt(base64.b64decode(attrs.get("state"))).decode('utf-8'), timeout=10000)
            # os.environ['STATE'] = cipher.decrypt(base64.b64decode(attrs.get("state"))).decode('utf-8')
        return super().validate(attrs)


class LoginSerializer(serializers.Serializer):
    account = serializers.CharField(max_length=255)
    password = serializers.CharField(max_length=255)
    def validate(self, attrs):
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
    code = serializers.CharField(max_length=255)

    def validate(self, attrs):
        return oauth2_token_exchange(clientId=os.environ.get('GOOGLE_CLIENT_ID_WEB'), clientSecret=os.environ.get('GOOGLE_CLIENT_SECRET_WEB'), 
                          provider=UrlGetter.Provider.GOOGLE, grant_type='authorization_code', code=attrs['code'])


class LineSocialAuthSerializer(serializers.Serializer):
    code = serializers.CharField(max_length=255)

    def validate(self, attrs):
        if cache.get('PLATFORM') == 'web':
            return oauth2_token_exchange(clientId=os.environ.get('LINE_CLIENT_ID_WEB'), clientSecret=os.environ.get('LINE_CLIENT_SECRET_WEB'), 
                              provider=UrlGetter.Provider.LINE, grant_type='authorization_code', code=attrs['code'])
        else:
            return oauth2_token_exchange(clientId=os.environ.get('LINE_CLIENT_ID_MOBILE'), clientSecret=os.environ.get('LINE_CLIENT_SECRET_MOBILE'), 
                              provider=UrlGetter.Provider.LINE, grant_type='authorization_code', code=attrs['code'])

class GitHubSocialAuthSerializer(serializers.Serializer):
    code = serializers.CharField(max_length=255)

    def validate(self, attrs):
        if cache.get('PLATFORM') == 'web':
            return oauth2_token_exchange(clientId=os.environ.get('GITHUB_CLIENT_ID_WEB'), clientSecret=os.environ.get('GITHUB_CLIENT_SECRET_WEB'), 
                              provider=UrlGetter.Provider.GITHUB, grant_type='authorization_code', code=attrs['code'])
        else:
            return oauth2_token_exchange(clientId=os.environ.get('GITHUB_CLIENT_ID_MOBILE'), clientSecret=os.environ.get('GITHUB_CLIENT_SECRET_MOBILE'), 
                              provider=UrlGetter.Provider.GITHUB, grant_type='authorization_code', code=attrs['code'])
        

class CallbackSerializer(serializers.Serializer):

    _dict = {}

    def __init__(self, instance=None, data=..., **kwargs):
        self._dict.update(kwargs)
        super().__init__(instance, data)

    def validate(self, attrs):
        if 'code' not in self._dict:
            raise AuthenticationFailed('Auth consent denied')
        else:
            cache.set('AUTH_CODE', self._dict.get('code'))
            return cache.get('AUTH_CODE')

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

def oauth2_token_exchange(clientId:str, provider:UrlGetter.Provider, clientSecret:str = '',grant_type = '', code = ''):

    if code == '':
        return TokenExchangeError.errorFormatter(
            TokenExchangeError.NO_CODE_IN_STORAGE_ERROR
        )
    else:
        try:
            body = SocialLogin.getBody(provider, clientId, clientSecret, grant_type,code)
            header = {'Accept': 'application/json'}
            result = requests.post(UrlGetter.Provider.getTokenEndpoint(provider),data=body,headers=header)
            result = result.json()

        except:
            return TokenExchangeError.errorFormatter(
                TokenExchangeError.HANDLING_ERROR
            )
        try:
            if 'access_token' in result and provider != UrlGetter.Provider.GOOGLE:
                return GitHubAndLineToken.requestProfile(UrlGetter.Provider.getProfileEndpoint(provider),result['access_token'])
            elif provider == UrlGetter.Provider.GOOGLE:
                return GoogleTokenExchange.requestProfile(result['id_token'])
        except:
            return TokenExchangeError.errorFormatter(
                TokenExchangeError.REQUEST_PROFILE_ERROR
            )
        return TokenExchangeError.errorFormatter(
            TokenExchangeError.UNEXPECTED_ERROR
        )