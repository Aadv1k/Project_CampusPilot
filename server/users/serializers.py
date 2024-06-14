from rest_framework import serializers
from api.constants import COUNTRY_CODE_CHOICES

class UserLoginSerializer(serializers.Serializer):
    """
    Serializer for user login data.

    Fields:
    - phone_number: CharField with max length 10, required.
    - country_code: ChoiceField with choices from COUNTRY_CODE_CHOICES, required.
    - device_token: CharField with max length 255, optional and allow blank.

    Validation:
    - phone_number: Must contain only digits.
    """

    phone_number = serializers.CharField(max_length=10, required=True)
    country_code = serializers.ChoiceField(choices=COUNTRY_CODE_CHOICES, required=True)
    device_token = serializers.CharField(max_length=255, required=False, allow_blank=True)

    def validate_phone_number(self, value):
        """
        Validate that phone_number contains only digits.
        """
        if not value.isdigit():
            raise serializers.ValidationError("Phone number must contain only digits.")
        return value

class UserVerificationSerializer(serializers.Serializer):
    """
    Serializer for user OTP verification.

    Fields:
    - phone_number: CharField with max length 10, required.
    - otp: CharField for OTP verification, required.

    Validation:
    - phone_number: Must contain only digits.
    - otp: Must be a string with a length of 6 characters.
    """

    phone_number = serializers.CharField(max_length=10, required=True)
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