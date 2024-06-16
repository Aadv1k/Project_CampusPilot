from rest_framework.test import APIRequestFactory
from django.test import TestCase

from schools.models import School 

from users.models import User, UserPermission, UserContact

from .OTPStore import otp_store_singleton_factory

from rest_framework.test import APIClient

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
        response = self.client.post("/api/users/login", {
            "phone_number": "29ihehbwhbeb",
            "country_code": "2292"
        })

        self.assertEqual(response.status_code, 400)
        self.assertIsNotNone(response.data["error"]["details"]["phone_number"])
        self.assertIsNotNone(response.data["error"]["details"]["country_code"])

    def test_non_existent_user_login(self):
        response = self.client.post("/api/users/login", {
            "phone_number": "1800801920",
            "country_code": "44"
        })
        self.assertEqual(response.status_code, 400)
    
    def test_successful_login(self):
        response = self.client.post("/api/users/login", {
            "phone_number": MOCK_PHONE,
            "country_code":MOCK_COUNTRY_CODE
        })
        self.assertEqual(response.status_code, 200)

    def test_otp_verification(self):
        response = self.client.post("/api/users/login", {
            "phone_number": MOCK_PHONE,
            "country_code":MOCK_COUNTRY_CODE
        })

        otp_store = otp_store_singleton_factory("memory")
        generated_otp = otp_store.retrieve(f"{MOCK_COUNTRY_CODE}{MOCK_PHONE}").otp

        response = self.client.post("/api/users/otp_verify", {
            "phone_number": MOCK_PHONE,
            "country_code": MOCK_COUNTRY_CODE,
            "otp": generated_otp
        })
        
        self.assertEqual(response.status_code, 200)
        self.assertIsNotNone(response.data.get("access_token"))