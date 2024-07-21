from rest_framework import serializers
from .models import Announcement, AnnouncementScope, Attachment
from classes.models import Class 
from users.models import User

from users.serializers import UserSerializer

import re

import services.utils as utils

from typing import NamedTuple, Callable, Optional, Tuple

class ScopeValidationRule(NamedTuple):
    context: str
    filter_type: str
    validator: Callable[[str], bool]
    message: Optional[str] = None

scope_validation_rules = [
    ScopeValidationRule(
        context=AnnouncementScope.ScopeContextChoices.student.value,
        filter_type=AnnouncementScope.ScopeFilterChoices.standard.value,
        validator=lambda content: content.isdigit() and Class.objects.filter(standard=content).exists(),
        message="The standard does not exist."
    ),
    ScopeValidationRule(
        context=AnnouncementScope.ScopeContextChoices.student.value,
        filter_type=AnnouncementScope.ScopeFilterChoices.standard_division.value,
        validator=lambda content: Class.validate_standard_division_format(content) and
            Class.objects.filter(
                standard=Class.extract_standard_and_division_from_str(content)[0], 
                division=Class.extract_standard_and_division_from_str(content)[1], 
            ).exists(),
        message="Either the std-div format is invalid; or std / div doesn't exist."
    ),
]

class LowercaseCharField(serializers.CharField):
    def to_internal_value(self, data):
        return super().to_internal_value(data).lower()

class AnnouncementScopeSerializer(serializers.ModelSerializer):
    filter_content = LowercaseCharField(required=False, allow_blank=True)

    def validate(self, data):
        scope_context = data.get('scope_context')
        filter_type = data.get('filter_type')
        filter_content = data.get('filter_content')

        if not filter_type and not filter_content:
            return data
    
        for rule in scope_validation_rules:
            if rule.context == scope_context and rule.filter_type == filter_type:
                if not rule.validator(filter_content):
                    raise serializers.ValidationError(rule.message or f"Invalid filter content for {filter_type}")
                return data

        raise serializers.ValidationError(f"Filter {filter_type} does not exist under context {scope_context}")

    class Meta:
        model = AnnouncementScope
        exclude = ["announcement", "id"]

class AnnouncementOutputSerializer(serializers.ModelSerializer):
    announcer = UserSerializer()

    class Meta:
        model = Announcement
        exclude = ["id"]
        

class AnnouncementSerializer(serializers.ModelSerializer):
    scope = AnnouncementScopeSerializer(many=True, required=True)

    def validate(self, attrs):
        return super().validate(attrs)

    def validate_scope(self, scope):
        if not scope or len(scope) == 0:
            raise serializers.ValidationError("Announcements must have at least one scope")

        has_all_scope = False
        classroom_standards = []

        for scope_item in scope:
            AnnouncementScopeSerializer(data=scope_item).is_valid(raise_exception=True)
            if scope_item.get("scope_context") == AnnouncementScope.ScopeContextChoices.all:
                break

            if scope_item.get("filter_type") == AnnouncementScope.ScopeFilterChoices.standard_division:
                std, _ = Class.extract_standard_and_division_from_str(scope_item.get("filter_content"))
                classroom_standards.append(std)

            if scope_item.get("filter_type") == AnnouncementScope.ScopeFilterChoices.standard and scope_item.get("filter_content") in classroom_standards:
                raise serializers.ValidationError("When a standard scope is provided, standard_division scope of the same standard can't be passed")

        if has_all_scope and len(scope) > 1:
            raise serializers.ValidationError("If 'all' scope is included, no other scopes can be set.")

        return scope
    
    def create(self, validated_data):
        announcement = Announcement.objects.create(
            announcer = validated_data["announcer"],
            title =  validated_data["title"],
            body = validated_data["body"]
        )

        for scope in validated_data["scope"]:
            AnnouncementScope.objects.create(
                announcement = announcement,
                **scope
            )

        return announcement

    def update(self, instance, validated_data):
        instance.title = validated_data.get('title', instance.title)
        instance.body = validated_data.get('body', instance.body)

        instance.scope.all().delete()

        scopes_data = validated_data.pop('scope', [])
        for scope_data in scopes_data:
            AnnouncementScope.objects.create(announcement=instance, **scope_data)

        instance.save()
        return instance

    class Meta:
        model = Announcement
        fields = "__all__"