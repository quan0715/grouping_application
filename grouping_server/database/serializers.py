from abc import ABCMeta, abstractmethod
from typing import List
from rest_framework import serializers, exceptions
from .models import Image, User, UserTag, MissionState, Activity, ActivityNotification, Event, Mission, WorkspaceTag, Workspace
from grouping_server import settings

# ---↓↓↓--- below is SimpleReadSerializer part ---↓↓↓---


class ABCMetaAndSerializerMetaclassCombineMeta(ABCMeta, serializers.SerializerMetaclass):
    """
    This metaclass is a simple metaclass only combine ABCMeta and serializers.SerializerMetaclass
    """
    pass


class BaseReadSerializer(serializers.ModelSerializer):
    """
    Base class for all read serializer
    """
    def create(self, validated_data):
        raise exceptions.MethodNotAllowed(
            method=self.context['request'].method)

    def update(self, instance, validated_data):
        raise exceptions.MethodNotAllowed(
            method=self.context['request'].method)


class BaseWriteSerializer(serializers.ModelSerializer, metaclass=ABCMetaAndSerializerMetaclassCombineMeta):
    """
    Base class for all write serializer
    """
    @abstractmethod
    def get_read_serializer(self, *args, **kwargs):
        """
        all subclass should overwrite this method to explicitly return a corresponding read serializer
        """
        pass

    def to_representation(self, instance):
        read_serializer = self.get_read_serializer(instance)
        representation = read_serializer.data
        return representation



class ImageSimpleReadSerializer(BaseReadSerializer):
    image_uri = serializers.ImageField(source='data', read_only=True)

    class Meta:
        model = Image
        fields = ['id', 'image_uri', 'updated_at']
        extra_kwargs = {
            'id': {'read_only': True},
            'updated_at': {'read_only': True}
        }


class UserTagSimpleReadSerializer(BaseReadSerializer):
    class Meta:
        model = UserTag
        fields = ['id', 'title', 'content']
        extra_kwargs = {
            'id': {'read_only': True},
            'title': {'read_only': True},
            'content': {'read_only': True}
        }


class UserSimpleReadSerializer(BaseReadSerializer):
    photo = ImageSimpleReadSerializer(read_only=True)

    class Meta:
        model = User
        fields = ['id', 'user_name', 'photo']
        extra_kwargs = {
            'id': {'read_only': True},
            'user_name': {'read_only': True}
        }


class WorkspaceTagSimpleReadSerializer(BaseReadSerializer):
    class Meta:
        model = WorkspaceTag
        fields = ['id', 'content']
        extra_kwargs = {
            'id': {'read_only': True},
            'content': {'read_only': True}
        }


class WorkspaceSimpleReadSerializer(BaseReadSerializer):
    photo = ImageSimpleReadSerializer(read_only=True)

    class Meta:
        model = Workspace
        fields = ['id', 'theme_color', 'workspace_name', 'photo']
        extra_kwargs = {
            'id': {'read_only': True},
            'theme_color': {'read_only': True},
            'workspace_name': {'read_only': True}
        }


class MissionStateSimpleReadSerializer(BaseReadSerializer):
    class Meta:
        model = MissionState
        fields = ['id', 'stage', 'name']
        extra_kwargs = {
            'id': {'read_only': True},
            'stage': {'read_only': True},
            'name': {'read_only': True},
        }


class MissionSimpleReadSerializer(BaseReadSerializer):
    state = MissionStateSimpleReadSerializer(read_only=True)

    class Meta:
        model = Mission
        fields = ['deadline', 'state']
        extra_kwargs = {
            'deadline': {'read_only': True},
        }


class EventSimpleReadSerializer(BaseReadSerializer):
    class Meta:
        model = Event
        fields = ['start_time', 'end_time']
        extra_kwargs = {
            'start_time': {'read_only': True},
            'end_time': {'read_only': True},
        }


class ActivityNotificationSimpleReadSerializer(BaseReadSerializer):
    class Meta:
        model = ActivityNotification
        fields = ['id', 'notify_time']
        extra_kwargs = {
            'id': {'read_only': True},
            'notify_time': {'read_only': True},
        }


