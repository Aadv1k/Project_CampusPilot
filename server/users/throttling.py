from rest_framework.throttling import AnonRateThrottle, BaseThrottle
from datetime import datetime, timedelta

class OTPRequestThrottle(AnonRateThrottle):
    scope = 'otp_request'
    rate = '3/min'

class DisableThrottle(BaseThrottle):
    def allow_request(self, request, view):
        return True
