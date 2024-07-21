from django.conf import settings
import random
from datetime import timedelta, datetime
from typing import Tuple

from .KeyValueStore import KeyValueStore, kv_store

class OTPManager:
    def __init__(self, kv_store: KeyValueStore):
        self.kv_store = kv_store
        self.expiry = timedelta(minutes=2)
    
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

otp_manager = OTPManager(kv_store)