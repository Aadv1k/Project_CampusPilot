from abc import ABC, abstractmethod
from typing import NamedTuple, Optional
from datetime import datetime, timedelta

class OTPData(NamedTuple):
    """Data structure for storing OTP information."""
    otp: str
    created_at: datetime

class OTPStore(ABC):
    """Abstract base class for OTP storage."""

    @abstractmethod
    def store(self, key: str, otp: str):
        """Store an OTP with the given key."""
        pass

    @abstractmethod
    def retrieve(self, key: str) -> Optional[OTPData]:
        """Retrieve an OTP with the given key."""
        pass

    @abstractmethod
    def delete(self, key: str):
        """Delete the OTP with the given key."""
        pass


class MemoryOTPStore(OTPStore):
    """In-memory OTP storage implementation."""

    def __init__(self):
        self.data = {}

    def store(self, key: str, otp: str):
        """Store an OTP with the given key."""
        self.data[key] = OTPData(otp=otp, created_at=datetime.now())

    def retrieve(self, key: str) -> Optional[OTPData]:
        """Retrieve an OTP with the given key, checking for expiration."""
        otp_data = self.data.get(key)
        if otp_data and not self.is_expired(otp_data.created_at):
            return otp_data
        self.delete(key)  # Delete expired OTP
        return None

    def delete(self, key: str):
        """Delete the OTP with the given key."""
        if key in self.data:
            del self.data[key]

    def is_expired(self, created_at: datetime, valid_duration: int = 300) -> bool:
        """Check if the OTP has expired. Default validity duration is 300 seconds."""
        return datetime.now() > created_at + timedelta(seconds=valid_duration)

_memory_otp_store_instance = None

def otp_store_singleton_factory(typ: str) -> OTPStore:
    """Factory function for creating OTPStore instances."""
    global _memory_otp_store_instance
    if typ == "memory":
        if _memory_otp_store_instance is None:
            _memory_otp_store_instance = MemoryOTPStore()
        return _memory_otp_store_instance
    else:
        raise ValueError(f"Unrecognized OTP store type: {typ}")
