import jwt
from .models import User

from rest_framework.authentication import BaseAuthentication
from rest_framework.exceptions import AuthenticationFailed
from django.conf import settings

class JWTAuthentication(BaseAuthentication):
    def authenticate(self, request):
        token = request.META.get('HTTP_AUTHORIZATION', '').split(' ')
        if len(token) != 2 or token[0] != 'Bearer':
            return None

        try:
            payload = jwt.decode(token[1], settings.SECRET_KEY, algorithms=['HS256'])
            user_id = payload.get('user_id')
            user = User.objects.get(id=user_id)
            return (user, None)
        except jwt.ExpiredSignatureError:
            raise AuthenticationFailed('Token has expired')
        except (jwt.DecodeError, User.DoesNotExist) as e:
            raise AuthenticationFailed('Invalid token')