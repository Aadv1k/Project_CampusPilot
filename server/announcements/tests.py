from rest_framework.test import APIRequestFactory
from django.test import TestCase
from schools.models import School 
from users.models import User, UserPermission, UserContact
from announcements.models import AnnouncementScope, Announcement, Attachment
from utils.TokenManager import TokenManager, UserTokenPayload
from rest_framework.test import APIClient
from django.urls import reverse

MOCK_PHONE = "1234567890"
MOCK_COUNTRY_CODE = "91"

class AnnouncementTests(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.school = School.objects.create(
            name="Jethalal Public School",
            email="contact@jethalal.edu",
        )
        self.student_without_permissions = User.objects.create(
            school=self.school,
            first_name="John",
            last_name="Doe",
            user_type=User.UserType.student,
        )
        self.student_readonly_permissions = User.objects.create(
            school=self.school,
            first_name="Ravi",
            last_name="Shankar",
            user_type=User.UserType.student,
        )
        UserPermission.objects.create(
            user=self.student_readonly_permissions,
            type=UserPermission.UserPermissionChoices.read_announcements
        )
        self.student_token_readonly = TokenManager.create_token(
            UserTokenPayload(user_id=self.student_readonly_permissions.id, user_name=self.student_readonly_permissions.first_name, 
                            user_permissions=[ UserPermission.UserPermissionChoices.read_announcements, ])
        )

        self.teacher_with_permissions = User.objects.create(
            school=self.school,
            first_name="Jane",
            last_name="Doe",
            user_type=User.UserType.teacher,
        )
        UserContact.objects.create(
            user=self.student_without_permissions,
            country_code=MOCK_COUNTRY_CODE,
            phone_number=MOCK_PHONE,
            email="john.doe@example.com",
            relation_type=UserContact.RelationTypeChoices.PRIMARY,
        )
        UserContact.objects.create(
            user=self.teacher_with_permissions,
            country_code=MOCK_COUNTRY_CODE,
            phone_number="0987654321",
            email="jane.doe@example.com",
            relation_type=UserContact.RelationTypeChoices.PRIMARY,
        )
        UserPermission.objects.create(
            user=self.teacher_with_permissions,
            type=UserPermission.UserPermissionChoices.read_announcements
        )
        UserPermission.objects.create(
            user=self.teacher_with_permissions,
            type=UserPermission.UserPermissionChoices.write_announcements
        )
        self.token_without_perms = TokenManager.create_token(
            UserTokenPayload(
                user_id=str(self.student_without_permissions.id),
                user_name=self.student_without_permissions.first_name,
                user_permissions=[]
            )
        )
        self.token_with_perms = TokenManager.create_token(
            UserTokenPayload(
                user_id=str(self.teacher_with_permissions.id),
                user_name=self.teacher_with_permissions.first_name,
                user_permissions=[
                    UserPermission.UserPermissionChoices.read_announcements,
                    UserPermission.UserPermissionChoices.write_announcements
                ]
            )
        )

        for i in range(15):
            ann = Announcement.objects.create(
                announcer=self.teacher_with_permissions,
                title=f"Announcement {i + 1}",
                body=f"This is announcement number {i + 1}",
            )

            AnnouncementScope.objects.create(
                announcement=ann,
                scope_context=AnnouncementScope.ScopeContextChoices.all
            )


            announcement_only_for_teachers = Announcement.objects.create(
                announcer=self.teacher_with_permissions,
                title=f"VERY IMPORTANT",
                body=f"This announcement is only for teachers!",
            )

            AnnouncementScope.objects.create(
                announcement=announcement_only_for_teachers,
                scope_context=AnnouncementScope.ScopeContextChoices.teacher
            )
        

    def test_user_without_permissions_cannot_read_announcements(self):
        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + self.token_without_perms)
        url = reverse("announcement_list", args=[self.school.id])
        response = self.client.get(url)
        self.assertEqual(response.status_code, 403)


    def test_invalid_scope_announcement(self):
        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + self.token_with_perms)
        url = reverse("announcement_list", args=[self.school.id])

        response = self.client.post(url, {
            "title": "foo",
            "body": "bar",
            "scope": [{ 
                "scope_context": "student",
                "filter_type": "standard",
                "filter_content": "abcd",
            }]
        }, format="json")

        self.assertEqual(response.status_code, 400)

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
                {"scope_context": "ALL"},
                {"scope_context": "STUDENT"},
            ]
        }, format="json")
        self.assertEqual(response.status_code, 400)

        response = self.client.post(url, {
            "title": "Test school announcement",
            "body": "This is an announcement to test out this system",
            "scope": [
                {"scope_context": "Student", "filter_type": AnnouncementScope.ScopeFilterChoices.standard_division, "filter_content": "whatever"},
            ]
        }, format="json")
        self.assertEqual(response.status_code, 400)
        self.assertIsNotNone(response.data["error"]["details"]["scope"])

        response = self.client.post(url, {
            "title": "Test school announcement",
            "body": "This is an announcement to test out this system",
            "scope": [
                {"scope_context": AnnouncementScope.ScopeContextChoices.student, "filter_type": AnnouncementScope.ScopeFilterChoices.full_name, "filter_content": "foo"},
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
            "scope": [{"scope_context": AnnouncementScope.ScopeContextChoices.all}],
        }, format="json")
        self.assertEqual(response.status_code, 201)

    def test_user_can_update_their_announcements(self):
        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + self.token_with_perms)
        announcement = Announcement.objects.create(
            announcer=self.teacher_with_permissions,
            title="Old Announcement Title",
            body="Old Announcement Body"
        )
        AnnouncementScope.objects.create(announcement=announcement, scope_context=AnnouncementScope.ScopeContextChoices.student)
        url = reverse("announcement_detail", args=[self.school.id, announcement.id])
        response = self.client.put(url, data={
            "title": "Updated Announcement Title",
            "body": "Updated Announcement Body",
            "scope": [{"scope_context": AnnouncementScope.ScopeContextChoices.all}],
        }, format="json")
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.data["title"], "Updated Announcement Title")
        self.assertEqual(response.data["body"], "Updated Announcement Body")

    def test_user_can_delete_their_announcements(self):
        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + self.token_with_perms)
        announcement = Announcement.objects.create(
            announcer=self.teacher_with_permissions,
            title="Announcement to Delete",
            body="This announcement will be deleted."
        )
        url = reverse("announcement_detail", args=[self.school.id, announcement.id])
        response = self.client.delete(url)
        self.assertEqual(response.status_code, 204)
        self.assertFalse(Announcement.objects.filter(id=announcement.id).exists())

    def test_pagination(self):
            self.client.credentials(HTTP_AUTHORIZATION="Bearer " + self.token_with_perms)
            url = reverse("announcement_list", args=[self.school.id])

            # Request the first page
            response = self.client.get(url)
            self.assertEqual(response.status_code, 200)
            self.assertEqual(len(response.data["results"]), 10)

            next_page_url = response.data["next"]
            self.assertIsNotNone(next_page_url)

            response = self.client.get(next_page_url)
            self.assertEqual(response.status_code, 200)
            self.assertEqual(len(response.data["results"]), 5)

    def test_student_should_not_see_announcement_for_teachers(self):
        self.client.credentials(HTTP_AUTHORIZATION="Bearer " + self.student_token_readonly)
        url = reverse("announcement_list", args=[self.school.id])

        response = self.client.get(url)
        print(self.teacher_with_permissions.permissions)
        self.assertEqual(response.status_code, 200)