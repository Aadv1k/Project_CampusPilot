from django.db import models

from api.constants import *
from schools.models import School  

class User(models.Model):
    """
    User model to store general user information and their association with a school.
    """
    user_id = models.AutoField(primary_key=True)
    school = models.ForeignKey(School, on_delete=models.CASCADE, related_name='schools', blank=True, null=True)

    first_name = models.CharField(max_length=USER_NAME_LENGTH)
    last_name = models.CharField(max_length=USER_NAME_LENGTH)

    country_code = models.CharField(max_length=MAX_COUNTRY_CODE_LEN, choices=COUNTRY_CODE_CHOICES)
    phone_number = models.CharField(max_length=PHONE_NO_LENGTH)

    email = models.EmailField(unique=True)
    type = models.CharField(max_length=USER_TYPE_MAX_LENGTH, choices=USER_TYPE_CHOICES)

    permissions = models.ManyToManyField('UserPermission', blank=True)

    def __str__(self):
        return f"{self.first_name} {self.last_name} ({self.get_type_display()})"

    class Meta:
        verbose_name = "User"
        verbose_name_plural = "Users"
        ordering = ['last_name', 'first_name']

class UserPermission(models.Model):
    """
    Model to store different permissions that can be assigned to users.
    """
    permission_code = models.CharField(max_length=30, unique=True, choices=USER_PERMISSIONS)
    description = models.CharField(max_length=100)

    def __str__(self):
        return self.get_permission_code_display()

    class Meta:
        verbose_name = "User Permission"
        verbose_name_plural = "User Permissions"

class StudentDetail(models.Model):
    """
    Model to store additional details specific to students.
    """
    student = models.OneToOneField(User, on_delete=models.CASCADE, primary_key=True, limit_choices_to={'type': 'student'})
    address = models.CharField(max_length=USER_ADDRESS_LENGTH)
    admission_date = models.DateField()
    father_contact = models.CharField(max_length=PHONE_NO_LENGTH)
    mother_contact = models.CharField(max_length=PHONE_NO_LENGTH)

    def __str__(self):
        return f"{self.student.first_name} {self.student.last_name} - Student"

    class Meta:
        verbose_name = "Student Detail"
        verbose_name_plural = "Student Details"

class TeacherDetail(models.Model):
    """
    Model to store additional details specific to teachers.
    """
    teacher = models.OneToOneField(User, on_delete=models.CASCADE, primary_key=True, limit_choices_to={'type': 'teacher'})
    qualifications = models.TextField()
    hire_date = models.DateField()
    subjects = models.ManyToManyField('TeacherSubject', blank=True)

    def __str__(self):
        return f"{self.teacher.first_name} {self.teacher.last_name} - Teacher"

    class Meta:
        verbose_name = "Teacher Detail"
        verbose_name_plural = "Teacher Details"

class TeacherSubject(models.Model):
    """
    Model to store subjects that can be assigned to teachers.
    """
    subject = models.CharField(max_length=MAX_SUBJECT_LEN, choices=TEACHER_SUBJECT_CHOICES)

    def __str__(self):
        return self.get_subject_display()

    class Meta:
        verbose_name = "Teacher Subject"
        verbose_name_plural = "Teacher Subjects"
