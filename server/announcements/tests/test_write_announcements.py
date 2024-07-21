from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase
from users.models import User, School
from announcements.models import AnnouncementScope
from services.TokenManager import TokenManager, UserTokenPayload

class WriteAnnouncementTests(APITestCase):

    def setUp(self):
        self.school = School.objects.create(name="Jethalal Public School")

        self.teacher = User.objects.create(
            school=self.school,
            first_name="Jane",
            last_name="Smith",
            user_type="teacher"
        )
        self.teacher_token = TokenManager.create_token(
            UserTokenPayload(
                user_id=self.teacher.id,
                user_name=self.teacher.first_name,
            )
        )

    def test_no_scope_provided(self):
        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + self.teacher_token)
        url = reverse("announcements", args=[self.school.id])
        response = self.client.post(url, {
            "title": "Test Announcement",
            "body": "This is a test announcement",
            "scope": []
        }, format="json")

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_scope_context_all_with_other_scopes(self):
        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + self.teacher_token)
        url = reverse("announcements", args=[self.school.id])
        response = self.client.post(url, {
            "title": "Test Announcement",
            "body": "This is a test announcement",
            "scope": [
                {"scope_context": AnnouncementScope.ScopeContextChoices.all},
                {
                    "scope_context": AnnouncementScope.ScopeContextChoices.student,
                    "filter_type": AnnouncementScope.ScopeFilterChoices.standard,
                    "filter_content": "10"
                }
            ]
        }, format="json")

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_standard_with_standard_division(self):
        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + self.teacher_token)
        url = reverse("announcements", args=[self.school.id])
        response = self.client.post(url, {
            "title": "Test Announcement",
            "body": "This is a test announcement",
            "scope": [
                {
                    "scope_context": AnnouncementScope.ScopeContextChoices.student,
                    "filter_type": AnnouncementScope.ScopeFilterChoices.standard,
                    "filter_content": "10"
                },
                {
                    "scope_context": AnnouncementScope.ScopeContextChoices.student,
                    "filter_type": AnnouncementScope.ScopeFilterChoices.standard_division,
                    "filter_content": "10A"
                }
            ]
        }, format="json")

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_invalid_filter_content(self):
        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + self.teacher_token)
        url = reverse("announcements", args=[self.school.id])
        response = self.client.post(url, {
            "title": "Test Announcement",
            "body": "This is a test announcement",
            "scope": [
                {
                    "scope_context": AnnouncementScope.ScopeContextChoices.student,
                    "filter_type": AnnouncementScope.ScopeFilterChoices.standard,
                    "filter_content": "invalid_standard"
                }
            ]
        }, format="json")

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
