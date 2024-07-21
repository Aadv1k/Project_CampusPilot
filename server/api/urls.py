from django.urls import path

from users.views import user_login, user_verify
from users.permissions import IsAuthenticated, IsMember

from announcements.views import AnnouncementsViewset

urlpatterns = [
    path("<int:school_id>/users/login", view=user_login, name="user_login"),
    path("<int:school_id>/users/verify", view=user_verify, name="user_verify"),

    path("<int:school_id>/announcements/", AnnouncementsViewset.as_view({
        'get': 'list',
        'post': 'create',
    }), name="announcement_list"),

    path("<int:school_id>/announcements/<int:pk>/", AnnouncementsViewset.as_view({
        'get': 'retrieve',
        'put': 'update',
        'delete': 'destroy',
    }), name="announcement_detail"),
]