from django.urls import path

from users.views import user_login, user_verify

urlpatterns = [
    path("users/login", view=user_login),
    path("users/otp_verify", view=user_verify)
]