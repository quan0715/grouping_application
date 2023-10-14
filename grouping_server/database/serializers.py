from rest_framework import serializers
from .models import Image, User, UserTag,  MissionState, Activity, ActivityNotification, Event, Mission, WorkspaceTag,  Workspace


class ImageSerializer(serializers.ModelSerializer):
    class Meta:
        model = Image
        fields = ['id', 'data', 'updated_at']


class WorkspaceTagSerializer(serializers.ModelSerializer):
    class Meta:
        model = WorkspaceTag
        fields = ['content']


class WorkspaceSerializer(serializers.ModelSerializer):
    tags = WorkspaceTagSerializer(
        many=True, required=False, allow_empty=True)
    photo = ImageSerializer(required=False)

    class Meta:
        model = Workspace
        fields = ['id', 'theme_color', 'workspace_name',
                  'description', 'is_personal', 'photo', 'members', 'tags']
        extra_kwargs = {
            'members': {'many': True, 'required': False, 'allow_empty': True}
        }

    def create(self, validated_data):
        validated_data.pop('members', None)
        photo_data = validated_data.pop('photo', None)
        tags_data = validated_data.pop('tags', None)

        if photo_data:
            photo = Image.objects.create(**photo_data)
            workspace = Workspace.objects.create(photo=photo, **validated_data)
        else:
            workspace = Workspace.objects.create(**validated_data)

        if tags_data:
            for tag_data in tags_data:
                WorkspaceTag.objects.create(
                    belong_workspace=workspace, **tag_data)
        return workspace

    def update(self, instance, validated_data):
        photo_data = validated_data.pop('photo', None)
        tags_data = validated_data.pop('tags', None)

        instance = super().update(instance, validated_data)

        if photo_data:
            if instance.photo:
                instance.photo.delete()
            photo = Image.objects.create(**photo_data)
            instance.photo = photo
            instance.save()

        if tags_data:
            instance.tags.all().delete()
            for tag_data in tags_data:
                WorkspaceTag.objects.create(
                    belong_workspace=instance, **tag_data)

        return instance


class UserTagSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserTag
        fields = ['title', 'content']


class EventSerializer(serializers.ModelSerializer):
    start_time = serializers.DateTimeField(
        input_formats=["%Y-%m-%d", "iso-8601"])
    end_time = serializers.DateTimeField(
        input_formats=["%Y-%m-%d", "iso-8601"])

    class Meta:
        model = Event
        fields = ['start_time', 'end_time']


class MissionSerializer(serializers.ModelSerializer):
    deadline = serializers.DateTimeField(
        input_formats=["%Y-%m-%d", "iso-8601"])

    class Meta:
        model = Mission
        fields = ['deadline', 'state']
        extra_kwargs = {'state': {'required': False}}


class ActivityNotificationSerializer(serializers.ModelSerializer):
    notify_time = serializers.DateTimeField(
        input_formats=["%Y-%m-%d", "iso-8601"])

    class Meta:
        model = ActivityNotification
        fields = ['notify_time']


class ActivitySerializer(serializers.ModelSerializer):
    parents = serializers.PrimaryKeyRelatedField(many=True,
                                                 read_only=True)
    event = EventSerializer(required=False)
    mission = MissionSerializer(required=False)
    childs = serializers.PrimaryKeyRelatedField(many=True,
                                                read_only=True)
    contributors = serializers.PrimaryKeyRelatedField(many=True,
                                                      read_only=True)
    notifications = ActivityNotificationSerializer(
        many=True, required=False, allow_empty=True)

    class Meta:
        model = Activity
        fields = ['id', 'title', 'description', 'creator',
                  'created_at', 'belong_workspace', 'childs',
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
        fields = ['id', 'title', 'description', 'creator',
                  'created_at', 'belong_workspace', 'childs',
                  'parents', 'contributors', 'event', 'mission', 'notifications']
        extra_kwargs = {'childs': {'many': True},
                        'contributors': {'many': True}}

    def update(self, instance, validated_data):
        return super().update(instance, validated_data)

    def update(self, instance, validated_data):
        instance = super().update(instance, validated_data)
        event_data = validated_data.pop('event', None)
        mission_data = validated_data.pop('mission', None)
        notifications_data = validated_data.pop('notifications', None)
        activity = Activity.objects.create(**validated_data)

        if event_data:
            try:
                event = Event.objects.get(belong_activity=instance)
                EventSerializer().update(event, event_data)
            except Event.DoesNotExist:
                EventSerializer().create(belong_activity=instance, **event_data)
        if mission_data:
            try:
                mission = Mission.objects.get(belong_activity=instance)
                MissionSerializer().update(mission, mission_data)
            except Mission.DoesNotExist:
                mission = MissionSerializer().create(belong_activity=instance, **mission_data)
        if notifications_data:
            for notification_data in notifications_data:
                notification_id = notification_data.get('id', None)
                if notification_id:
                    notification = ActivityNotification.objects.get(
                        id=notification_id, belong_activity=instance)
                    ActivityNotificationSerializer().update(notification, notification_data)
                else:
                    ActivityNotificationSerializer().create(
                        belong_activity=instance, **notification_data)
        return activity


class UserSerializer(serializers.ModelSerializer):
    joined_workspaces = WorkspaceSerializer(many=True, read_only=True)
    tags = UserTagSerializer(many=True, required=False, allow_empty=True)
    contributing_activities = ActivitySerializer(many=True, read_only=True)

    class Meta:
        model = User
        fields = ['id', 'account', 'password', 'real_name',
                  'user_name', 'slogan', 'introduction', 'photo',
                  'tags', 'joined_workspaces', 'contributing_activities']
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        tags_data = validated_data.pop('tags', None)
        user = User.objects.create(**validated_data)
        if tags_data:
            for tag_data in tags_data:
                UserTag.objects.create(belong_user=user, **tag_data)
        return user


class MissionStateSerializer(serializers.ModelSerializer):
    class Meta:
        model = MissionState
        fields = ['id', 'stage', 'name', 'belong_workspace']
