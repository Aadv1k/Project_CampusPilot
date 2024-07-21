from rest_framework import permissions, exceptions
from rest_framework.authentication import get_authorization_header
from django.conf import settings
import jwt

from .models import User, School

def extract_auth_token_or_fail(request):
    auth = get_authorization_header(request).split()

    if not auth or auth[0].lower() != b'bearer':
        raise exceptions.AuthenticationFailed('Invalid token header')

    if len(auth) == 1 or len(auth) > 2:
        raise exceptions.AuthenticationFailed('Invalid token header')

    return auth[1]

class IsAuthenticated(permissions.BasePermission):
    def has_permission(self, request, view):
        try:
            auth_token = extract_auth_token_or_fail(request)
        except exceptions.AuthenticationFailed:
            return False

        try:
            jwt.decode(auth_token, settings.SECRET_KEY, algorithms=['HS256'])
        except jwt.DecodeError:
            return False;

        return True

class IsPartOfSchool(permissions.BasePermission):
    def has_permission(self, request, view):
        school_id = view.kwargs.get("school_id")
        found_school = School.objects.filter(id=school_id)

        if not found_school.exists():
            return False
        
        return found_school.first().people.filter(id=request.user.id).exists()

    def has_object_permission(self, request, view, school):
        return User.objects.filter(id=request.user.id, school=school).exists()

class CanViewAnnouncements(permissions.BasePermission):
    def has_permission(self, request, view):
        return request.user.user_type in { User.UserType.TEACHER, User.UserType.ADMIN, User.UserType.STUDENT }

class CanModifyAnnouncements(permissions.BasePermission):
    def has_permission(self, request, view):
        return request.user.user_type in { User.UserType.TEACHER, User.UserType.ADMIN }
    
    def has_object_permission(self, request, view, obj):
        return obj.announcer == request.user