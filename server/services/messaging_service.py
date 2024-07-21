from abc import ABC, abstractmethod
from twilio.rest import Client
from django.conf import settings

class MessagingService(ABC):
    @abstractmethod
    def send_message(self, to: str, message: str):
        pass

class EmailMessagingService(MessagingService):
    def send_message(self, to: str, message: str):
        assert False, "Not implemented" 

class PhoneMessagingService(MessagingService):
    def __init__(self, sid, auth_token):
        self.client = Client(sid, auth_token)

    def send_message(self, to: str, message: str):
        message = self.client.messages.create(
            body=message,
            from_="+15005550006",
            to=to,
        )
        return True, message.sid

class NoOpMessagingService(MessagingService):
    def send_message(self, to: str, message: str):
        pass

def messaging_service_factory(service_type):
    if service_type == "sms":
        if getattr(settings, 'USE_TWILIO', False):
            return PhoneMessagingService(settings.TWILIO_SID, settings.TWILIO_AUTH_TOKEN)
        else:
            return NoOpMessagingService()
    elif service_type == "email":
        return EmailMessagingService()
    else:
        assert False, "Unreachable"

messaging_service = messaging_service_factory("sms")