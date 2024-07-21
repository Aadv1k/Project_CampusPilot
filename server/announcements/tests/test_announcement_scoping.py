from users.models import User, StudentDetail, TeacherDetail
from classes.models import Class
from schools.models import School
from announcements.models import AnnouncementScope, Announcement

from django.urls import reverse
from django.core.management import call_command
from django.test import TestCase
from rest_framework.test import APIClient

from services.TokenManager import TokenManager, UserTokenPayload

class AnnouncementScopingTest(TestCase):
    def setUp(self):
        call_command("loaddata", "initial_classes")

        self.client = APIClient()
        self.school = School.objects.create(
            name="Jethalal Public School",
            address="123 Main St, Springfield",
            email="contact@jethalal.edu",
            website_url="http://www.jethalal.edu",
            logo_url="http://www.jethalal.edu/logo.png"
        )

        # Create students
        self.student_10a = User.objects.create(
            school=self.school,
            first_name="Rohit",
            last_name="Sharma",
            user_type=User.UserType.student
        )
        StudentDetail.objects.create(
            user=self.student_10a,
            student_class=Class.objects.get(standard=10, division="a")
        )

        self.student_10b = User.objects.create(
            school=self.school,
            first_name="Virat",
            last_name="Kohli",
            user_type=User.UserType.student
        )
        StudentDetail.objects.create(
            user=self.student_10b,
            student_class=Class.objects.get(standard=10, division="b")
        )

        self.student_11a = User.objects.create(
            school=self.school,
            first_name="Sachin",
            last_name="Tendulkar",
            user_type=User.UserType.student
        )
        StudentDetail.objects.create(
            user=self.student_11a,
            student_class=Class.objects.get(standard=11, division="a")
        )

        # Create teachers
        self.teacher_math = User.objects.create(
            school=self.school,
            first_name="Anil",
            last_name="Kumble",
            user_type=User.UserType.teacher
        )
        TeacherDetail.objects.create(
            user=self.teacher_math
        )

        self.teacher_science = User.objects.create(
            school=self.school,
            first_name="Kapil",
            last_name="Dev",
            user_type=User.UserType.teacher
        )
        TeacherDetail.objects.create(
            user=self.teacher_science
        )

        # Create admin
        self.admin = User.objects.create(
            school=self.school,
            first_name="Mahendra",
            last_name="Dhoni",
            user_type=User.UserType.admin
        )

        # Generate tokens for each user
        self.student_10a_token = TokenManager.create_token(UserTokenPayload(user_id=str(self.student_10a.id), user_name=self.student_10a.first_name))
        self.student_10b_token = TokenManager.create_token(UserTokenPayload(user_id=str(self.student_10b.id), user_name=self.student_10b.first_name))
        self.student_11a_token = TokenManager.create_token(UserTokenPayload(user_id=str(self.student_11a.id), user_name=self.student_11a.first_name))
        self.teacher_math_token = TokenManager.create_token(UserTokenPayload(user_id=str(self.teacher_math.id), user_name=self.teacher_math.first_name))
        self.teacher_science_token = TokenManager.create_token(UserTokenPayload(user_id=str(self.teacher_science.id), user_name=self.teacher_science.first_name))
        self.admin_token = TokenManager.create_token(UserTokenPayload(user_id=str(self.admin.id), user_name=self.admin.first_name))

        # Create announcements with different scopes
        announcer = self.teacher_math  # Using math teacher as announcer

        ann_scopes = [
            (AnnouncementScope.ScopeContextChoices.all, None, None),
            (AnnouncementScope.ScopeContextChoices.student, AnnouncementScope.ScopeFilterChoices.standard_division, "10a"),
            (AnnouncementScope.ScopeContextChoices.student, AnnouncementScope.ScopeFilterChoices.full_name, "Rohit Sharma"),
            (AnnouncementScope.ScopeContextChoices.teacher, None, None),
        ]

        for i, (scope_context, filter_type, filter_content) in enumerate(ann_scopes, start=1):
            announcement = Announcement.objects.create(
                announcer=announcer,
                title=f"Announcement {i}",
                body=f"This is the body of announcement {i}."
            )
            AnnouncementScope.objects.create(
                announcement=announcement,
                scope_context=scope_context,
                filter_type=filter_type,
                filter_content=filter_content
            )

    def test_student_receives_announcement(self):
        pass

    def test_teacher_announcement_should_not_be_visible_to_student(self):
        pass