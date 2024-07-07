from twilio.rest import Client
from twilio.base.exceptions import TwilioRestException


from django.conf import settings

class SMSService:
    _instance = None
    client = Client(settings.TWILIO_SID, settings.TWILIO_AUTH_TOKEN)

    def __new__(cls, *args, **kwargs):
        if not cls._instance:
            cls._instance = super(SMSService, cls).__new__(cls, *args, **kwargs)
        return cls._instance

    def __init__(self):
        if not hasattr(self, 'initialized'):
            self.initialized = True

    def send_sms(self, phone_number: str, otp: str) -> tuple[bool, str]:
        optimized_sms = f"CampusPilot verify your OTP {otp}"
        try:
            message = self.client.messages.create(
                body=optimized_sms,
                from_="+15005550006",
                to=phone_number,
            )
            return True, message.sid
        except TwilioRestException as e:
            return False, str(e)