from django.contrib import admin
from .models import User, UserPermission, StudentDetail, TeacherDetail, UserContact

admin.site.register(User)
admin.site.register(UserPermission)
admin.site.register(StudentDetail)
admin.site.register(TeacherDetail)
admin.site.register(UserContact)
