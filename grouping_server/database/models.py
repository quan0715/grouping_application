from django.db import models
from django.utils.translation import gettext_lazy as _

from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin
from rest_framework_simplejwt.tokens import RefreshToken
import base64


class Image(models.Model):
    data = models.ImageField(upload_to='images/')
    updated_at = models.DateTimeField(auto_now=True)


class UserManager(BaseUserManager):
    def create_default_workspace(self, user):
        workspace = Workspace.objects.create(workspace_name=f'{user.user_name} 的個人工作區',
                                             description=f'{user.user_name} 的個人工作區',
                                             theme_color=1)
        workspace.members.add(user)
        workspace.save()

    def create_user(self, account, password, user_name='unknown', introduction=""):
        if account is None:
            raise TypeError('Users must have an account input.')
        elif password is None:
            raise TypeError('Users must have an password input.')

        user = self.model(account=account)
        user.set_password(password)
        user.user_name = user_name
        user.introduction = introduction
        user.save()
        self.create_default_workspace(user)
        return user

    def create_superuser(self, account, password):
        if password is None:
            raise TypeError('Superusers must have a password.')

        user = self.create_user(account=account, password=password)
        user.is_superuser = True
        user.is_staff = True
        user.save()

        return user

    Auth_Providers = {"google": "google", "line": "line", "github": "github"}


class User(AbstractBaseUser, PermissionsMixin):
    # [note: 'email/Oauth id/Line id']
    account = models.CharField(max_length=20, unique=True, verbose_name="帳號")
    password = models.CharField(max_length=20, verbose_name="密碼")

    user_name = models.CharField(
        max_length=20, verbose_name="用戶名稱", default="")
    introduction = models.TextField(verbose_name="簡介", default="")
    photo = models.ForeignKey(
        Image, null=True, blank=True, on_delete=models.SET_NULL, verbose_name="頭像")
    is_staff = models.BooleanField(default=False)
    is_superuser = models.BooleanField(default=False)

    USERNAME_FIELD = "account"
    REQUIRED_FIELDS = []
    objects = UserManager()

    def __str__(self):
        return "id:%s user_name:%s" % (self.id, self.user_name)

    def tokens(self):
        refresh = RefreshToken.for_user(self)
        return {
            'refresh': str(refresh),
            'access': str(refresh.access_token)}


class UserTag(models.Model):
    belong_user = models.ForeignKey(
        User, on_delete=models.CASCADE, related_name='tags')
    title = models.CharField(max_length=20)
    content = models.CharField(max_length=20)


class Workspace(models.Model):
    theme_color = models.IntegerField()
    workspace_name = models.CharField(max_length=20)
    description = models.TextField()
    photo = models.ForeignKey(
        Image, null=True, blank=True, on_delete=models.SET_NULL)
    members = models.ManyToManyField(
        User, related_name='joined_workspaces')


class WorkspaceTag(models.Model):
    belong_workspace = models.ForeignKey(
        Workspace, on_delete=models.CASCADE, related_name='tags')
    content = models.CharField(max_length=20)


class MissionState(models.Model):
    class Stage(models.TextChoices):
        IN_PROGRESS = 'IN_PROGRESS', _('in progress')
        PENDING = 'PENDING', _('pending')
        CLOSE = 'CLOSE', _('close')
    stage = models.CharField(
        max_length=15, choices=Stage.choices, default=Stage.IN_PROGRESS)
    name = models.CharField(max_length=20)
    belong_workspace = models.ForeignKey(Workspace, on_delete=models.CASCADE)


class Activity(models.Model):
    title = models.CharField(max_length=20)
    description = models.CharField(max_length=20)
    creator = models.ForeignKey(User, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    belong_workspace = models.ForeignKey(
        Workspace, on_delete=models.CASCADE, related_name='activities')
    children = models.ManyToManyField(
        'self', symmetrical=False, blank=True, related_name='parents')
    contributors = models.ManyToManyField(
        User, related_name='contributing_activities')


class ActivityNotification(models.Model):
    belong_activity = models.ForeignKey(
        Activity, on_delete=models.CASCADE, related_name='notifications')
    notify_time = models.DateTimeField()


class Event(models.Model):
    belong_activity = models.OneToOneField(
        Activity, on_delete=models.CASCADE, primary_key=True)
    start_time = models.DateTimeField()
    end_time = models.DateTimeField()


class Mission(models.Model):
    belong_activity = models.OneToOneField(
        Activity, on_delete=models.CASCADE, primary_key=True)
    deadline = models.DateTimeField()
    state = models.ForeignKey(
        MissionState, null=True, blank=True, on_delete=models.SET_NULL)
