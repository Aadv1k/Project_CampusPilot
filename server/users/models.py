from typing import Iterable
from django.db import models
import hashlib
from classes.models import Class

class School(models.Model):
    name = models.CharField(max_length=120)
    logo_url = models.URLField(max_length=2048, blank=True, null=True)

    def __str__(self):
        return self.name

    class Meta:
        verbose_name = "School"
        verbose_name_plural = "Schools"
        ordering = ['name']

class User(models.Model):
    class UserType(models.TextChoices):
        STUDENT = "student", "Student"
        TEACHER = "teacher", "Teacher"
        ADMIN = "admin", "Admin"

    school = models.ForeignKey(School, on_delete=models.CASCADE, related_name="people")
    first_name = models.CharField(max_length=50)
    middle_name = models.CharField(max_length=50, blank=True, null=True)
    last_name = models.CharField(max_length=50)
    user_type = models.CharField(max_length=10, choices=UserType.choices)

    def __str__(self):
        return f"{self.first_name} {self.last_name} -- {self.user_type}"

    class Meta:
        verbose_name = "User"
        verbose_name_plural = "Users"
        ordering = ['last_name', 'first_name']

class UserContact(models.Model):
    class ContactType(models.TextChoices):
        PRIMARY = 'primary', 'Primary'
        SECONDARY = 'secondary', 'Secondary'

    class ContactFormat(models.TextChoices):
        EMAIL = 'email', 'Email'
        PHONE_NUMBER = 'phone_number', 'Phone Number'

    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="contacts")
    contact_type = models.CharField(max_length=10, choices=ContactType.choices)
    contact_format = models.CharField(max_length=14, choices=ContactFormat.choices)
    contact_description = models.TextField(blank=True, null=True)
    contact_data = models.CharField(max_length=32)

    def __str__(self):
        return f"{self.user.first_name} {self.user.last_name} - {self.contact_data}"

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
    is_class_teacher = models.BooleanField()
    is_department_head = models.BooleanField()
    assigned_classes = models.ManyToManyField(Class)
    department = models.ManyToManyField('Department')

    class Meta:
        verbose_name = "Teacher Detail"
        verbose_name_plural = "Teacher Details"

class Department(models.Model):
    name = models.CharField(max_length=255)
    code = models.PositiveIntegerField(null=True, blank=True, unique=True)

    def save(self, *args, **kwargs):
        if self.code is None:
            self.code = self.dept_code_from_name(self.name)
        super().save(*args, **kwargs)

    @staticmethod
    def dept_code_from_name(name: str):
        code = int(hashlib.sha1(name.lower().encode()).hexdigest(), 16) % (10 ** 4)
        return code

class Subject(models.Model):
    department = models.ForeignKey(Department, on_delete=models.CASCADE, related_name="subjects")
    name = models.CharField(max_length=255)
    code = models.PositiveIntegerField(null=True, blank=True, unique=True)

    def save(self, *args, **kwargs):
        if self.code is None:
            self.code = Department.dept_code_from_name(self.name)
        super().save(*args, **kwargs)

    class Meta:
        verbose_name = "Subject"
        verbose_name_plural = "Subjects"
