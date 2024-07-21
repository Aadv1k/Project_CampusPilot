from rest_framework.test import APIRequestFactory
from django.test import TestCase
from users.models import User, UserContact, School
from services.otp_service import otp_manager
from services.TokenManager import TokenManager, UserTokenPayload
from rest_framework.test import APIClient
from django.urls import reverse

MOCK_PHONE_NUMBER = "+917555750826"
MOCK_PHONE_NUMBER_2 = "+918555750811"

class UserTests(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.school = School.objects.create(
            name="Jethalal Public School",
        )
        user = User.objects.create(
            school=self.school,
            first_name="Robin",
            last_name="Sharma",
            user_type=User.UserType.STUDENT,
        )
        UserContact.objects.create(
            user=user,
            contact_type=UserContact.ContactType.PRIMARY,
            contact_format=UserContact.ContactFormat.PHONE_NUMBER,
            contact_description="primary",
            contact_data=MOCK_PHONE_NUMBER,
        )
        user2 = User.objects.create(
            school=self.school,
            first_name="Mr",
            last_name="India",
            user_type=User.UserType.STUDENT,
        )
        UserContact.objects.create(
            user=user2,
            contact_type=UserContact.ContactType.PRIMARY,
            contact_format=UserContact.ContactFormat.PHONE_NUMBER,
            contact_data=MOCK_PHONE_NUMBER_2,
        )
        UserContact.objects.create(
            user=user2,
            contact_type=UserContact.ContactType.SECONDARY,
            contact_format=UserContact.ContactFormat.PHONE_NUMBER,
            contact_data=MOCK_PHONE_NUMBER,
        )
        self.user = user
        self.user2 = user2

    def test_user_bad_login(self):
        response = self.client.post(reverse("user_login", kwargs={"school_id":self.school.id}), {
            "phone_number": "29ihehbwhbeb",
        })
        self.assertEqual(response.status_code, 400)
        self.assertIsNotNone(response.data["error"]["details"]["phone_number"])

    def test_non_existent_user_login(self):
        response = self.client.post(reverse("user_login", kwargs={"school_id":self.school.id}), {
            "phone_number": "+910000000000",
        })
        self.assertEqual(response.status_code, 400)

    def test_successful_login(self):
        response = self.client.post(reverse("user_login", kwargs={"school_id":self.school.id}), {
            "phone_number": MOCK_PHONE_NUMBER,
        })
        self.assertEqual(response.status_code, 200)

    def test_otp_verification(self):
        response = self.client.post(reverse("user_login", kwargs={"school_id":self.school.id}), {
            "phone_number": MOCK_PHONE_NUMBER_2,
        })

        self.assertEqual(response.status_code, 200)

        otp, _ = otp_manager.kv_store.get(MOCK_PHONE_NUMBER_2).split(":")

        response = self.client.post(reverse("user_verify", kwargs={"school_id":self.school.id}), {
            "phone_number": MOCK_PHONE_NUMBER_2,
            "otp": otp
        })

        self.assertEqual(response.status_code, 200)

    def test_otp_not_sent_to_secondary_number(self):
        response = self.client.post(reverse("user_login", kwargs={"school_id":self.school.id}), {
            "phone_number": MOCK_PHONE_NUMBER_2,
        })

        self.assertEqual(response.status_code, 200)

        otp, _ = otp_manager.kv_store.get(MOCK_PHONE_NUMBER_2).split(":")

        response = self.client.post(reverse("user_verify", kwargs={"school_id":self.school.id}), {
            "phone_number": MOCK_PHONE_NUMBER,
            "otp": otp
        })

        self.assertEqual(response.status_code, 400)
