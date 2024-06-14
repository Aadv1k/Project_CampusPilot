from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status

from .serializers import UserLoginSerializer, UserVerificationSerializer
from .models import User
from api.exceptions import HTTPSerializerBadRequest, HTTPBadRequest

import random

from typing import NamedTuple
from datetime import datetime, timedelta

from win10toast import ToastNotifier

def send_windows_notification(title, message):
    toaster = ToastNotifier()
    toaster.show_toast(title, message, duration=5)

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

    print(serializer.validated_data)
    otp = generate_otp()
    mem_store.store(serializer.validated_data.get("phone_number"), otp)

    send_windows_notification("Verify your OTP", f"Here is your OTP, it will expire in 5 minutes {otp}")

    return Response({"message": f"Sent an OTP to the provided mobile number."}, status=status.HTTP_200_OK)

@api_view(['POST'])
def user_verify(request):
    serializer = UserVerificationSerializer(data=request.data)
    if not serializer.is_valid():
        raise HTTPSerializerBadRequest(details=serializer.errors)

    stored_data = mem_store.retrieve(serializer.validated_data.get("phone_number"))
    if not stored_data:
        raise HTTPBadRequest(message="OTP not found. Please request a new OTP.")

    stored_otp, created_at = stored_data.otp, stored_data.created_at
    
    received_otp = serializer.validated_data.get("otp")

    expiry_time = created_at + timedelta(minutes=5)
    current_time = datetime.now()
    if current_time > expiry_time:
        mem_store.delete(serializer.validated_data.get("phone_number"))
        raise HTTPBadRequest(message="OTP has expired. Please request a new OTP.")

    if stored_otp != received_otp:
        raise HTTPBadRequest(message="Sorry, the OTP you sent didn't match. Please try again later.")
    
    mem_store.delete(serializer.validated_data.get("phone_number"))
    return Response({"message": "OTP verification successful."})