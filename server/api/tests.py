from rest_framework.test import APIRequestFactory
from django.test import TestCase

import unittest
from schools.models import School 

from users.models import User, UserPermission, UserContact
from announcements.models import AnnouncementScope, Announcement, Attachment

from utils.OTPManager import otp_manager

from utils.TokenManager import TokenManager, UserTokenPayload

from rest_framework.test import APIClient

from django.urls import reverse

MOCK_PHONE = "1234567890"
MOCK_COUNTRY_CODE = "91"

class UserTests(TestCase):
    def setUp(self):
        self.client = APIClient()
        school = School.objects.create(
            name = "Jethalal Public School",
            email = "contact@jethalal.edu",
        )

        user = User.objects.create(
            school = school,
            first_name = "Robin",
            last_name = "Sharma",
            user_type = User.UserTypeChoices.student,
        )
        
        UserContact.objects.create(
            user=user,
            country_code = MOCK_COUNTRY_CODE,
            phone_number = MOCK_PHONE,
            email = "foo@example.org",
            relation_type = UserContact.RelationTypeChoices.PRIMARY,
        )
        
        UserPermission.objects.create(user=user, type=UserPermission.UserPermissionChoices.read_announcements) 

        UserPermission.objects.create(user=user, type=UserPermission.UserPermissionChoices.write_announcements) 
    
        self.user = user
    
    def test_user_bad_login(self):
        response = self.client.post(reverse("user_login"), {
            "phone_number": "29ihehbwhbeb",
            "country_code": "2292"
        })

        self.assertEqual(response.status_code, 400)
        self.assertIsNotNone(response.data["error"]["details"]["phone_number"])
        self.assertIsNotNone(response.data["error"]["details"]["country_code"])

    def test_non_existent_user_login(self):
        response = self.client.post(reverse("user_login"), {
            "phone_number": "1800801920",
            "country_code": "44"
        })
        self.assertEqual(response.status_code, 400)
    
    def test_successful_login(self):
        response = self.client.post(reverse("user_login"), {
            "phone_number": MOCK_PHONE,
            "country_code":MOCK_COUNTRY_CODE
        })
        self.assertEqual(response.status_code, 200)

    def test_otp_verification(self):
        response = self.client.post(reverse("user_login"), {
            "phone_number": MOCK_PHONE,
            "country_code":MOCK_COUNTRY_CODE
        })

        stored_otp = otp_manager.get_otp(f"{MOCK_COUNTRY_CODE}{MOCK_PHONE}")

        response = self.client.post(reverse("user_otp_verify"), {
            "phone_number": MOCK_PHONE,
            "country_code": MOCK_COUNTRY_CODE,
            "otp": stored_otp
        })
        
        self.assertEqual(response.status_code, 200)
        self.assertIsNotNone(response.data.get("access_token"))

        payload = TokenManager.decode_token(response.data.get("access_token"))
        self.assertEqual(payload.user_name, "Robin Sharma")
        self.assertIn(UserPermission.UserPermissionChoices.read_announcements, payload.user_permissions)

