import redis
from typing import Union, Optional

from django.conf import settings

class MemoryStore:
    _instance = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            cls._instance._store = {}
        return cls._instance

    def store(self, key: str, data: Union[str, bytes]) -> None:
        self._store[key] = data

    def get(self, key: str) -> Optional[Union[str, bytes]]:
        return self._store.get(key)


class RedisStore:
    _instance = None

    def __new__(cls, host='localhost', port=6379, db=0):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            cls._instance.redis_client = redis.StrictRedis(host=host, port=port, db=db)
        return cls._instance

    def store(self, key: str, data: Union[str, bytes]) -> None:
        self.redis_client.set(key, data)

    def delete(self, key: str) -> None:
        self.redis_client.delete(key)

    def get(self, key: str) -> Optional[str]:
        value = self.redis_client.get(key)

        if isinstance(value, str):
            return value
        elif isinstance(value, bytes):
            return value.decode("utf-8") 
        
        return None

def mem_store_factory_singleton():
    return RedisStore() 