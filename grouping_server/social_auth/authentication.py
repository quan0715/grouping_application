from django.apps import apps

User = apps.get_model('database', 'User')

class AccountAuthBackend:

    def authenticate(self, request, account=None, password=""):
        try:
            user = User.objects.get(account=account,password=password)
        except:
            raise
        return user
    
    def get_user(self, user_id):
        try:
            return User.objects.get(pk=user_id)
        except:
            raise