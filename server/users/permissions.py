from rest_framework import permissions, exceptions
from rest_framework.authentication import get_authorization_header
from django.conf import settings
import jwt
from django.shortcuts import get_object_or_404
from schools.models import School
from .models import User, UserPermission

def extract_auth_header_from_request(request):
    auth = get_authorization_header(request).split()

    if not auth or auth[0].lower() != b'bearer':
        raise exceptions.AuthenticationFailed('Invalid token header')

    if len(auth) == 1 or len(auth) > 2:
        raise exceptions.AuthenticationFailed('Invalid token header')

    return auth

class IsAuthenticated(permissions.BasePermission):
    def has_permission(self, request, view):
        try:
            auth_header = extract_auth_header_from_request(request)
        except exceptions.AuthenticationFailed:
            return False

        token = auth_header[1]
        try:
            payload = jwt.decode(token, settings.SECRET_KEY, algorithms=['HS256'])
        except jwt.ExpiredSignatureError:
            raise exceptions.AuthenticationFailed('Token has expired')
        except jwt.DecodeError:
            raise exceptions.AuthenticationFailed('Invalid token')

        return True

class IsMember(permissions.BasePermission):
    def has_permission(self, request, view):
        school_id = view.kwargs.get("school_id")
        try:
            School.objects.get(id=school_id)
        except School.DoesNotExist:
            raise exceptions.NotFound("Couldn't find school with that ID")
        return True

    def has_object_permission(self, request, view, school):
        return User.objects.filter(id=request.user.id, school=school).exists()

class ReadAnnouncement(permissions.BasePermission):
    """
    Permission to allow read access to announcements.
    """

    def has_permission(self, request, view):
        return request.user.permissions.filter(type=UserPermission.UserPermissionChoices.read_announcements).exists()

class ReadWriteAnnouncement(permissions.BasePermission):
    """
    Permission to allow read and write access to announcements.
    """

    def has_permission(self, request, view):
        return request.user.permissions.filter(type=UserPermission.UserPermissionChoices.write_announcements).exists()
