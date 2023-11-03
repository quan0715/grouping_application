from rest_framework import viewsets
from rest_framework.response import Response

from .views import GoogleSocialAuthView
from .serializers import (GoogleSocialAuthSerializer)


# class GoogleOauthViewSet(viewsets.GenericViewSet):
#     def list(self, request):
#         serializer_class = GoogleSocialAuthSerializer
#         print(self.request.GET)
#         return Response(self.request.GET)
#     def 