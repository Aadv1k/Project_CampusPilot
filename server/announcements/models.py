from django.db import models
from users.models import User

class AnnouncementScope(models.Model):
    STUDENT = 'student'
    TEACHER = 'teacher'
    ALL = 'all'
    STANDARD = 'standard'
    DIVISION = 'division'
    SUBJECT = 'subject'

    SCOPE_CHOICES = [
        (STUDENT, 'Student'),
        (TEACHER, 'Teacher'),
        (ALL, 'All'),
        (STANDARD, 'Standard'),
        (DIVISION, 'Division'),
        (SUBJECT, 'Subject'),
    ]

    ann_id = models.ForeignKey('Announcement', on_delete=models.CASCADE, related_name='scopes')
    scope_type = models.CharField(max_length=10, choices=SCOPE_CHOICES)
    filter_type = models.CharField(max_length=255, null=True, blank=True)
    filter_content = models.CharField(max_length=255, null=True, blank=True)

    def __str__(self):
        return f"{self.scope_type} ({self.filter_content})"

class Announcement(models.Model):
    ann_from = models.ForeignKey(User, on_delete=models.CASCADE, related_name='announcements')
    ann_id = models.AutoField(primary_key=True)
    title = models.CharField(max_length=255)
    content = models.TextField()
    attachment = models.ManyToManyField('Attachment', related_name='announcements')

    def __str__(self):
        return self.title

class Attachment(models.Model):
    attach_id = models.AutoField(primary_key=True)
    ann_id = models.ForeignKey(Announcement, on_delete=models.CASCADE, related_name='attachments')
    file_name = models.CharField(max_length=255)
    file_type = models.CharField(max_length=10, choices=[('pdf', 'PDF'), ('docx', 'DOCX')])
    file_path = models.TextField()
    upload_date = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.file_name