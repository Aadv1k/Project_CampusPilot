from django.urls import path

from users.views import user_login, user_verify
from users.permissions import IsAuthenticated, IsMember

from announcements.views import AnnouncementsViewset

urlpatterns = [
    path("users/login", view=user_login),
    path("users/otp_verify", view=user_verify),

    path("<int:school_id>/announcements", AnnouncementsViewset.as_view({
        'get': 'list',
        'post': 'create',
    })),
]