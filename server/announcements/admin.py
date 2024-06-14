from django.contrib import admin

from .models import Announcement, AnnouncementScope, Attachment

admin.site.register(Announcement)
admin.site.register(AnnouncementScope)
admin.site.register(Attachment)

