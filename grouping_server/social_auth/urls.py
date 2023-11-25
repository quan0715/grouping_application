from django.urls import include, path
# from .viewsets import GoogleOauthViewSet
from rest_framework.routers import DefaultRouter
from .views import (LoginView, RegisterView, GoogleSocialAuthView, LineSocialAuthView, GitHubSocialAuthView,
                    LogoutView, TokenExchangeParamView)

router = DefaultRouter()
# router.register(r'google', GoogleOauthViewSet, basename='google')
urlpatterns = [
    path('', include(router.urls)),
    path("signin/", LoginView.as_view()),
    path("register/", RegisterView.as_view()),
    path("google/", GoogleSocialAuthView.as_view()),
    path("line/", LineSocialAuthView.as_view()),
    path("github/", GitHubSocialAuthView.as_view()),
    path("logout/", LogoutView.as_view()),
    path("exchange_params/",TokenExchangeParamView.as_view()),
]

