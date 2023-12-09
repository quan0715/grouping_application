from rest_framework import viewsets, mixins
from .models import Activity, User, Workspace, MissionState, Image, UserTag
from .serializers import ActivitySerializer, UserSerializer, WorkspaceSerializer, MissionStateSerializer, ActivityPatchSerializer, ImageSerializer


class ImageViewSet(viewsets.ModelViewSet):
    queryset = Image.objects.all()
    serializer_class = ImageSerializer


class WorkspaceViewSet(viewsets.ModelViewSet):
    queryset = Workspace.objects.all()
    serializer_class = WorkspaceSerializer


class UserViewSet(mixins.RetrieveModelMixin,
                  mixins.UpdateModelMixin,
                  mixins.ListModelMixin,
                  viewsets.GenericViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    
    def partial_update(self, request, *args, **kwargs):
        if request.data['tags'] == []:
            UserTag.objects.filter(belong_user=request.data['id']).delete()
        return super().partial_update(request, *args, **kwargs)


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
