import os
from dotenv import load_dotenv
from rest_framework import status
from rest_framework.response import Response
from rest_framework.generics import GenericAPIView
from .serializers import (
    LoginSerializer, LogoutSerializer, RegisterSerializer, GoogleSocialAuthSerializer, LineSocialAuthSerializer, GitHubSocialAuthSerializer, CallbackSerializer)
"""
conda activate django_4_2_2
python manage.py makemigrations
python manage.py migrate
python manage.py runserver 0.0.0.0:8000

"""

# Create your views here.
class CallbackView(GenericAPIView):

    serializer_class = CallbackSerializer
    
    def get(self, request):
        load_dotenv()

        serializer = self.serializer_class(data=request.data,code=self.request.GET.get('code',''))
        serializer.is_valid(raise_exception=True)

        return Response(status=status.HTTP_200_OK)

class LoginView(GenericAPIView):
    serializer_class = LoginSerializer
    
    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)
        print(serializer.validated_data)

        if 'error' in serializer.validated_data:
            return Response((serializer.validated_data), status=status.HTTP_401_UNAUTHORIZED)
        
        data = (serializer.validated_data)['tokens']['access']
        return Response(data, status=status.HTTP_200_OK)
    
class RegisterView(GenericAPIView):
    serializer_class = RegisterSerializer
    
    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)
        print(serializer.validated_data)

        if 'error' in serializer.validated_data:
            return Response((serializer.validated_data), status=status.HTTP_401_UNAUTHORIZED)
        
        data = (serializer.validated_data)['tokens']['access']
        return Response(data, status=status.HTTP_200_OK)
    
class GoogleSocialAuthView(GenericAPIView):
    serializer_class = GoogleSocialAuthSerializer

    def post(self, request):

        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)
        print(serializer.validated_data)

        if 'error' in serializer.validated_data:
            return Response((serializer.validated_data), status=status.HTTP_401_UNAUTHORIZED)
        data = (serializer.validated_data)['tokens']['access']
        return Response(data, status=status.HTTP_200_OK)
        # return Response(status=status.HTTP_200_OK)

class LineSocialAuthView(GenericAPIView):
    serializer_class = LineSocialAuthSerializer

    def post(self, request):
        pass


class GitHubSocialAuthView(GenericAPIView):
    serializer_class = GitHubSocialAuthSerializer

    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)
        print(serializer.validated_data)

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
            return Response(status=status.HTTP_205_NO_CONTENT)