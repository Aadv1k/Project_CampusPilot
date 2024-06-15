from django.contrib import admin
from .models import Class, StudentClass, TeacherClass

admin.site.register(Class)
admin.site.register(StudentClass)
admin.site.register(TeacherClass)
