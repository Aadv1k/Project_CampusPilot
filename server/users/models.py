from django.db import models

from schools.models import School
from classes.models import Class

class User(models.Model):
    class UserType(models.TextChoices):
        student = "student", "Student",
        teacher = "teacher", "Teacher",
        admin = "admin", "Admin",

    school = models.ForeignKey(School, on_delete=models.CASCADE)
    first_name = models.CharField(max_length=50)
    middle_name = models.CharField(max_length=50, blank=True, null=True)
    last_name = models.CharField(max_length=50)
    user_type = models.CharField(max_length=10, choices=UserType.choices)

    def is_authenticated(self):
        return True

    def __str__(self):
        return f"{self.first_name} {self.last_name}"

    class Meta:
        verbose_name = "User"
        verbose_name_plural = "Users"
        ordering = ['last_name', 'first_name']

class UserContact(models.Model):
    class RelationTypeChoices(models.TextChoices):
        PRIMARY = 'primary', 'Primary'
        SECONDARY = 'secondary', 'Secondary'

    class RelationChoices(models.TextChoices):
        FATHER = 'father', 'Father'
        MOTHER = 'mother', 'Mother'
        GUARDIAN = 'guardian', 'Guardian'

    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="contacts")
    country_code = models.CharField(max_length=3)
    phone_number = models.CharField(max_length=15)
    email = models.EmailField(max_length=255)

    relation_type = models.CharField(max_length=10, choices=RelationTypeChoices.choices)
    relation = models.CharField(max_length=20, choices=RelationChoices.choices, null=True, blank=True)

    def __str__(self):
        return f"{self.user.first_name} {self.user.last_name} - {self.relation_type}"

    class Meta:
        verbose_name = "User Contact"
        verbose_name_plural = "User Contacts"


class StudentDetail(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name="student_detail")
    student_class = models.ForeignKey(Class, on_delete=models.SET_NULL, null=True)

    class Meta:
        verbose_name = "Student Detail"
        verbose_name_plural = "Student Details"


class TeacherDetail(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name="teacher_detail")
    teacher_classes = models.ManyToManyField(Class)

    class Meta:
        verbose_name = "Teacher Detail"
        verbose_name_plural = "Teacher Details"
