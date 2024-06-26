from rest_framework.decorators import api_view, throttle_classes
from rest_framework.response import Response
from rest_framework import status

from django.conf import settings

import random

from utils.TokenManager import TokenManager, UserTokenPayload 

from .serializers import UserVerificationSerializer, UserLoginSerializer
from .models import UserContact
from api.exceptions import HTTPSerializerBadRequest, HTTPBadRequest

from .throttling import OTPRequestThrottle, DisableThrottle

from utils.OTPManager import otp_manager  

@api_view(['POST'])
@throttle_classes([DisableThrottle if settings.TESTING else OTPRequestThrottle])
def user_login(request):
    serializer = UserLoginSerializer(data=request.data)

    if not serializer.is_valid():
        raise HTTPSerializerBadRequest(details=serializer.errors)

    full_phone_number = f'{serializer.validated_data.get("country_code")}{serializer.validated_data.get("phone_number")}'

    otp = otp_manager.create_and_store_otp(full_phone_number)

    # TODO: actually send the OTP messagve to the user 

    return Response({"message": f"Sent an OTP to the provided mobile number."}, status=status.HTTP_200_OK)

@api_view(['POST'])
def user_verify(request):
    serializer = UserVerificationSerializer(data=request.data)
    if not serializer.is_valid():
        raise HTTPSerializerBadRequest(details=serializer.errors)

    phone_number = serializer.validated_data.get("phone_number")
    country_code = serializer.validated_data.get("country_code")

    user_contact = UserContact.objects.filter(
        phone_number=phone_number,
        country_code=country_code,
    ).first()

    if not user_contact:
        raise HTTPBadRequest(message="User not found for the provided phone number and country code.")

    user = user_contact.user
    token = TokenManager.create_token(
        UserTokenPayload(
            user_id=user.id, 
            user_name=f"{user.first_name} {user.last_name}", 
            user_permissions= [perm.type for perm in user.permissions.all()]
            )
        )

    return Response({ "access_token": token }, status=status.HTTP_200_OK)