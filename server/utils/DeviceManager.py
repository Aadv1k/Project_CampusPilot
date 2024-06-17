from typing import Optional

from .MemoryStore import mem_store_factory_singleton

mem_store = mem_store_factory_singleton()

class DeviceManager:
    @staticmethod
    def store_device(id: str, device_token: str) -> None:
        """Store the device token associated with the given ID."""
        mem_store.store(f"device:{id}", device_token)

    @staticmethod
    def get_device_token(id: str) -> Optional[str]:
        """Retrieve the device token associated with the given ID."""
        device_token = mem_store.get(f"device:{id}")
        return device_token.decode('utf-8') if device_token else None


device_manager = DeviceManager()