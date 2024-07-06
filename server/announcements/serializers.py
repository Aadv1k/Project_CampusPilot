from rest_framework import serializers
from .models import Announcement, AnnouncementScope, Attachment
from classes.models import Class 
from users.models import User
import re

from typing import NamedTuple, Callable, Optional

class ScopeValidationRule(NamedTuple):
    context: str
    filter_type: str
    validator: Callable[[str], bool]
    message: Optional[str] = None

std_div_pattern = re.compile(r"\b\d{1,2}[a-zA-Z]\b") 

scope_validation_rules = [
    ScopeValidationRule(
        context=AnnouncementScope.ScopeContextChoices.student[0],
        filter_type=AnnouncementScope.ScopeFilterChoices.standard[0],
        validator=lambda content: Class.objects.filter(standard=content).exists(),
        message="The standard does not exist."
    ),

    ScopeValidationRule(
        context=AnnouncementScope.ScopeContextChoices.student[0],
        filter_type=AnnouncementScope.ScopeFilterChoices.standard_division[0],
        validator=lambda content: bool(
            std_div_pattern.match(content) and 
            len(std_div_pattern.findall(content)) == 1 and 
            Class.objects.filter(
                standard=std_div_pattern.findall(content)[0][0], 
                division=std_div_pattern.findall(content)[0][1]
            ).exists()
        ),
        message="The standard and division combination does not exist."
    ),
]

# Custom field for lowercase conversion
class LowercaseCharField(serializers.CharField):
    def to_internal_value(self, data):
        return super().to_internal_value(data).lower()

class AnnouncementScopeSerializer(serializers.ModelSerializer):
    filter_content = LowercaseCharField(required=False, allow_blank=True)

    def to_internal_value(self, data):
        # This method is called before validation
        if 'filter_content' in data:
            data['filter_content'] = data['filter_content'].lower()
        return super().to_internal_value(data)

    def validate(self, data):
        context = data.get('context')
        filter_type = data.get('filter_type')
        filter_content = data.get('filter_content')

        if not filter_type and not filter_content:
            return data
    
        for rule in scope_validation_rules:
            if rule.context == context and rule.filter_type == filter_type:
                if not rule.validator(filter_content):  # No need to call .lower() here as it's already lowercase
                    raise serializers.ValidationError(rule.message or f"Invalid filter content for {filter_type}")
                return data

        raise serializers.ValidationError(f"Filter {filter_type} does not exist under context {context}")

    class Meta:
        model = AnnouncementScope
        exclude = ["announcement"]

class AnnouncementSerializer(serializers.ModelSerializer):
    scope = AnnouncementScopeSerializer(many=True, required=True)

    def validate(self, attrs):
        return super().validate(attrs)

    def validate_scope(self, scope_data):
        if not scope_data or len(scope_data) == 0:
            raise serializers.ValidationError("Announcements must have at least one scope")

        has_all_scope = False
        for scope in scope_data:
            if scope.get("scope_context") == AnnouncementScope.ScopeContextChoices.all:
                has_all_scope = True
                break

        if has_all_scope and len(scope_data) > 1:
            raise serializers.ValidationError("If 'all' scope is included, no other scopes can be set.")
        
        for scope in scope_data:
            AnnouncementScopeSerializer(data=scope).is_valid(raise_exception=True)

        return scope_data
    
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