from django.apps import apps

User = apps.get_model('database', 'User')

class AccountAuthBackend:

    def authenticate(self, request, account=None, password=""):
        print("AccountAuthBackend.authenticate() called")
        print("account: "+account)
        try:
            user = User.objects.get(account=account,password=password)
        except User.DoesNotExist:
            return None
        return user
    
    def get_user(self, user_id):
        print("AccountAuthBackend.get_user() called")
        try:
            return User.objects.get(pk=user_id)
        except User.DoesNotExist:
            return None