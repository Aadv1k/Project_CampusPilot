from rest_framework import viewsets
from rest_framework.response import Response
from users.permissions import IsAuthenticated, IsMember, ReadAnnouncement, ReadWriteAnnouncement
from .serializers import AnnouncementSerializer
from api.exceptions import HTTPSerializerBadRequest
from .models import Announcement, AnnouncementScope

class AnnouncementsViewset(viewsets.ViewSet):
    permission_classes = [IsAuthenticated, IsMember]

    def get_permissions(self):
        permission_classes = self.permission_classes
        if self.action == 'list' or self.action == 'retrieve':
            permission_classes += [ReadAnnouncement]
        elif self.action == 'create' or self.action == 'destroy':
            permission_classes += [ReadWriteAnnouncement]
        return [permission() for permission in permission_classes]

    def list(self, request, school_id):
        current_user = request.user
        announcements = Announcement.objects.filter(ann_school_id=school_id)
        filtered_announcements = []
        for announcement in announcements:
            if self.check_announcement_scope(announcement, current_user):
                filtered_announcements.append(announcement)
        serializer = AnnouncementSerializer(filtered_announcements, many=True)
        return Response(serializer.data)

    def create(self, request, school_id):
        serializer = AnnouncementSerializer(data=request.data)
        print(request.data)
        if serializer.is_valid():
            #serializer.save()
            return Response(serializer.data)
        else:
            raise HTTPSerializerBadRequest(details=serializer.errors)

    def retrieve(self, request, pk, school_id):
        announcement = Announcement.objects.get(ann_id=pk, ann_school_id=school_id)
        serializer = AnnouncementSerializer(announcement)
        return Response(serializer.data)

    def check_announcement_scope(self, announcement, user):
        for scope in announcement.scope.all():
            scope_type = scope.scope_type
            filter_content = scope.filter_content
            # Check if the user matches the scope
            if scope_type == 'student':
                if str(user.id) == filter_content:
                    return True
            elif scope_type == 'teacher':
                if str(user.id) == filter_content:
                    return True
            elif scope_type == 'all':
                return True
            elif scope_type == 'standard':
                if str(user.standard) == filter_content:
                    return True
            elif scope_type == 'division':
                if str(user.division) == filter_content:
                    return True
            elif scope_type == 'subject':
                if str(user.subject) == filter_content:
                    return True
        return False