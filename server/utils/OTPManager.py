import random
import string
from typing import Optional

from .MemoryStore import mem_store_factory_singleton

mem_store = mem_store_factory_singleton()

class OTPManager:
    OTP_LENGTH = 6
    OTP_EXPIRATION_TIME = 300  # 5 minutes

    @staticmethod
    def generate_otp(length: int = OTP_LENGTH) -> str:
        """Generate a random OTP of specified length."""
        return ''.join(random.choices(string.digits, k=length))

    def create_and_store_otp(self, phone_number: str) -> str:
        """Create an OTP, store it with an expiration time, and return the OTP."""
        otp = self.generate_otp()
        mem_store.store(f"otp:{phone_number}", otp)
        mem_store.store(f"otp_expiry:{phone_number}", str(self.OTP_EXPIRATION_TIME))
        return otp

    def get_otp(self, phone_number: str) -> Optional[str]:
        """Retrieve the stored OTP for a given phone number."""
        return mem_store.get(f"otp:{phone_number}")

    def delete_otp(self, phone_number: str) -> None:
        """Delete the stored OTP for a given phone number."""
        mem_store.store(f"otp:{phone_number}", None)
        mem_store.store(f"otp_expiry:{phone_number}", None)

    def is_otp_valid(self, phone_number: str, otp: str) -> bool:
        """Check if the provided OTP is valid."""
        stored_otp = self.get_otp(phone_number)
        if stored_otp == otp:
            return True
        return False
    
otp_manager = OTPManager()