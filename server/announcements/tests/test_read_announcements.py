from django.core.management import call_command
from django.urls import reverse
from rest_framework.test import APIClient
from django.test import TestCase

from users.models import User, School, StudentDetail, TeacherDetail
from classes.models import Class
from services.TokenManager import TokenManager, UserTokenPayload
from announcements.models import AnnouncementScope, Announcement
from announcements.serializers import AnnouncementSerializer

class AnnouncementCRUDTests(TestCase):
    def setUp(self):
        call_command("loaddata", "initial_classes")

        self.client = APIClient()
        self.school = School.objects.create(name="Jethalal Public School")
        self.another_school = School.objects.create(name="Ghasitaram Furfuri Nagar High School")

        # Create users
        self.admin = self.create_user("Admin", "User", User.UserType.ADMIN, self.school)
        self.teacher = self.create_user("Jane", "Smith", User.UserType.TEACHER, self.school)
        self.student = self.create_user("John", "Doe", User.UserType.STUDENT, self.school)

        self.teacher_of_another_school = self.create_user("Dr", "Jhatka", User.UserType.TEACHER, self.another_school)

        self.student_9a = self.create_student("Buzz", "Lightyear", "9A", self.school)
        self.student_9b = self.create_student("Woody", "Pride", "9B", self.school)
        self.student_9c = self.create_student("Chris P", "Bacon", "9C", self.school)

        # Create tokens
        self.student_token = self.create_token(self.student)
        self.teacher_token = self.create_token(self.teacher)
        self.teacher_of_another_school_token = self.create_token(self.teacher_of_another_school)
        self.student_9a_token = self.create_token(self.student_9a)
        self.student_9b_token = self.create_token(self.student_9b)
        self.student_9c_token = self.create_token(self.student_9c)
        self.admin_token = self.create_token(self.admin)

    def create_user(self, first_name, last_name, user_type, school):
        return User.objects.create(
            school=school,
            first_name=first_name,
            last_name=last_name,
            user_type=user_type
        )

    def create_student(self, first_name, last_name, division, school):
        student = User.objects.create(
            school=school,
            first_name=first_name,
            last_name=last_name,
            user_type=User.UserType.STUDENT
        )
        StudentDetail.objects.create(
            user=student,
            student_class=Class.get_class_by_standard_division(division)
        )
        return student

    def create_token(self, user):
        return TokenManager.create_token(
            UserTokenPayload(
                user_id=user.id,
                user_name=user.first_name
            )
        )

    def create_announcements(self, announcer, count, title="Announcement", scope_context="all", **kwargs):
        for i in range(1, count + 1):
            announcement = Announcement.objects.create(
                announcer=announcer,
                title=f"{title} #{i}",
                body="the quick brown fox jumps over the lazy dog"
            )
            AnnouncementScope.objects.create(
                announcement=announcement,
                scope_context=scope_context,
                **kwargs,
            )

    def test_teacher_and_admin_can_create_announcement(self):
        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + self.teacher_token)

        response = self.client.post(reverse("announcements", kwargs={"school_id": self.school.id}), {
            "title": "Hello World!",
            "body": "How are you matey?",
            "scope": [{ "scope_context": "all"}]
        }, format="json")

        self.assertEqual(response.status_code, 201)

    def test_teacher_of_another_school_cannot_make_announcements(self):
        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + self.teacher_of_another_school_token)
        response = self.client.post(reverse("announcements", kwargs={"school_id": self.school.id}), {
            "title": "Hello World!",
            "body": "How are you matey?",
            "scope": [{ "scope_context": "all"}]
        }, format="json")

        self.assertEqual(response.status_code, 403)

    def test_student_cannot_make_announcements(self):
        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + self.student_token)
        response = self.client.post(reverse("announcements", kwargs={"school_id": self.school.id}), {
            "title": "Hello World!",
            "body": "How are you matey?",
            "scope": [{ "scope_context": "all"}]
        }, format="json")

        self.assertEqual(response.status_code, 403)

    def test_teacher_can_view_all_announcements_not_theirs(self):
        self.create_announcements(self.admin, 5)
        self.create_announcements(self.teacher, 1, title="Announcement BY TEACHER", scope_context="all")


        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + self.teacher_token)
        response = self.client.get(reverse("announcements", kwargs={"school_id": self.school.id}))

        self.assertEqual(len(response.data["data"]), 5)

        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + self.teacher_of_another_school_token)
        response = self.client.get(reverse("announcements", kwargs={"school_id": self.another_school.id}))

        self.assertEqual(len(response.data["data"]), 0)

    def test_student_can_view_announcement_by_standard_division(self):
        self.create_announcements(self.teacher, 1, title="Announcement BY TEACHER", scope_context="student", filter_type="standard_division", filter_content="9a")

        self.create_announcements(self.teacher, 1, title="Announcement BY TEACHER", scope_context="student", filter_type="standard_division", filter_content="9b")

        self.create_announcements(self.teacher, 1, title="Announcement BY TEACHER", scope_context="student", filter_type="standard_division", filter_content="9c")


        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + self.student_9a_token)
        response = self.client.get(reverse("announcements", kwargs={"school_id": self.school.id}))

        self.assertEqual(len(response.data["data"]), 1)

        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + self.student_9b_token)
        response = self.client.get(reverse("announcements", kwargs={"school_id": self.school.id}))

        self.assertEqual(len(response.data["data"]), 1)

        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + self.student_9c_token)
        response = self.client.get(reverse("announcements", kwargs={"school_id": self.school.id}))

        self.assertEqual(len(response.data["data"]), 1)

    def test_student_can_view_announcement_by_standard(self):
        self.create_announcements(self.teacher, 5, title="Announcement BY TEACHER", scope_context="student", filter_type="standard", filter_content="9")

        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + self.student_9a_token)
        response = self.client.get(reverse("announcements", kwargs={"school_id": self.school.id}))

        self.assertEqual(len(response.data["data"]), 5)

        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + self.student_9b_token)
        response = self.client.get(reverse("announcements", kwargs={"school_id": self.school.id}))

        self.assertEqual(len(response.data["data"]), 5)

        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + self.student_9c_token)
        response = self.client.get(reverse("announcements", kwargs={"school_id": self.school.id}))

        self.assertEqual(len(response.data["data"]), 5)

    def test_teacher_can_view_announcements_for_all_students(self):
        self.create_announcements(self.admin, 5, title="Announcement BY ADMIN", scope_context="student", filter_type="standard", filter_content="9")

        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + self.teacher_token)
        response = self.client.get(reverse("announcements", kwargs={"school_id": self.school.id}))

        self.assertEqual(len(response.data["data"]), 5)

    def test_teacher_get_individual_announcement(self):
        self.create_announcements(self.admin, 1, title="Announcement BY ADMIN", scope_context="student", filter_type="standard", filter_content="9")

        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + self.teacher_token)
        response = self.client.get(reverse("announcement", kwargs={"school_id": self.school.id, "announcement_id": 1}))

        self.assertEqual(response.status_code, 200)
