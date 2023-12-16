from django.contrib import admin
from django.contrib.auth.admin import UserAdmin  # Helper Class for creating user admin pages
from django.contrib.auth.models import Group
from django.apps import apps


User = apps.get_model('database', 'User')

workspaces = apps.get_model('database', 'Workspace')


class CustomUserAdmin(UserAdmin):

    model = User

    list_display = ['id', 'user_name', 'account', 'last_login', 'is_staff', 'is_superuser']
    search_fields = ['id', 'account',]
    readonly_fields = ['account']

    filter_horizontal = ()
    list_filter = ()
    ordering = ('id',)
    fieldsets = [(None, {'fields': ['account', 'password']}),
                 ('Personal info', {'fields': ['user_name', 'real_name', 'slogan', 'introduction', 'photo_id']}),
                 ('Permissions', {'fields': [ 'is_staff', 'is_superuser']}),]

    add_fieldsets = ((None, {'fields': ('account', 'password',  'is_staff', 'is_superuser')}),)


admin.site.register(User, CustomUserAdmin)
admin.site.register(workspaces)