class AnnouncementTests(TestCase):
    def setUp(self):
        self.client = APIClient()

        self.school = School.objects.create(
            name="Jethalal Public School",
            email="contact@jethalal.edu",
        )

        self.user_without_permissions = User.objects.create(
            school=self.school,
            first_name="John",
            last_name="Doe",
            user_type=User.UserTypeChoices.student,
        )
        self.user_with_permissions = User.objects.create(
            school=self.school,
            first_name="Jane",
            last_name="Doe",
            user_type=User.UserTypeChoices.teacher,
        )

        UserContact.objects.create(
            user=self.user_without_permissions,
            country_code=MOCK_COUNTRY_CODE,
            phone_number=MOCK_PHONE,
            email="john.doe@example.com",
            relation_type=UserContact.RelationTypeChoices.PRIMARY,
        )
        UserContact.objects.create(
            user=self.user_with_permissions,
            country_code=MOCK_COUNTRY_CODE,
            phone_number="0987654321",
            email="jane.doe@example.com",
            relation_type=UserContact.RelationTypeChoices.PRIMARY,
        )

        # Set up permissions
        UserPermission.objects.create(
            user=self.user_with_permissions,
            type=UserPermission.UserPermissionChoices.read_announcements
        )
        UserPermission.objects.create(
            user=self.user_with_permissions,
            type=UserPermission.UserPermissionChoices.write_announcements
        )

        # Create tokens
        self.token_without_perms = TokenManager.create_token(
            UserTokenPayload(
                user_id=str(self.user_without_permissions.id),
                user_name=self.user_without_permissions.first_name,
                user_permissions=[]
            )
        )

        self.token_with_perms = TokenManager.create_token(
            UserTokenPayload(
                user_id=str(self.user_with_permissions.id),
                user_name=self.user_with_permissions.first_name,
                user_permissions=[
                    UserPermission.UserPermissionChoices.read_announcements,
                    UserPermission.UserPermissionChoices.write_announcements
                ]
            )
        )

    def test_user_without_permissions_cannot_read_announcements(self):
        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + self.token_without_perms)
        url = reverse("announcement_list", args=[self.school.id])
        response = self.client.get(url)

        self.assertEqual(response.status_code, 403)

    def test_invalid_announcement(self):
        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + self.token_with_perms)
        url = reverse("announcement_list", args=[self.school.id])
        response = self.client.post(url, {
            "title": "Test school announcement",
            "body": "This is an announcement to test out this system",
            "scope": [{}]
        }, format="json")

        self.assertEqual(response.status_code, 400)
        self.assertIsNotNone(response.data["error"]["details"]["scope"])

        response = self.client.post(url, {
            "title": "Test school announcement",
            "body": "This is an announcement to test out this system",
            "scope": [
                { "scope": AnnouncementScope.ScopeContextChoices.all, },
                { "scope": AnnouncementScope.ScopeContextChoices.student, },
            ]
        }, format="json")

        self.assertEqual(response.status_code, 400)
        self.assertIsNotNone(response.data["error"]["details"]["scope"])

        response = self.client.post(url, {
            "title": "Test school announcement",
            "body": "This is an announcement to test out this system",
            "scope": [
                { "scope": AnnouncementScope.ScopeContextChoices.student, "filter_type": AnnouncementScope.ScopeFilterChoices.standard_division, "filter_content": "whatever"},
            ]
        }, format="json")

        self.assertEqual(response.status_code, 400)
        self.assertIsNotNone(response.data["error"]["details"]["scope"])

        response = self.client.post(url, {
            "title": "Test school announcement",
            "body": "This is an announcement to test out this system",
            "scope": [
                { "scope": AnnouncementScope.ScopeContextChoices.student, "filter_type": AnnouncementScope.ScopeFilterChoices.full_name, "filter_content": "foo"},
            ]
        }, format="json")

        self.assertEqual(response.status_code, 400)
        self.assertIsNotNone(response.data["error"]["details"]["scope"])

    def test_user_with_permissions_can_write_announcements(self):
        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + self.token_with_perms)
        url = reverse("announcement_list", args=[self.school.id])
        response = self.client.post(url, data={
            "title": "Test school announcement GOOD",
            "body": "This is an announcement to test out this system",
            "scope": [
                { "scope": AnnouncementScope.ScopeContextChoices.all, },
            ]
        }, format="json")
        self.assertEqual(response.status_code, 201)

    def test_user_can_update_their_announcements(self):
        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + self.token_with_perms)

        announcement = Announcement.objects.create(
            announcer=self.user_with_permissions,
            title="Old Announcement Title",
            body="Old Announcement Body"
        )
        AnnouncementScope.objects.create(announcement=announcement, scope=AnnouncementScope.ScopeContextChoices.student)

        url = reverse("announcement_detail", args=[self.school.id, announcement.id])
        response = self.client.put(url, data={
            "title": "Updated Announcement Title",
            "body": "Updated Announcement Body",
            "scope": [
                { "scope": AnnouncementScope.ScopeContextChoices.all, },
            ]
        }, format="json")

        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.data["title"], "Updated Announcement Title")
        self.assertEqual(response.data["body"], "Updated Announcement Body")

    def test_user_can_delete_their_announcements(self):
        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + self.token_with_perms)

        announcement = Announcement.objects.create(
            announcer=self.user_with_permissions,
            title="Announcement to Delete",
            body="This announcement will be deleted."
        )

        url = reverse("announcement_detail", args=[self.school.id, announcement.id])
        response = self.client.delete(url)
        self.assertEqual(response.status_code, 204)
        self.assertFalse(Announcement.objects.filter(id=announcement.id).exists())

    def test_user_can_create_announcement_with_attachment(self):
        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + self.token_with_perms)

        url = reverse("announcement_list", args=[self.school.id])
        response = self.client.post(url, data={
            "title": "Announcement with Attachment",
            "body": "This announcement has an attachment.",
            "scope": [
                { "scope": AnnouncementScope.ScopeContextChoices.all, },
            ],
            "attachments": [
                { "file_name": "test_doc.pdf", "file_path": "/path/to/test_doc.pdf", "file_type": Attachment.FileTypeChoices.pdf }
            ]
        }, format="json")

        self.assertEqual(response.status_code, 201)
        self.assertEqual(response.data["title"], "Announcement with Attachment")
        self.assertEqual(len(response.data["attachments"]), 1)
        self.assertEqual(response.data["attachments"][0]["file_name"], "test_doc.pdf")