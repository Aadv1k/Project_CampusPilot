from django.urls import path

from users.views import user_login, user_verify
from users.permissions import IsAuthenticated, IsPartOfSchool

from announcements.views import AnnouncementsViewset, MyAnnouncementsViewset

urlpatterns = [
    path("<int:school_id>/users/login", view=user_login, name="user_login"),
    path("<int:school_id>/users/verify", view=user_verify, name="user_verify"),

    path("<int:school_id>/announcements/", AnnouncementsViewset.as_view({
        'get': 'list',
        'post': 'create',
    }), name="announcements"),

    path("<int:school_id>/announcements/mine", MyAnnouncementsViewset.as_view({
        'get': 'list',
    }), name="my_announcement_list"),

    path("<int:school_id>/announcements/mine/<int:announcement_id>", MyAnnouncementsViewset.as_view({
        'get': 'retrieve',
    }), name="my_announcement_list"),


    path("<int:school_id>/announcements/<int:announcement_id>", AnnouncementsViewset.as_view({
        'get': 'retrieve',
    }), name="announcement"),

]