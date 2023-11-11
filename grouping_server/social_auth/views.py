from rest_framework import status
from rest_framework.response import Response
from rest_framework.generics import GenericAPIView
from rest_framework.permissions import AllowAny
from .serializers import (
    LoginSerializer, LogoutSerializer, RegisterSerializer,GoogleSocialAuthSerializer, LineSocialAuthSerializer,
    GitHubSocialAuthSerializer, CallbackSerializer, TokenExchangeParamSerializer)
"""
conda activate django_4_2_2
python manage.py makemigrations
python manage.py migrate
python manage.py runserver 0.0.0.0:8000

"""

# Create your views here.
class TokenExchangeParamView(GenericAPIView):
    serializer_class = TokenExchangeParamSerializer
    permission_classes = [AllowAny]
    authentication_classes= []

    def post(self, request):
        # print(request.data)

        serializer = self.serializer_class(data=request.data)
        if serializer.is_valid():
            return Response(status=status.HTTP_204_NO_CONTENT)
        # print(serializer.errors)

class CallbackView(GenericAPIView):

    serializer_class = CallbackSerializer
    permission_classes = [AllowAny]
    authentication_classes= []

    
    def get(self, request):

        serializer = self.serializer_class(data=request.data,code=self.request.GET.get('code',''))
        serializer.is_valid(raise_exception=True)

        return Response(status=status.HTTP_200_OK)

class LoginView(GenericAPIView):
    serializer_class = LoginSerializer
    permission_classes = [AllowAny]
    authentication_classes= []
    
    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)
        # print(serializer.validated_data)

        if 'error' in serializer.validated_data:
            print(serializer.validated_data)
            return Response((serializer.validated_data), status=status.HTTP_401_UNAUTHORIZED)
        
        data = (serializer.validated_data)['tokens']['access']

        return Response(data.encode('UTF-8'), status=status.HTTP_200_OK)

class RegisterView(GenericAPIView):
    serializer_class = RegisterSerializer
    permission_classes = [AllowAny]
    authentication_classes= []

    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)
        # print(serializer.validated_data)

        if 'error' in serializer.validated_data:
            return Response((serializer.validated_data), status=status.HTTP_401_UNAUTHORIZED)
        
        data = (serializer.validated_data)['tokens']['access']
        return Response(data, status=status.HTTP_200_OK)
   
class GoogleSocialAuthView(GenericAPIView):
    serializer_class = GoogleSocialAuthSerializer
    permission_classes = [AllowAny]
    authentication_classes= []

    def post(self, request):

        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)
        # print(serializer.validated_data)

        if 'error' in serializer.validated_data:
            return Response((serializer.validated_data), status=status.HTTP_401_UNAUTHORIZED)
        data = (serializer.validated_data)['tokens']['access']
        return Response(data, status=status.HTTP_200_OK)
        # return Response(status=status.HTTP_200_OK)

class LineSocialAuthView(GenericAPIView):
    serializer_class = LineSocialAuthSerializer
    permission_classes = [AllowAny]
    authentication_classes= []

    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)
        # print(serializer.validated_data)

        if 'error' in serializer.validated_data:
            return Response((serializer.validated_data), status=status.HTTP_401_UNAUTHORIZED)
        data = (serializer.validated_data)['tokens']['access']
        return Response(data, status=status.HTTP_200_OK)

class GitHubSocialAuthView(GenericAPIView):
    serializer_class = GitHubSocialAuthSerializer
    permission_classes = [AllowAny]
    authentication_classes= []

    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)
        # print(serializer.validated_data)

        if 'error' in serializer.validated_data:
            return Response((serializer.validated_data), status=status.HTTP_401_UNAUTHORIZED)
        else:
            data = (serializer.validated_data)['tokens']['access']
            return Response(data, status=status.HTTP_200_OK)

class LogoutView(GenericAPIView):
    serializer_class = LogoutSerializer

    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save()

        if 'error-code' in serializer.validated_data:
            return Response(status=status.HTTP_400_BAD_REQUEST)
        else:
            return Response(status=status.HTTP_200_OK)