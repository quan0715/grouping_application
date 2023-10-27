from django.urls import path
from .views import (LoginView, RegisterView, GoogleSocialAuthView, LineSocialAuthView, GitHubSocialAuthView,
                    LogoutView, CallbackView, PlatformView, VerifierView, StateView)
urlpatterns = [
    path("platform/", PlatformView.as_view()),
    path("verifier/", VerifierView.as_view()),
    path("state/",StateView.as_view()),
    path("account/signin/", LoginView.as_view()),
    path("account/register/", RegisterView.as_view()),
    path("google/", GoogleSocialAuthView.as_view()),
    path("line/", LineSocialAuthView.as_view()),
    path("github/", GitHubSocialAuthView.as_view()),
    path("logout/", LogoutView.as_view()),
    path("callback/",CallbackView.as_view())
]