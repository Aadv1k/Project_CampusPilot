from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from datetime import datetime, timedelta, timezone

from django.conf import settings
from django.db.models import F
from django.shortcuts import get_object_or_404

import jwt
import random

from typing import NamedTuple
from win10toast import ToastNotifier

from .serializers import UserLoginSerializer, UserVerificationSerializer
from .models import User
from api.exceptions import HTTPSerializerBadRequest, HTTPBadRequest

toaster = ToastNotifier()

TOKEN_EXPIRY_DAYS = 7

class OTPData(NamedTuple):
    otp: str
    created_at: datetime

class MemoryStore:
    def __init__(self):
        self.data = {}

    def store(self, key, otp):
        self.data[key] = OTPData(otp=otp, created_at=datetime.now())

    def retrieve(self, key):
        return self.data.get(key)

    def delete(self, key):
        if key in self.data:
            del self.data[key]

mem_store = MemoryStore()
generate_otp = lambda: ''.join(random.choices('0123456789', k=6))

@api_view(['POST'])
def user_login(request):
    serializer = UserLoginSerializer(data=request.data)

    if not serializer.is_valid():
        raise HTTPSerializerBadRequest(details=serializer.errors)

    phone_number = serializer.validated_data.get("phone_number")

    otp = generate_otp()
    mem_store.store(phone_number, otp)

    send_windows_notification("Verify your OTP", f"Here is your OTP: {otp}. It will expire in 5 minutes.")

    return Response({"message": f"Sent an OTP to the provided mobile number."}, status=status.HTTP_200_OK)

@api_view(['POST'])
def user_verify(request):
    serializer = UserVerificationSerializer(data=request.data)
    if not serializer.is_valid():
        raise HTTPSerializerBadRequest(details=serializer.errors)

    phone_number = serializer.validated_data.get("phone_number")
    received_otp = serializer.validated_data.get("otp")

    stored_data = mem_store.retrieve(phone_number)
    if not stored_data:
        raise HTTPBadRequest(message="OTP not found. Please request a new OTP.")

    stored_otp, created_at = stored_data.otp, stored_data.created_at

    expiry_time = created_at + timedelta(minutes=5)
    current_time = datetime.now()
    if current_time > expiry_time:
        mem_store.delete(phone_number)
        raise HTTPBadRequest(message="OTP has expired. Please request a new OTP.")

    if stored_otp != received_otp:
        raise HTTPBadRequest(message="Sorry, the OTP you sent didn't match. Please try again later.")

    mem_store.delete(phone_number)

    user = get_object_or_404(User, phone_number=phone_number)
    access_token = get_access_token(user.user_id, user.first_name)

    return Response({"access_token": access_token}, status=status.HTTP_200_OK)

def get_access_token(user_id, user_first_name):
    now = datetime.now(timezone.utc)
    payload = {
        'user_id': user_id,
        'user_first_name': user_first_name,
        'exp': now + timedelta(days=TOKEN_EXPIRY_DAYS)
    }

    token = jwt.encode(payload, settings.SECRET_KEY, algorithm='HS256')

    return token.decode('utf-8')

def send_windows_notification(title, message):
    toaster.show_toast(title, message, duration=5)
