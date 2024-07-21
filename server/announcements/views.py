from rest_framework import viewsets, pagination, status
from rest_framework.response import Response
from users.permissions import (
    IsAuthenticated,
    IsPartOfSchool,
    CanModifyAnnouncements,
    CanViewAnnouncements
)
from .serializers import AnnouncementOutputSerializer, AnnouncementSerializer
from api.exceptions import HTTPSerializerBadRequest, HTTPForbidden, HTTPNotFound
from .models import Announcement, AnnouncementScope
from users.models import User

from django.db.models import Q

class AnnouncementsViewset(viewsets.ViewSet):

# https://www.django-rest-framework.org/api-guide/viewsets/#introspecting-viewset-actions
    def get_permissions(self):
        permission_classes = [IsAuthenticated, IsPartOfSchool]
        if self.action == 'create':
            permission_classes += [CanModifyAnnouncements]
        if self.action == 'list':
            permission_classes += [CanViewAnnouncements]
        return [permission() for permission in permission_classes]

    def list(self, request, school_id=None):
        filtered_announcements = [
            announcement for announcement in Announcement.objects.filter(
                ~Q(announcer__id=request.user.id),
                announcer__school__id=school_id
            ) if announcement.for_user(request.user)
        ]

        serializer = AnnouncementSerializer(
            data=filtered_announcements,
            many=True
        )

        serializer.is_valid()

        return Response({
            "message": "Fetched the announcements",
            "data": list(serializer.data)
        }, status=status.HTTP_200_OK)
        

    def create(self, request, school_id=None):
        serializer = AnnouncementSerializer(data={
            "announcer": request.user.id,
            **{ k: v for k,v in request.data.items()}
        })
        if not serializer.is_valid():
            raise HTTPSerializerBadRequest(details=serializer.errors)

        serializer.save()

        return Response({
            "message": "Created a new announcement mate!",
            "data": {
                "title": serializer.validated_data["title"],
                "body": serializer.validated_data["body"],
            }
        }, status=status.HTTP_201_CREATED)

    def retrieve(self, request, school_id=None, announcement_id=None):
        try:
            
            announcement = Announcement.objects.get(id=announcement_id, announcer__school__id=school_id)
            if not announcement.for_user(request.user):
                raise HTTPForbidden("This announcement can't be viewed by you")
            return Response({
                "data": AnnouncementOutputSerializer(announcement).data
            }, status=status.HTTP_200_OK)

        except Announcement.DoesNotExist:
            raise HTTPNotFound("Announcement with that ID wasn't found in your school")

class MyAnnouncementsViewset(viewsets.ViewSet):
    def get_permissions(self):
        permission_classes = [IsAuthenticated, IsPartOfSchool]
        if self.action == 'list' or self.action == 'retrieve':
            permission_classes += [CanViewAnnouncements]
        return [permission() for permission in permission_classes]

    def list(self, request, school_id=None):
        user_announcements = Announcement.objects.filter(
            announcer__id=request.user.id,
            announcer__school__id=school_id
        )

        serializer = AnnouncementSerializer(
            user_announcements,
            many=True
        )

        return Response({
            "message": "Fetched your announcements",
            "data": serializer.data
        }, status=status.HTTP_200_OK)

    def retrieve(self, request, school_id=None, announcement_id=None):
        try:
            announcement = Announcement.objects.get(id=announcement_id, announcer__id=request.user.id, announcer__school__id=school_id)
            return Response({
                "data": AnnouncementOutputSerializer(announcement).data
            }, status=status.HTTP_200_OK)
        except Announcement.DoesNotExist:
            raise HTTPNotFound("Announcement with that ID wasn't found in your school")