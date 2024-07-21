from rest_framework import serializers
from django.core.validators import RegexValidator
from .models import UserContact, School, User

from services.otp_service import otp_manager

class NormalizedPhoneNumberField(serializers.CharField):
    VALID_COUNTRY_CODE = '+91'

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.validators.append(RegexValidator(
            regex=r'^(\+91|91)?\d{10}$',
            message="Phone number must be a valid 10-digit number with optional +91 prefix"
        ))

    def to_internal_value(self, data):
        cleaned_data = ''.join(filter(lambda x: x.isdigit() or x == '+', data))

        if cleaned_data.startswith(self.VALID_COUNTRY_CODE):
            phone_number = cleaned_data[3:]
        elif cleaned_data.startswith('91'):
            phone_number = cleaned_data[2:]
        else:
            phone_number = cleaned_data

        if len(phone_number) != 10:
            raise serializers.ValidationError("Phone number must be exactly 10 digits long")

        return f"{self.VALID_COUNTRY_CODE}{phone_number}"

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        exclude = ["school"]

class UserLoginSerializer(serializers.Serializer):
    school_id = serializers.IntegerField()
    phone_number = NormalizedPhoneNumberField()

    def validate(self, data):
        school_id = data.get('school_id')
        phone_number = data.get('phone_number')

        if not School.objects.filter(id=school_id).exists():
            raise serializers.ValidationError("Invalid school ID.")

        if not UserContact.objects.filter(user__school_id=school_id,
            contact_type=UserContact.ContactType.PRIMARY,
            contact_format=UserContact.ContactFormat.PHONE_NUMBER,
            contact_data=phone_number
        ).exists():
            raise serializers.ValidationError("The phone number does not exist for the specified school.")

        return data

class UserVerificationSerializer(serializers.Serializer):
    phone_number = NormalizedPhoneNumberField(max_length=15, required=True)
    otp = serializers.CharField(required=True)

    def validate_otp(self, value):
        if len(value) != 6 or not value.isdigit():
            raise serializers.ValidationError("OTP must be a 6-digit number.")
        return value