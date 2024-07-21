from django.db import models

class Class(models.Model):
    standard = models.PositiveIntegerField()
    division = models.CharField(max_length=1)

    def save(self, *args, **kwargs):
        self.division = self.division.lower()
        super().save(*args, **kwargs)

    def __str__(self):
        return f"Class {self.standard} - {self.division}"

    class Meta:
        unique_together = ["standard", "division"]
        verbose_name_plural = "Classrooms"