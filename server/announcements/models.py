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
    class ScopeContextChoices(models.TextChoices):
        student = "student", "Student"
        teacher = "teacher", "Teacher"
        all = "all", "All"
        
    class ScopeFilterChoices(models.TextChoices):
        standard_division = "standard_division", "Standard & Division"
        standard = "standard", "Standard"
        full_name = "full_name", "Full Name"
        department = "department", "Department"

    announcement = models.ForeignKey(Announcement, on_delete=models.CASCADE, related_name="scope")
    scope = models.CharField(max_length=10, choices=ScopeContextChoices.choices)
    filter_type = models.CharField(max_length=20, choices=ScopeFilterChoices.choices, null=True)
    filter_content = models.CharField(max_length=255, null=True, blank=True)

    def __str__(self):
        return f"{self.announcement.title} - {self.scope}"

    class Meta:
        verbose_name = "Announcement Scope"
        verbose_name_plural = "Announcement Scopes"


class Attachment(models.Model):
    class FileTypeChoices(models.TextChoices):
        docx = "docx", "DOCX"
        pdf = "pdf", "PDF"

    announcement = models.ForeignKey(Announcement, on_delete=models.CASCADE, related_name="attachments")
    file_name = models.CharField(max_length=255)
    file_path = models.CharField(max_length=2048)
    file_type = models.CharField(max_length=4, choices=FileTypeChoices.choices)

    def __str__(self):
        return f"{self.file_name} ({self.file_type})"

    class Meta:
        verbose_name = "Announcement Attachment"
        verbose_name_plural = "Announcement Attachments"
