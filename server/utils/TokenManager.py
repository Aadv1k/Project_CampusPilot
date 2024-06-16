from typing import NamedTuple, List
from datetime import datetime, timedelta, timezone
import jwt
from django.conf import settings
from users.models import UserPermission

class UserTokenPayload(NamedTuple):
    user_id: str
    user_name: str
    user_permissions: List[str]

class TokenManager:
    """
    A class to manage the creation, verification, and decoding of JWT tokens.
    """

    @staticmethod
    def create_token(payload: UserTokenPayload, expiry_in_days: int = 1) -> str:
        """
        Create a JWT token with the given payload and expiration time.

        :param payload: UserTokenPayload object containing user_id, user_name, and user_permissions.
        :param expiry_in_days: The number of days before the token expires.
        :return: A JWT token as a string.
        """
        now = datetime.now(timezone.utc)
        jwt_payload = {
            "exp": now + timedelta(days=expiry_in_days),
            "user_id": payload.user_id,
            "user_name": payload.user_name,
            "user_permissions": payload.user_permissions
        }
        token = jwt.encode(jwt_payload, settings.SECRET_KEY, algorithm='HS256')
        return token

    @staticmethod
    def verify_token(token: str) -> bool:
        """
        Verify the validity of the given JWT token.

        :param token: The JWT token to verify.
        :return: True if the token is valid, False otherwise.
        """
        try:
            jwt.decode(token, settings.SECRET_KEY, algorithms=['HS256'])
            return True
        except jwt.ExpiredSignatureError:
            return False
        except jwt.InvalidTokenError:
            return False

    @staticmethod
    def decode_token(token: str) -> UserTokenPayload:
        """
        Decode the given JWT token to extract the payload.

        :param token: The JWT token to decode.
        :return: A UserTokenPayload object containing user_id, user_name, and user_permissions.
        """
        payload = jwt.decode(token, settings.SECRET_KEY, algorithms=['HS256'])
        return UserTokenPayload(
            user_id=payload["user_id"],
            user_name=payload["user_name"],
            user_permissions=payload["user_permissions"]
        )
