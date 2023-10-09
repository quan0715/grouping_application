from django.urls import include, path
from database.viewsets import ActivityViewSet, UserViewSet, WorkspaceViewSet, MissionStateViewSet, ImageViewSet
from rest_framework.routers import DefaultRouter
router = DefaultRouter()
router.register(r'users', UserViewSet, basename='user')
router.register(r'workspaces', WorkspaceViewSet, basename='workspace')
router.register(r'activities', ActivityViewSet, basename='activity')
router.register(r'states', MissionStateViewSet, basename='mission_state')
router.register(r'images', ImageViewSet, basename='image')
urlpatterns = [
    path('', include(router.urls)),
]
