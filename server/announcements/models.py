from django.db import models

from users.models import User

from classes.models import Class

class Announcement(models.Model):
    announcer = models.ForeignKey(User, on_delete=models.CASCADE)
    title = models.CharField(max_length=255)
    body = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.title

    def for_user(self, user: User) -> bool:
        for scope in self.scope.all():
            if scope.scope_context == AnnouncementScope.ScopeContextChoices.student:
                if user.user_type in {User.UserType.TEACHER, User.UserType.ADMIN}:
                    return True

                if not user.student_detail.student_class:
                    return False

                if scope.filter_type == AnnouncementScope.ScopeFilterChoices.standard:
                    if user.student_detail.student_class.standard == int(scope.filter_content):
                        return True

                elif scope.filter_type == AnnouncementScope.ScopeFilterChoices.standard_division:
                    if Class.get_class_by_standard_division(scope.filter_content) == user.student_detail.student_class:
                        return True

                return False

            elif scope.scope_context == AnnouncementScope.ScopeContextChoices.teacher:
                if user.user_type not in {User.UserType.TEACHER, User.UserType.ADMIN}:
                    return False
                # Implement teacher-specific logic here
                assert False, "Teacher-specific implementation needed"

            elif scope.scope_context == AnnouncementScope.ScopeContextChoices.all:
                return True

        return False


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
    scope_context = models.CharField(max_length=10, choices=ScopeContextChoices.choices)
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
