from rest_framework.decorators import api_view, throttle_classes
from rest_framework.response import Response
from rest_framework import status

from services.TokenManager import TokenManager, UserTokenPayload

from .serializers import UserVerificationSerializer, UserLoginSerializer
from .models import UserContact
from api.exceptions import HTTPSerializerBadRequest, HTTPBadRequest, HTTPInternalError

from .throttling import OTPRequestThrottle, DisableThrottle

from services.otp_service import otp_service

@api_view(['POST'])
def user_login(request, school_id=None):
    serializer = UserLoginSerializer(data={
        "school_id": school_id,
        "phone_number": request.data["phone_number"]
    })

    if not serializer.is_valid():
        raise HTTPSerializerBadRequest(details=serializer.errors)
    
    phone_number = serializer.validated_data["phone_number"]
    
    otp_service.send_otp(phone_number)
    
    return Response({"message": f"Sent an OTP to the provided mobile number."}, status=status.HTTP_200_OK)

@api_view(['POST'])
def user_verify(request, school_id=None):
    serializer = UserVerificationSerializer(data=request.data)

    if not serializer.is_valid():
        raise HTTPSerializerBadRequest(details=serializer.errors)

    phone_number = serializer.validated_data.get("phone_number")
    otp = serializer.validated_data.get("otp")

    if not otp_service.verify_otp(phone_number, otp):
        raise HTTPBadRequest(message="Invalid OTP or OTP has expired")

    user_contact = UserContact.objects.filter(
        user__school_id=school_id,
        contact_data=phone_number,
        contact_type=UserContact.ContactType.PRIMARY
    ).first()

    if not user_contact:
        raise HTTPBadRequest(message="Couldn't find any primary contact with that number")

    user = user_contact.user
    token = TokenManager.create_token(
        UserTokenPayload(
            user_id=user.id, 
            user_name=f"{user.first_name} {user.last_name}", 
        )
    )
    return Response({"data": {"access_token": token}}, status=status.HTTP_200_OK)