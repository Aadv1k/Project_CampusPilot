from django.db import models

from users.models import User

class Announcement(models.Model):
    announcer = models.ForeignKey(User, on_delete=models.CASCADE)
    title = models.CharField(max_length=255)
    body = models.TextField()

    def __str__(self):
        return self.title

    class Meta:
        verbose_name = "Announcement"
        verbose_name_plural = "Announcements"


class AnnouncementScope(models.Model):
    ANNOUNCEMENT_SCOPE_CHOICES = [
        ("student", "Student"),
        ("teacher", "Teacher"),
        ("all", "All"),
    ]

    FILTER_TYPE_CHOICES = [
        ("division", "Division"),
        ("standard", "Standard"),
        ("full_name", "Full Name"),
        ("department", "Department"),
    ]

    announcement = models.ForeignKey(Announcement, on_delete=models.CASCADE)
    scope = models.CharField(max_length=10, choices=ANNOUNCEMENT_SCOPE_CHOICES)
    filter_type = models.CharField(max_length=20, choices=FILTER_TYPE_CHOICES)
    filter_content = models.CharField(max_length=255)

    def __str__(self):
        return f"{self.announcement.title} - {self.scope}"

    class Meta:
        verbose_name = "Announcement Scope"
        verbose_name_plural = "Announcement Scopes"


class Attachment(models.Model):
    ATTACHMENT_TYPE_CHOICES = [
        ("docx", "DOCX"),
        ("pdf", "PDF"),
    ]

    announcement = models.ForeignKey(Announcement, on_delete=models.CASCADE)
    file_name = models.CharField(max_length=255)
    file_path = models.CharField(max_length=2048)
    file_type = models.CharField(max_length=4, choices=ATTACHMENT_TYPE_CHOICES)

    def __str__(self):
        return f"{self.file_name} ({self.file_type})"

    class Meta:
        verbose_name = "Announcement Attachment"
        verbose_name_plural = "Announcement Attachments"