class ActivitySimpleReadSerializer(BaseReadSerializer):
    event = EventSimpleReadSerializer(read_only=True)
    mission = MissionSimpleReadSerializer(read_only=True)
    belong_workspace = WorkspaceSimpleReadSerializer(read_only=True)

    class Meta:
        model = Activity
        fields = ['id', 'title', 'event', 'mission', 'belong_workspace']
        extra_kwargs = {
            'id': {'read_only': True},
            'title': {'read_only': True},
        }


# ---↑↑↑--- above is SimpleReadSerializer part ---↑↑↑---


# ---↓↓↓--- below is ReadSerializer part ---↓↓↓---

class ImageReadSerializer(ImageSimpleReadSerializer):
    pass


class UserReadSerializer(UserSimpleReadSerializer):
    tags = UserTagSimpleReadSerializer(many=True, read_only=True)
    joined_workspaces = WorkspaceSimpleReadSerializer(many=True,
                                                      read_only=True)
    contributing_activities = ActivitySimpleReadSerializer(many=True,
                                                           read_only=True)

    class Meta(UserSimpleReadSerializer.Meta):
        fields = UserSimpleReadSerializer.Meta.fields + [
            'account', 'introduction',
            'tags', 'joined_workspaces', 'contributing_activities']
        extra_kwargs = UserSimpleReadSerializer.Meta.extra_kwargs.copy()
        extra_kwargs.update({
            'account': {'read_only': True},
            'introduction': {'read_only': True}
        })


class WorkspaceReadSerializer(WorkspaceSimpleReadSerializer):
    members = UserSimpleReadSerializer(many=True, read_only=True)
    tags = WorkspaceTagSimpleReadSerializer(many=True, read_only=True)
    activities = ActivitySimpleReadSerializer(many=True, read_only=True)

    class Meta(WorkspaceSimpleReadSerializer.Meta):
        fields = WorkspaceSimpleReadSerializer.Meta.fields + [
            'description',
            'members', 'tags', 'activities']
        extra_kwargs = WorkspaceSimpleReadSerializer.Meta.extra_kwargs.copy()
        extra_kwargs.update({
            'description': {'read_only': True}
        })


class MissionStateReadSerializer(MissionStateSimpleReadSerializer):
    belong_workspace = WorkspaceSimpleReadSerializer(read_only=True)

    class Meta(MissionStateSimpleReadSerializer.Meta):
        fields = MissionStateSimpleReadSerializer.Meta.fields + [
            'belong_workspace']


class ActivityReadSerializer(ActivitySimpleReadSerializer):
    creator = UserSimpleReadSerializer(read_only=True)
    children = ActivitySimpleReadSerializer(many=True,
                                            read_only=True)
    contributors = UserSimpleReadSerializer(many=True,
                                            read_only=True)
    notifications = ActivityNotificationSimpleReadSerializer(many=True,
                                                             read_only=True)

    class Meta(ActivitySimpleReadSerializer.Meta):
        fields = ActivitySimpleReadSerializer.Meta.fields + [
            'description', 'created_at',
            'creator', 'children', 'contributors', 'notifications']
        extra_kwargs = ActivitySimpleReadSerializer.Meta.extra_kwargs.copy()
        extra_kwargs.update({
            'description': {'read_only': True},
            'created_at': {'read_only': True},
        })


# ---↑↑↑--- above is ReadSerializer part ---↑↑↑---

# ---↑↑↑--- above is stable ---↑↑↑---

# ---↓↓↓--- below is WriteSerializer part ---↓↓↓---

class ImageWriteSerializer(BaseWriteSerializer):
    data = serializers.ImageField(write_only=True)

    class Meta:
        model = Image
        fields = ['data']

    def get_read_serializer(self, *args, **kwargs):
        return ImageReadSerializer(*args, **kwargs)


class UserTagValidateSerializer(serializers.ModelSerializer):
    """
    only for validating, do NOT use this to read or write any model.
    """
    class Meta:
        model = UserTag
        fields = ['title', 'content']
        extra_kwargs = {
            'title': {'write_only': True},
            'content': {'write_only': True}
        }


