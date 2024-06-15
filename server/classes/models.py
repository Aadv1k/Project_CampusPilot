from django.db import models
from users.models import User

class Class(models.Model):
    standard = models.PositiveIntegerField()
    division = models.CharField(max_length=1)
    note = models.TextField(null=True)

    def __str__(self):
        return f"Class {self.standard} - {self.division}"

class StudentClass(models.Model):
    student = models.ForeignKey(User, on_delete=models.CASCADE, related_name="students")
    classroom = models.ForeignKey(Class, on_delete=models.CASCADE)

    def __str__(self):
        return f"{self.student.first_name} {self.student.last_name} - Class {self.classroom.standard} {self.classroom.division}"

class TeacherClass(models.Model):
    teacher = models.ForeignKey(User, on_delete=models.CASCADE)
    classes = models.ManyToManyField(Class)

    def __str__(self):
        return f"{self.teacher.first_name} {self.teacher.last_name} teaches {', '.join([str(cls) for cls in self.classes.all()])}"
