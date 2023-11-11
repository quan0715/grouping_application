from django.contrib.auth import authenticate
from django.contrib.auth.models import update_last_login
from django.apps import apps

User = apps.get_model('database', 'User')

def login_user(account, password = ""):
    if(account == None):
        raise Exception("Account is None")

    try:
        user = User.objects.get(account=account)
        user = authenticate(account=account,password=password)
        update_last_login(None, user)

        
        return {
            'tokens': user.tokens()
        }
    except User.DoesNotExist:
        return {
                'error-code': "user_does_not_exist",
                'error': "User does not exist, please register."
            }
    except:
        user = User.objects.get(account=account)
        if(user!=None):
            return {
                'error-code': "wrong_password",
                'error': "Wrong password, please try again"
            }
        else:
            return {
                'error-code': "unexpected_error",
                'error': "Unexpected error occured, please contact admin"
            }
        
def register_user(account, name, password = ""):

    try:
        user = User.objects.create_user(account=account, user_name=name,password=password)
        user = authenticate(account=account, password=password)
        update_last_login(None, user)

        token = user.tokens()

        return {
            'tokens': token
        }
    except:
        return {
            'error-code':'unexpected_error',
            'error':'Unexpacted error occured, please contact admin'
        }