class UserWriteSerializer(BaseWriteSerializer):
    tags = UserTagValidateSerializer(
        many=True, required=False, allow_empty=True, write_only=True)
    photo_data = serializers.ImageField(write_only=True)

    class Meta:
        model = User
        fields = ['account', 'user_name', 'introduction',
                  'tags', 'photo_data']
        extra_kwargs = {
            'account': {'write_only': True},
            'user_name': {'write_only': True},
            'introduction': {'write_only': True},
        }

    def create(self, validated_data):
        raise exceptions.MethodNotAllowed(
            method=self.context['request'].method)

    def update(self, instance, validated_data):
        tags_data = validated_data.pop('tags', None)
        photo_data = validated_data.pop('photo_data', None)

        instance = super().update(instance, validated_data)

        if tags_data != None:
            instance.tags.all().delete()
            for tag_data in tags_data:
                UserTag.objects.create(belong_user=instance, **tag_data)

        if photo_data:
            if instance.photo:
                instance.photo.delete()
            photo = Image.objects.create(data=photo_data)
            instance.photo = photo

        instance.save()

        return instance

    def get_read_serializer(self, *args, **kwargs):
        return UserReadSerializer(*args, **kwargs)


class WorkspaceTagValidateSerializer(serializers.ModelSerializer):
    """
    only for validating, do NOT use this to read or write any model.
    """
    class Meta:
        model = WorkspaceTag
        fields = ['content']
        extra_kwargs = {
            'content': {'write_only': True}
        }


class WorkspaceWriteSerializer(BaseWriteSerializer):
    tags = WorkspaceTagValidateSerializer(
        many=True, required=False, allow_empty=True, write_only=True)
    photo_data = serializers.ImageField(write_only=True, required=False)

    class Meta:
        model = Workspace
        fields = ['theme_color', 'workspace_name', 'description',
                  'tags', 'photo_data', 'members']
        extra_kwargs = {
            'theme_color': {'write_only': True},
            'workspace_name': {'write_only': True},
            'description': {'write_only': True},
            'members': {'many': True, 'required': False, 'allow_empty': True, 'write_only': True}
        }

    def create(self, validated_data):
        tags_data: List = validated_data.pop('tags', None)
        photo_data = validated_data.pop('photo_data', None)
        members: List = validated_data.pop('members', None)

        if members != None:
            raise serializers.ValidationError(
                '"members" can not be provided using this method. Try using PATCH.')

        instance = Workspace.objects.create(**validated_data)

        if tags_data != None:
            for tag_data in tags_data:
                WorkspaceTag.objects.create(
                    belong_workspace=instance, **tag_data)

        if photo_data:
            photo = Image.objects.create(data=photo_data)
            instance.photo = photo

        instance.save()

        return instance

    def update(self, instance, validated_data):
        tags_data = validated_data.pop('tags', None)
        photo_data = validated_data.pop('photo_data', None)

        instance = super().update(instance, validated_data)

        if tags_data != None:
            instance.tags.all().delete()
            for tag_data in tags_data:
                WorkspaceTag.objects.create(
                    belong_workspace=instance, **tag_data)

        if photo_data:
            if instance.photo:
                instance.photo.delete()
            photo = Image.objects.create(data=photo_data)
            instance.photo = photo

        instance.save()

        return instance

    def get_read_serializer(self, *args, **kwargs):
        return WorkspaceReadSerializer(*args, **kwargs)


class MissionStateWriteSerializer(BaseWriteSerializer):
    class Meta:
        model = MissionState
        fields = ['stage', 'name', 'belong_workspace']
        extra_kwargs = {
            'stage': {'write_only': True},
            'name': {'write_only': True},
            'belong_workspace': {'write_only': True}
        }

    def get_read_serializer(self, *args, **kwargs):
        return MissionStateReadSerializer(*args, **kwargs)


class EventWriteSerializer(BaseWriteSerializer):
    start_time = serializers.DateTimeField(
        input_formats=settings.DATETIME_FORMAT, write_only=True)
    end_time = serializers.DateTimeField(
        input_formats=settings.DATETIME_FORMAT, write_only=True)

    class Meta:
        model = Event
        fields = ['start_time', 'end_time']

    def get_read_serializer(self, *args, **kwargs):
        return EventSimpleReadSerializer(*args, **kwargs)


