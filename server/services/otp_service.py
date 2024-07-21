from django.conf import settings
import random
from datetime import timedelta, datetime
from typing import Tuple

from .messaging_service import messaging_service
from .key_value_store import KeyValueStore, kv_store_factory

class OTPManager:
    def __init__(self, kv_store: KeyValueStore, expiry: timedelta = timedelta(minutes=2)):
        self.kv_store = kv_store
        self.expiry = expiry
    
    def generate_otp(self, length: int = 6) -> str:
        return ''.join(random.choices('0123456789', k=length))
    
    def store_otp(self, key: str, otp: str) -> None:
        expires_at = (datetime.now() + self.expiry).timestamp()
        value = f"{otp}:{expires_at}"
        self.kv_store.set(key, value)

    def verify_otp(self, key: str, otp: str) -> bool:
        stored_value = self.kv_store.get(key)
        if not stored_value:
            return False
        
        stored_otp, expires_at = self._parse_stored_value(stored_value)
        
        if datetime.now().timestamp() > float(expires_at):
            self.kv_store.delete(key)
            return False
        
        if otp != stored_otp:
            return False
        
        self.kv_store.delete(key)
        return True
    
    def _parse_stored_value(self, value: str) -> Tuple[str, str]:
        return value.split(':')

# Assuming you have a configuration to select the kv store type
kv_store_type = 'memory'  # or 'redis'
kv_store = kv_store_factory(kv_store_type)

otp_manager = OTPManager(kv_store)

class OTPService:
    def __init__(self, otp_manager: OTPManager):
        self.otp_manager = otp_manager

    def send_otp(self, phone_number: str):
        otp = self.otp_manager.generate_otp()
        self.otp_manager.store_otp(phone_number, otp)

        messaging_service.send_message(phone_number, f"CampusPilot: your otp is {otp}")

    def verify_otp(self, phone_number: str, otp: str) -> bool:
        return self.otp_manager.verify_otp(phone_number, otp)
    
otp_service = OTPService(otp_manager)
