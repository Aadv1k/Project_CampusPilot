from django.db import models
from typing import Tuple

class Class(models.Model):
    standard = models.PositiveIntegerField()
    division = models.CharField(max_length=1)

    @staticmethod 
    def get_class_by_standard_division(std_div):
        std, div = Class.extract_standard_and_division_from_str(std_div) 
        return Class.objects.get(standard=int(std), division=div)
        

    @staticmethod
    def extract_standard_and_division_from_str(inp: str) -> Tuple[str, str]:
        std, div = "", ""

        for i in range(len(inp)):
            if not inp[i].isdigit():
                div = inp[i:] 
                break
            std += inp[i]

        return std, div.lower()
    
    @staticmethod
    def validate_standard_division_format(inp: str) -> bool:
        std, div = Class.extract_standard_and_division_from_str(inp)

        return (len(std) <= 2 and len(div) == 1) and (std.isdigit() and int(std) <= 12) and (div in "abcdefghijklmnopqrstuvwxyz") 


    def save(self, *args, **kwargs):
        self.division = self.division.lower()
        super().save(*args, **kwargs)

    def __str__(self):
        return f"Class {self.standard} - {self.division}"

    class Meta:
        unique_together = ["standard", "division"]
        verbose_name_plural = "Classrooms"