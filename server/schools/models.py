from django.db import models
from api.constants import USER_NAME_LENGTH, USER_ADDRESS_LENGTH, PHONE_NO_LENGTH

class School(models.Model):
    """
    Model to store information about a school.
    """
    school_id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=USER_NAME_LENGTH)
    address = models.CharField(max_length=USER_ADDRESS_LENGTH)
    established_date = models.DateField()

    principal_name = models.CharField(max_length=USER_NAME_LENGTH * 2)  # This field holds both the first and the last name

    contact_number = models.CharField(max_length=PHONE_NO_LENGTH)
    email = models.EmailField(blank=True, null=True)
    website = models.URLField(blank=True, null=True)
    logo_url = models.URLField(blank=True, null=True)

    def __str__(self):
        return self.name

    class Meta:
        verbose_name = "School"
        verbose_name_plural = "Schools"
        ordering = ['name']