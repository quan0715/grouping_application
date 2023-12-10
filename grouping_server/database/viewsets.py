from rest_framework import viewsets, mixins
from .models import Activity, User, Workspace, MissionState, Image
from .serializers import ActivitySerializer, UserSerializer, WorkspaceSerializer, MissionStateSerializer, ActivityPatchSerializer, ImageSerializer, UserGetSerializer, WorkspaceGetSerializer


class ImageViewSet(viewsets.ModelViewSet):
    queryset = Image.objects.all()
    serializer_class = ImageSerializer


class WorkspaceViewSet(viewsets.ModelViewSet):
    queryset = Workspace.objects.all()
    serializer_class = WorkspaceSerializer

    def get_serializer_class(self):
        if self.request.method == 'GET':
            return WorkspaceGetSerializer
        return super().get_serializer_class()


class UserViewSet(mixins.RetrieveModelMixin,
                  mixins.UpdateModelMixin,
                  mixins.ListModelMixin,
                  viewsets.GenericViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer

    def get_serializer_class(self):
        if self.request.method == 'GET':
            return UserGetSerializer
        return super().get_serializer_class()


class ActivityViewSet(viewsets.ModelViewSet):
    queryset = Activity.objects.all()
    serializer_class = ActivitySerializer

    def get_serializer_class(self):
        if self.request.method == 'PATCH' or self.request.method == 'PUT':
            return ActivityPatchSerializer
        return super().get_serializer_class()


class MissionStateViewSet(viewsets.ModelViewSet):
    queryset = MissionState.objects.all()
    serializer_class = MissionStateSerializer
