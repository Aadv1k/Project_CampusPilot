from django.db import models

class School(models.Model):
    name = models.CharField(max_length=120)
    address = models.CharField(max_length=255, blank=True, null=True)
    email = models.EmailField(max_length=255)
    website_url = models.URLField(max_length=2083, blank=True, null=True)
    logo_url = models.URLField(max_length=2083, blank=True, null=True)

    def __str__(self):
        return self.name

    class Meta:
        verbose_name = "School"
        verbose_name_plural = "Schools"
        ordering = ['name']
