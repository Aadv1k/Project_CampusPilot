from django.conf import settings

class SMSService:
    _instance = None
    client = None

    def __new__(cls, *args, **kwargs):
        if not cls._instance:
            cls._instance = super(SMSService, cls).__new__(cls, *args, **kwargs)
        return cls._instance

    def __init__(self):
        if not hasattr(self, 'initialized'):
            self.initialized = True

    def send_sms(self, phone_number: str, otp: str) -> tuple[bool, str]:
        assert False, "Not Implemented"