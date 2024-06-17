from rest_framework import serializers
from datetime import datetime, timedelta
from utils.OTPManager import otp_manager

from .models import UserContact

class UserLoginSerializer(serializers.Serializer):
    """
    Serializer for user login data.

    Fields:
    - phone_number: CharField with max length 15, required.
    - country_code: CharField with max length 3, required.
    - device_token: CharField with max length 255, optional and allow blank.

    Validation:
    - phone_number: Must contain only digits.
    """

    phone_number = serializers.CharField(max_length=15, required=True)
    country_code = serializers.CharField(max_length=3, required=True)
    device_token = serializers.CharField(max_length=255, required=False, allow_blank=True)

    def validate_phone_number(self, value):
        """
        Validate that phone_number contains only digits.
        """
        if not value.isdigit():
            raise serializers.ValidationError("Phone number must contain only digits.")
        return value

    def validate(self, data):
        """
        Check if the phone number with the country code exists.
        """
        phone_number = data.get('phone_number')
        country_code = data.get('country_code')
        
        if not UserContact.objects.filter(phone_number=phone_number, country_code=country_code).exists():
            raise serializers.ValidationError("The phone number with the specified country code does not exist.")
        
        return data


class UserVerificationSerializer(serializers.Serializer):
    """
    Serializer for user OTP verification.

    Fields:
    - phone_number: CharField with max length 15, required.
    - country_code: CharField with max length 3, required.
    - otp: CharField for OTP verification, required.

    Validation:
    - phone_number: Must contain only digits.
    - otp: Must be a string with a length of 6 characters.
    """

    country_code = serializers.CharField(max_length=3, required=True)
    phone_number = serializers.CharField(max_length=15, required=True)
    otp = serializers.CharField(required=True)

    def validate_phone_number(self, value):
        """
        Validate that phone_number contains only digits.
        """
        if not value.isdigit():
            raise serializers.ValidationError("Phone number must contain only digits.")
        return value

    def validate_otp(self, value):
        """
        Validate OTP format (exactly 6 characters).
        """
        if len(value) != 6 or not value.isdigit():
            raise serializers.ValidationError("OTP must be a 6-digit number.")
        return value

    def validate(self, data):
        """
        Validate the OTP against stored OTP in memory store.
        """
        received_otp = data['otp']

        full_phone_number = f"{data['country_code']}{data['phone_number']}"


        if not otp_manager.is_otp_valid(full_phone_number, received_otp):
            raise serializers.ValidationError("Sorry, the OTP you provided wasn't valid. Please try again later.")

        otp_manager.delete_otp(full_phone_number)

        return data