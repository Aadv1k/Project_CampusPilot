from rest_framework import serializers
from .models import Announcement, AnnouncementScope, Attachment
from users.models import User
import re

class AnnouncementScopeSerializer(serializers.ModelSerializer):
    def validate(self, data):
        filter_type = data.get('filter_type')
        filter_content = data.get('filter_content')

        if filter_type == AnnouncementScope.ScopeFilterChoices.standard_division:
            if not self.validate_standard_division(filter_content):
                raise serializers.ValidationError("Invalid standard division filter content, expected [Std][Div]")
        elif filter_type == AnnouncementScope.ScopeFilterChoices.standard:
            if not self.validate_standard(filter_content):
                raise serializers.ValidationError("Invalid standard filter content.")
        elif filter_type == AnnouncementScope.ScopeFilterChoices.full_name:
            if not self.validate_full_name(filter_content):
                raise serializers.ValidationError("Invalid full name filter")
        elif filter_type == None:
            pass
        else:
            raise serializers.ValidationError(f"filter type {filter_type} not implemented!")

        return data

    def validate_full_name(self, value):
        parts = value.split()
        if len(parts) != 2:
            raise serializers.ValidationError("Full name should contain at least two parts (first name and last name).")

        first_name = parts[0]
        last_name = ' '.join(parts[1:])

        try:
            user = User.objects.get(first_name__iexact=first_name, last_name__iexact=last_name)
            return True
        except User.DoesNotExist:
            raise serializers.ValidationError("User with this first and last name combination does not exist.")


    def validate_standard(self, content):
        try:
            standard_value = int(content)
            if standard_value < 1 or standard_value > 12:
                return False
            return True
        except ValueError:
            return False

    def validate_standard_division(self, content):
        pattern = r'^(\d{1,2})([A-Z])$'
        return bool(re.match(pattern, content))

    class Meta:
        model = AnnouncementScope
        fields = ['scope', 'filter_type', 'filter_content']

class AttachmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Attachment
        fields = ['file_name', 'file_path', 'file_type']

class AnnouncementSerializer(serializers.ModelSerializer):
    scope = AnnouncementScopeSerializer(many=True)
    attachments = AttachmentSerializer(many=True, required=False)

    class Meta:
        model = Announcement
        fields = ["title", "body", "announcer", "scope", "attachments"]

    def validate_scope(self, value):
        if not value:
            raise serializers.ValidationError("At least one scope is required.")

        has_all_scope = False
        for scope_item in value:
            if scope_item["scope"] == AnnouncementScope.ScopeContextChoices.all:
                has_all_scope = True
                break

        if has_all_scope and len(value) > 1:
            raise serializers.ValidationError("If 'all' scope is included, no other scopes can be set.")

        return value
    
    def to_representation(self, instance):
        representation = super().to_representation(instance)
        representation['scope'] = AnnouncementScopeSerializer(instance.scope, many=True).data
        representation['attachments'] = AttachmentSerializer(instance.attachments, many=True).data
        return representation
    
    def to_internal_value(self, data):
        internal_value = super().to_internal_value(data)
        internal_value['scope'] = self.fields['scope'].to_internal_value(data.get('scope', []))
        internal_value['attachments'] = self.fields['attachments'].to_internal_value(data.get('attachments', []))
        return internal_value

    def create(self, validated_data):
        scope = validated_data.get("scope")
        attachments = validated_data.get("attachments", {})

        announcement = Announcement.objects.create(
            announcer=validated_data["announcer"],
            title=validated_data["title"],
            body=validated_data["body"],
        )

        for scope_item in scope:
            AnnouncementScope.objects.create(
                announcement=announcement,
                **scope_item
            )

        for attachment in attachments:
            Attachment.objects.create(
                announcement=announcement,
                **attachment
            )

        return announcement
