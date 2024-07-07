from django.test import TestCase
from django.urls import reverse

from rest_framework.test import APIClient

from users.models import User
from schools.models import School
from classes.models import Class

from announcements.models import AnnouncementScope
from announcements.serializers import AnnouncementSerializer

from utils.TokenManager import TokenManager, UserTokenPayload

class AnnouncementCRUDTests(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.school = School.objects.create(
            name="Jethalal Public School",
            address="123 Main St, Springfield",
            email="contact@jethalal.edu",
            website_url="http://www.jethalal.edu",
            logo_url="http://www.jethalal.edu/logo.png"
        )

        Class.objects.create(
            school=self.school,
            standard=10, division="A"
        )

        Class.objects.create(
            school=self.school,
            standard=10, division="B"
        )

        Class.objects.create(
            school=self.school,
            standard=10, division="C"
        )

        self.student = User.objects.create(
            school=self.school,
            first_name="John", last_name="Doe",
            user_type="student"
        )
        self.student_token = TokenManager.create_token(
            UserTokenPayload(
                user_id=self.student.id,
                user_name=self.student.first_name,
            )
        )

        self.teacher = User.objects.create(
            school=self.school,
            first_name="Jane", last_name="Smith",
            user_type="teacher"
        )
        self.teacher_token = TokenManager.create_token(
            UserTokenPayload(
                user_id=self.teacher.id,
                user_name=self.teacher.first_name,
            )
        )

        self.admin = User.objects.create(
            school=self.school,
            first_name="Admin", last_name="User",
            user_type="admin"
        )
        self.admin_token = TokenManager.create_token(
            UserTokenPayload(
                user_id=self.admin.id,
                user_name=self.admin.first_name,
            )
        )

    # def test_user_can_read_announcements(self):
    #     pass

    def test_announcement_with_invalid_format_is_disallowed(self):
        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + self.teacher_token)
        url = reverse("announcement_list", args=[self.school.id])

        res = self.client.post(url, { })

        self.assertEqual(res.status_code, 400)

        res = self.client.post(url, { 
            "title": "Bad announcement example",
            "body": "this is an example of invalid announcement",
            "scope": [{ }]
        }, format="json")
        self.assertEqual(res.status_code, 400)

        res = self.client.post(url, { 
            "title": "Bad announcement example",
            "body": "this is an example of invalid announcement",
            "scope": [{ 
                "scope_context": "student",
                "filter_type": "standard",
                "filter_content": "9th"
            }]
        }, format="json")
        self.assertEqual(res.status_code, 400)

        res = self.client.post(url, { 
            "title": "Bad announcement example",
            "body": "this is an example of invalid announcement",
            "scope": [{ 
                "scope_context": "student",
                "filter_type": "standard_division",
                "filter_content": "1000"
            }]
        }, format="json")
        self.assertEqual(res.status_code, 400)

        res = self.client.post(url, { 
            "title": "Bad announcement example",
            "body": "this is an example of invalid announcement",
            "scope": [
            { 
                "scope_context": "student",
                "filter_type": "standard_division",
                "filter_content": "10A"
            },

            { 
                "scope_context": "student",
                "filter_type": "standard",
                "filter_content": "10"
            }
            ]
        }, format="json")
        self.assertEqual(res.status_code, 400)


    def test_teacher_can_create_announcements(self):
        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + self.teacher_token)
        url = reverse("announcement_list", args=[self.school.id])
        res = self.client.post(url, { 
            "title": "Good announcement example",
            "body": "this is an example of good announcement",
            "scope": [
                {
                    "scope_context": AnnouncementScope.ScopeContextChoices.student,
                    "filter_type": AnnouncementScope.ScopeFilterChoices.standard_division,
                    "filter_content": "10a"
                },
             ]
        }, format="json")

        self.assertEqual(res.status_code, 201)
        

    def test_teacher_can_update_their_announcements(self):
        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + self.teacher_token)
        s = AnnouncementSerializer(data={
            "announcer": self.teacher.id,
            "title": "OLD",
            "body": "this is an example of old announcement",
            "scope": [{ "scope_context": AnnouncementScope.ScopeContextChoices.student, }]
        })
        s.is_valid(raise_exception=True)
        ann = s.save()

        url = reverse("announcement_detail", args=[self.school.id, ann.id])
        response = self.client.put(url, data={
            "title": "Updated Announcement Title",
            "body": "Updated Announcement Body",
            "scope": [{"scope_context": AnnouncementScope.ScopeContextChoices.all}],
        }, format="json")
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.data["title"], "Updated Announcement Title")
        self.assertEqual(response.data["body"], "Updated Announcement Body")

    def test_teacher_can_delete_their_announcements(self):
        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + self.teacher_token)
        s = AnnouncementSerializer(data={
            "announcer": self.teacher.id,
            "title": "delete me",
            "body": "delete me pls",
            "scope": [{ "scope_context": AnnouncementScope.ScopeContextChoices.student, }]
        })
        s.is_valid(raise_exception=True)
        ann = s.save()

        url = reverse("announcement_detail", args=[self.school.id, ann.id])
        response = self.client.delete(url)
        self.assertEqual(response.status_code, 204)
    
    def test_student_cannot_create_announcements(self):
        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + self.student_token)
        url = reverse("announcement_list", args=[self.school.id])
        res = self.client.post(url, { 
            "title": "Good announcement example",
            "body": "this is an example of good announcement",
            "scope": [ { "scope_context": AnnouncementScope.ScopeContextChoices.student, }, ]
        }, format="json")
        self.assertEqual(res.status_code, 403)

    def test_student_cannot_delete_announcements(self):
        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + self.student_token)
        s = AnnouncementSerializer(data={
            "announcer": self.teacher.id,
            "title": "delete me",
            "body": "delete me pls",
            "scope": [{ "scope_context": AnnouncementScope.ScopeContextChoices.student, }]
        })
        s.is_valid(raise_exception=True)
        ann = s.save()

        url = reverse("announcement_detail", args=[self.school.id, ann.id])
        response = self.client.delete(url)
        self.assertEqual(response.status_code, 403)

    def test_admin_can_delete_all_announcements(self):
        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + self.admin_token)
        s = AnnouncementSerializer(data={
            "announcer": self.teacher.id,
            "title": "delete me",
            "body": "delete me pls",
            "scope": [{ "scope_context": AnnouncementScope.ScopeContextChoices.student, }]
        })
        s.is_valid(raise_exception=True)
        ann = s.save()

        url = reverse("announcement_detail", args=[self.school.id, ann.id])
        response = self.client.delete(url)
        self.assertEqual(response.status_code, 204)