class MissionWriteSerializer(BaseWriteSerializer):
    deadline = serializers.DateTimeField(
        input_formats=settings.DATETIME_FORMAT, write_only=True)

    class Meta:
        model = Mission
        fields = ['deadline', 'state']

    def get_read_serializer(self, *args, **kwargs):
        return MissionSimpleReadSerializer(*args, **kwargs)


class ActivityNotificationValidateSerializer(serializers.ModelSerializer):
    """
    only for validating, do NOT use this to read or write any model.
    """
    notify_time = serializers.DateTimeField(
        input_formats=settings.DATETIME_FORMAT, write_only=True)

    class Meta:
        model = ActivityNotification
        fields = ['notify_time']


class ActivityWriteSerializer(BaseWriteSerializer):
    event = EventWriteSerializer(required=False, write_only=True)
    mission = MissionWriteSerializer(required=False, write_only=True)
    notifications = ActivityNotificationValidateSerializer(
        many=True, required=False, allow_empty=True, write_only=True)

    class Meta:
        model = Activity
        fields = ['title', 'description', 'creator', 'belong_workspace',
                  'event', 'mission', 'children', 'contributors', 'notifications']
        extra_kwargs = {
            'title': {'write_only': True},
            'description': {'write_only': True},
            'creator': {'write_only': True},
            'belong_workspace': {'write_only': True},
            'children': {'many': True, 'required': False, 'write_only': True},
            'contributors': {'many': True, 'required': False, 'write_only': True}
        }

    def create(self, validated_data):
        event_data = validated_data.pop('event', None)
        mission_data = validated_data.pop('mission', None)
        children = validated_data.pop('children', None)
        contributors = validated_data.pop('contributors', None)
        notifications_data = validated_data.pop('notifications', None)

        errors = {}
        if event_data and mission_data:
            errors['event'] = [
                'This field cannot coexist with the mission field.']
            errors['mission'] = [
                'This field cannot coexist with the event field.']
        elif (not event_data) and (not mission_data):
            errors['event'] = [
                'Either this field or the mission field should be provided.']
            errors['mission'] = [
                'Either this field or the event field should be provided.']
        if children is not None:
            errors['children'] = [
                'This field can not be provided using this method. Try using PATCH.']
        if contributors is not None:
            errors['contributors'] = [
                'This field can not be provided using this method. Try using PATCH.']
        if errors:
            raise serializers.ValidationError(errors)

        activity = super().create(validated_data)

        if event_data:
            Event.objects.create(belong_activity=activity, **event_data)
        elif mission_data:
            Mission.objects.create(belong_activity=activity, **mission_data)
        if notifications_data:
            for notification_data in notifications_data:
                ActivityNotification.objects.create(
                    belong_activity=activity, **notification_data)
        return activity

    def update(self, instance, validated_data):
        event_data = validated_data.pop('event', None)
        mission_data = validated_data.pop('mission', None)
        notifications_data = validated_data.pop('notifications', None)

        instance = super().update(instance, validated_data)

        if event_data:
            try:
                event = Event.objects.get(belong_activity=instance)
                event_serializer = EventWriteSerializer(
                    instance=event, data=event_data)
                if event_serializer.is_valid():
                    event_serializer.save()
            except Event.DoesNotExist:
                raise serializers.ValidationError(
                    'The event field can only be write into an event.')
        elif mission_data:
            try:
                mission = Mission.objects.get(belong_activity=instance)
                mission_serializer = MissionWriteSerializer(
                    instance=mission, data=mission_data)
                if mission_serializer.is_valid():
                    mission_serializer.save()
            except Mission.DoesNotExist:
                raise serializers.ValidationError(
                    'The mission field can only be write into an mission.')
        if notifications_data:
            instance.notifications.all().delete()
            for notification_data in notifications_data:
                ActivityNotification.objects.create(
                    belong_activity=instance, **notification_data)

        return instance

    def get_read_serializer(self, *args, **kwargs):
        return ActivityReadSerializer(*args, **kwargs)

# ---↑↑↑--- above is WriteSerializer part ---↑↑↑---
