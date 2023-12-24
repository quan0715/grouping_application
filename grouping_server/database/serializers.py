from rest_framework import serializers
from .models import Image, User, UserTag,  MissionState, Activity, ActivityNotification, Event, Mission, WorkspaceTag,  Workspace


class ImageSerializer(serializers.ModelSerializer):
    image_uri = serializers.ImageField(source='data', read_only=True)
    data = serializers.ImageField(write_only=True)

    class Meta:
        model = Image
        fields = ['id', 'image_uri', 'data', 'updated_at']
        extra_kwargs = {
            'updated_at': {'read_only': True}
        }


class WorkspaceTagSerializer(serializers.ModelSerializer):
    class Meta:
        model = WorkspaceTag
        fields = ['content']


class WorkspaceSerializer(serializers.ModelSerializer):
    tags = WorkspaceTagSerializer(
        many=True, required=False, allow_empty=True)
    photo_data = serializers.ImageField(write_only=True, required=False)
    photo = ImageSerializer(read_only=True)

    class Meta:
        model = Workspace
        fields = ['id', 'theme_color', 'workspace_name',
                  'description', 'photo_data', 'photo', 'members', 'tags', 'activities']
        extra_kwargs = {
            'members': {'many': True, 'required': False, 'allow_empty': True},
            'activities': {'many': True, 'read_only': True}
        }

    def create(self, validated_data):
        validated_data.pop('members', None)
        photo_data = validated_data.pop('photo_data', None)
        tags_data = validated_data.pop('tags', None)

        if photo_data:
            photo = Image.objects.create(data=photo_data)
            workspace = Workspace.objects.create(photo=photo, **validated_data)
        else:
            workspace = Workspace.objects.create(**validated_data)

        if tags_data != None:
            for tag_data in tags_data:
                WorkspaceTag.objects.create(
                    belong_workspace=workspace, **tag_data)

        return workspace

    def update(self, instance, validated_data):
        photo_data = validated_data.pop('photo_data', None)
        tags_data = validated_data.pop('tags', None)

        instance = super().update(instance, validated_data)

        if photo_data:
            if instance.photo:
                instance.photo.delete()
            photo = Image.objects.create(data=photo_data)
            instance.photo = photo
            instance.save()

        if tags_data != None:
            instance.tags.all().delete()
            for tag_data in tags_data:
                WorkspaceTag.objects.create(
                    belong_workspace=instance, **tag_data)

        return instance


class WorkspaceSimpleSerializer(serializers.ModelSerializer):
    photo = ImageSerializer(read_only=True,)

    class Meta:
        model = Workspace
        fields = ['id', 'theme_color', 'workspace_name', 'photo']
        extra_kwargs = {
            'id': {'read_only': True},
            'theme_color': {'read_only': True},
            'workspace_name': {'read_only': True}
        }


class UserSimpleSerializer(serializers.ModelSerializer):
    photo = ImageSerializer(read_only=True)

    class Meta:
        model = User
        fields = ['id', 'user_name', 'photo']
        extra_kargs = {
            'id': {'read_only': True},
            'user_name': {'read_only': True},
        }


class EventSerializer(serializers.ModelSerializer):
    start_time = serializers.DateTimeField(
        input_formats=["%Y-%m-%d", "iso-8601"])
    end_time = serializers.DateTimeField(
        input_formats=["%Y-%m-%d", "iso-8601"])

    class Meta:
        model = Event
        fields = ['start_time', 'end_time']


class MissionStateSerializer(serializers.ModelSerializer):
    class Meta:
        model = MissionState
        fields = ['id', 'stage', 'name', 'belong_workspace']


class MissionSerializer(serializers.ModelSerializer):
    deadline = serializers.DateTimeField(
        input_formats=["%Y-%m-%d", "iso-8601"])

    class Meta:
        model = Mission
        fields = ['deadline', 'state']


class MissionSimpleSerializer(serializers.ModelSerializer):
    state = MissionStateSerializer(read_only=True)

    class Meta:
        model = Mission
        fields = ['deadline', 'state']
        extra_kwargs = {
            'deadline': {'read_only': True},
        }


class ActivitySimpleSerializer(serializers.ModelSerializer):
    event = EventSerializer(read_only=True)
    mission = MissionSimpleSerializer(read_only=True)
    belong_workspace = WorkspaceSimpleSerializer(read_only=True)

    class Meta:
        model = Activity
        fields = ['id', 'title', 'event', 'mission', 'belong_workspace']
        extra_kwargs = {
            'id': {'read_only': True},
            'title': {'read_only': True},
        }


class WorkspaceGetSerializer(serializers.ModelSerializer):
    photo = ImageSerializer(read_only=True)
    members = UserSimpleSerializer(many=True, read_only=True)
    tags = WorkspaceTagSerializer(many=True, read_only=True)
    activities = ActivitySimpleSerializer(many=True, read_only=True)

    class Meta:
        model = Workspace
        fields = ['id', 'theme_color', 'workspace_name', 'description',
                  'photo', 'members', 'tags', 'activities']
        extra_kwargs = {
            'id': {'read_only': True},
            'theme_color': {'read_only': True},
            'workspace_name': {'read_only': True},
            'description': {'read_only': True},
        }


class UserTagSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserTag
        fields = ['title', 'content']


class ActivityNotificationSerializer(serializers.ModelSerializer):
    notify_time = serializers.DateTimeField(
        input_formats=["%Y-%m-%d", "iso-8601"])

    class Meta:
        model = ActivityNotification
        fields = ['notify_time']


