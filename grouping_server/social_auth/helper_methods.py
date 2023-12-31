from .register import register_user, login_user
from enum import Enum
from .config import Config

import os
from django.core.cache import cache

class SocialLogin:
    def getBody(provider:Enum, clientId, cilentSecret, grant_type = '', code = ''):
        
        body = {
                    'client_id':clientId,
                    'client_secret':cilentSecret,
                    'code':code,
                }
        body['redirect_uri'] = UrlGetter.getFrontEndUrl()
        if cache.__contains__('VERIFIER'):
            body['code_verifier']=cache.get('VERIFIER')
        if (grant_type != ''):
            body['grant_type'] = grant_type
        if cache.__contains__('STATE'):
            body['state'] = cache.get("STATE")

        return body
        
    def registerAndLogin(account, name):
        result = login_user(
            account = account)
        if 'error' in result:
            result = register_user(
                account = account,
                name = name)
        return result

class TokenExchangeError(Enum):
    NO_CODE_IN_STORAGE_ERROR = 'No code in temparary storage, please send the oauth request again'
    HANDLING_ERROR = 'Error happend when exchanging code.'
    GOOGLE_ID_TOKEN_VERIFY_ERROR = 'When google id token verify, unexpected error happended'
    GITHUB_OR_LINE_TOKEN_EXCHANGE_ERROR = 'When exchanging token, error occured'
    REQUEST_PROFILE_ERROR = 'When requesting profile, error occured'
    UNEXPECTED_ERROR = 'Code handle process failed unexpected'
    REFRESH_TOKEN_EXPIRED = 'Refresh token already expired'

    def errorFormatter(toBeFormatted:Enum):
        return {
            'error-code': toBeFormatted.name,
            'error' : toBeFormatted.value
        }

class UrlGetter:
    class Provider(Enum):
        GOOGLE = 'google'
        GITHUB = 'github'
        LINE = 'line'
        def getTokenEndpoint(provider:Enum):
            match provider:    
                case UrlGetter.Provider.GOOGLE:
                    return Config.googleTokenEndpoint
                case UrlGetter.Provider.GITHUB:
                    return Config.gitHubTokenEndpoint
                case UrlGetter.Provider.LINE:
                    return Config.lineTokenEndpoint
       
        def getProfileEndpoint(provider:Enum):
            match provider:
                case UrlGetter.Provider.GOOGLE:
                    return Config.googleUserProfileEndpoint
                case UrlGetter.Provider.GITHUB:
                    return Config.gitHubUserProfileEndpoint
                case UrlGetter.Provider.LINE:
                    return Config.lineUserProfileEndpoint
    
    def getFrontEndUrl():
        # return Config.frontEndUrlWeb

        if cache.get('PLATFORM') == 'web':
            return Config.frontEndUrlWeb
        else:
            return Config.frontEndUrlMobile