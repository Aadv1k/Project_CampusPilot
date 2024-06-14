from rest_framework import serializers
from .models import Announcement, Attachment, AnnouncementScope

class AttachmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Attachment
        fields = ('attach_id', 'file_name', 'file_type', 'file_path', 'upload_date')

class AnnouncementScopeSerializer(serializers.ModelSerializer):
    class Meta:
        model = AnnouncementScope
        fields = ('scope_type', 'filter_type', 'filter_content')

class AnnouncementSerializer(serializers.ModelSerializer):
    attachments = AttachmentSerializer(many=True, read_only=True)
    scope = AnnouncementScopeSerializer(many=True, read_only=True)

    class Meta:
        model = Announcement
        fields = ('ann_from', 'ann_id', 'title', 'content', 'attachments', 'scope')