class ActivityReadSerializer(ActivitySimpleSerializer):
    creator = UserSimpleSerializer(read_only=True)
    children = ActivitySimpleSerializer(many=True,
                                        read_only=True)
    contributors = UserSimpleSerializer(many=True,
                                        read_only=True)
    notifications = ActivityNotificationSerializer(many=True,
                                                   read_only=True)

    class Meta(ActivitySimpleSerializer.Meta):
        fields = ActivitySimpleSerializer.Meta.fields + [
            'description', 'created_at',
            'creator', 'children', 'contributors', 'notifications']
        extra_kwargs = ActivitySimpleSerializer.Meta.extra_kwargs.copy()
        extra_kwargs.update({
            'description': {'read_only': True},
            'created_at': {'read_only': True},
        })


class ActivitySerializer(serializers.ModelSerializer):
    parents = serializers.PrimaryKeyRelatedField(many=True,
                                                 read_only=True)
    event = EventSerializer(required=False)
    mission = MissionSerializer(required=False)
    children = serializers.PrimaryKeyRelatedField(many=True,
                                                  read_only=True)
    contributors = serializers.PrimaryKeyRelatedField(many=True,
                                                      read_only=True)
    notifications = ActivityNotificationSerializer(
        many=True, required=False, allow_empty=True)

    class Meta:
        model = Activity
        fields = ['id', 'title', 'description', 'creator',
                  'created_at', 'belong_workspace', 'children',
                  'parents', 'contributors', 'event', 'mission', 'notifications']

    def create(self, validated_data):
        event_data = validated_data.pop('event', None)
        mission_data = validated_data.pop('mission', None)
        notifications_data = validated_data.pop('notifications', None)

        if event_data and mission_data:
            raise serializers.ValidationError(
                "An activity can only be connected to either an Event or a Mission, not both.")
        elif (not event_data) and (not mission_data):
            raise serializers.ValidationError(
                "An activity must connected to either an Event or a Mission.")

        activity = Activity.objects.create(**validated_data)

        if event_data:
            Event.objects.create(belong_activity=activity, **event_data)
        elif mission_data:
            Mission.objects.create(belong_activity=activity, **mission_data)
        if notifications_data:
            for notification_data in notifications_data:
                ActivityNotification.objects.create(
                    belong_activity=activity, **notification_data)
        return activity


class ActivityPatchSerializer(serializers.ModelSerializer):
    parents = serializers.PrimaryKeyRelatedField(many=True,
                                                 read_only=True)
    event = EventSerializer(required=False)
    mission = MissionSerializer(required=False)
    notifications = ActivityNotificationSerializer(
        many=True, required=False, allow_empty=True)

    class Meta:
        model = Activity
        fields = ['id', 'title', 'description', 'creator', 'created_at', 'belong_workspace',
                  'children', 'parents', 'contributors', 'event', 'mission', 'notifications']
        extra_kwargs = {
            'children': {'many': True, 'required': False},
            'contributors': {'many': True, 'required': False}
        }

    def update(self, instance, validated_data):
        event_data = validated_data.pop('event', None)
        mission_data = validated_data.pop('mission', None)
        notifications_data = validated_data.pop('notifications', None)

        instance = super().update(instance, validated_data)

        if event_data:
            try:
                event = Event.objects.get(belong_activity=instance)
                EventSerializer().update(event, event_data)
            except Event.DoesNotExist:
                raise serializers.ValidationError(
                    'The event field can only be write into an event.')
        elif mission_data:
            try:
                mission = Mission.objects.get(belong_activity=instance)
                MissionSerializer().update(mission, mission_data)
            except Mission.DoesNotExist:
                raise serializers.ValidationError(
                    'The mission field can only be write into an mission.')
        if notifications_data:
            instance.notifications.all().delete()
            for notification_data in notifications_data:
                ActivityNotification.objects.create(
                    belong_activity=instance, **notification_data)

        return instance


class UserSerializer(serializers.ModelSerializer):
    joined_workspaces = WorkspaceSerializer(many=True, read_only=True)
    tags = UserTagSerializer(many=True, required=False, allow_empty=True)
    photo_data = serializers.ImageField(write_only=True)
    photo = ImageSerializer(read_only=True)

    class Meta:
        model = User
        fields = ['id', 'account', 'user_name', 'introduction', 'photo_data',
                  'photo', 'tags', 'joined_workspaces', 'contributing_activities']
        extra_kargs = {
            'contributing_activities': {'many': True, 'read_only': True}
        }

    def update(self, instance, validated_data):
        photo_data = validated_data.pop('photo_data', None)
        tags_data = validated_data.pop('tags', None)

        instance = super().update(instance, validated_data)

        if photo_data:
            if instance.photo:
                instance.photo.delete()
            photo = Image.objects.create(data=photo_data)
            instance.photo = photo
            instance.save()

        if tags_data != None:
            instance.tags.all().delete()
            for tag_data in tags_data:
                UserTag.objects.create(belong_user=instance, **tag_data)

        return instance


class UserGetSerializer(serializers.ModelSerializer):
    photo = ImageSerializer(read_only=True)
    tags = UserTagSerializer(many=True, read_only=True)
    joined_workspaces = WorkspaceSimpleSerializer(many=True, read_only=True)
    contributing_activities = ActivitySimpleSerializer(
        many=True, read_only=True)

    class Meta:
        model = User
        fields = ['id', 'account', 'user_name', 'introduction',
                  'photo', 'tags', 'joined_workspaces', 'contributing_activities']
        extra_kargs = {
            'id': {'read_only': True},
            'account': {'read_only': True},
            'user_name': {'read_only': True},
            'introduction': {'read_only': True}
        }
