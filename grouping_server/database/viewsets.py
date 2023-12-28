from rest_framework import viewsets, mixins
from .models import Activity, User, Workspace, MissionState, Image
from .serializers import ActivityReadSerializer, ActivityWriteSerializer, ImageReadSerializer, ImageWriteSerializer, MissionStateReadSerializer, MissionStateWriteSerializer, UserReadSerializer, UserWriteSerializer, WorkspaceReadSerializer, WorkspaceWriteSerializer


class ImageViewSet(viewsets.ModelViewSet):
    queryset = Image.objects.all()
    serializer_class = ImageWriteSerializer

    def get_serializer_class(self):
        if self.request.method == 'GET':
            return ImageReadSerializer
        return super().get_serializer_class()


class WorkspaceViewSet(viewsets.ModelViewSet):
    queryset = Workspace.objects.all()
    serializer_class = WorkspaceWriteSerializer

    def get_serializer_class(self):
        if self.request.method == 'GET':
            return WorkspaceReadSerializer
        return super().get_serializer_class()


class UserViewSet(mixins.RetrieveModelMixin,
                  mixins.UpdateModelMixin,
                  mixins.ListModelMixin,
                  viewsets.GenericViewSet):
    queryset = User.objects.all()
    serializer_class = UserWriteSerializer

    def get_serializer_class(self):
        if self.request.method == 'GET':
            return UserReadSerializer
        return super().get_serializer_class()


class ActivityViewSet(viewsets.ModelViewSet):
    queryset = Activity.objects.all()
    serializer_class = ActivityWriteSerializer

    def get_serializer_class(self):
        if self.request.method == 'GET':
            return ActivityReadSerializer
        return super().get_serializer_class()


class MissionStateViewSet(viewsets.ModelViewSet):
    queryset = MissionState.objects.all()
    serializer_class = MissionStateWriteSerializer

    def get_serializer_class(self):
        if self.request.method == 'GET':
            return MissionStateReadSerializer
        return super().get_serializer_class()
