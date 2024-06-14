from django.db import models

from users.models import User

class Announcement(models.Model):
    id = models.AutoField(primary_key=True)
    created_at = models.DateTimeField(auto_now_add=True)
    ann_author = models.ForeignKey(User, on_delete=models.CASCADE)

    title = models.CharField(max_length=255)
    content = models.TextField()

    scope = models.ManyToManyField("AnnouncementScope", related_name="announcements")
    attachments = models.ManyToManyField(
        "Attachment", related_name="announcements", blank=True
    )

    def __str__(self):
        return self.title


class AnnouncementScope(models.Model):
    SCOPE_TYPES = ("student", "teacher", "all")
    FILTER_TYPES = ("division", "standard", "subject_taught")

    ann_id = models.ForeignKey(Announcement, on_delete=models.CASCADE)
    scope_type = models.CharField(max_length=10, choices=[(elem, elem) for elem in SCOPE_TYPES])
    filter_type = models.CharField(
        max_length=255,
        choices=[(elem, elem) for elem in FILTER_TYPES],
        null=True,
        blank=True
    )
    filter_content = models.CharField(max_length=255, null=True, blank=True)


    def __str__(self):
        return f"{self.scope_type} ({self.filter_content})"


class Attachment(models.Model):
    attach_id = models.AutoField(primary_key=True)
    file_name = models.CharField(max_length=255)
    file_type = models.CharField(
        max_length=10, choices=[("pdf", "PDF"), ("docx", "DOCX")]
    )
    file_path = models.TextField()
    upload_date = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.file_name
