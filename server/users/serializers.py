from rest_framework import serializers
from datetime import datetime, timedelta
from api.OTPStore import otp_store_singleton_factory

from .models import UserContact

otp_store = otp_store_singleton_factory("memory")


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
        phone_number = data['phone_number']
        received_otp = data['otp']

        full_phone_number = f"{data['country_code']}{data['phone_number']}"

        stored_data = otp_store.retrieve(full_phone_number)
        if not stored_data:
            raise serializers.ValidationError("OTP not found. Please request a new OTP.")

        stored_otp, created_at = stored_data.otp, stored_data.created_at

        expiry_time = created_at + timedelta(minutes=5)
        current_time = datetime.now()
        if current_time > expiry_time:
            otp_store.delete(full_phone_number)
            raise serializers.ValidationError("OTP has expired. Please request a new OTP.")

        if stored_otp != received_otp:
            raise serializers.ValidationError("Sorry, the OTP you sent didn't match. Please try again later.")

        otp_store.delete(full_phone_number)

        return data