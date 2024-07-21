import redis
from abc import ABC, abstractmethod
from django.conf import settings

class KeyValueStore(ABC):
    @abstractmethod
    def get(self, key):
        pass

    @abstractmethod
    def set(self, key, value):
        pass

    @abstractmethod
    def delete(self, key) -> None:
        pass

class MemoryKVStore(KeyValueStore):
    _instance = None

    def __new__(cls, *args, **kwargs):
        if not cls._instance:
            cls._instance = super(MemoryKVStore, cls).__new__(cls, *args, **kwargs)
        return cls._instance

    def __init__(self):
        if not hasattr(self, 'store'):
            self.store = {}

    def get(self, key):
        return self.store.get(key)

    def set(self, key, value):
        self.store[key] = value

    def delete(self, key) -> None:
        if key in self.store:
            del self.store[key]

class RedisKVStore(KeyValueStore):
    _instance = None

    def __new__(cls, *args, **kwargs):
        if not cls._instance:
            cls._instance = super(RedisKVStore, cls).__new__(cls, *args, **kwargs)
        return cls._instance

    def __init__(self):
        if not hasattr(self, 'client'):
            self.client = redis.StrictRedis(host=settings.REDIS_HOST, port=settings.REDIS_PORT, db=settings.REDIS_DB)

    def get(self, key):
        return self.client.get(key)

    def set(self, key, value):
        self.client.set(key, value)

    def delete(self, key) -> None:
        self.client.delete(key)

def kv_store_factory(store_type, *args, **kwargs):
    if store_type == 'memory':
        return MemoryKVStore(*args, **kwargs)
    elif store_type == 'redis':
        return RedisKVStore(*args, **kwargs)
    else:
        raise ValueError(f"Unknown store type: {store_type}")

kv_store = kv_store_factory("redis" if settings.USE_REDIS else "memory")