# Generated by Django 5.0.1 on 2024-06-15 07:45

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("classes", "0002_initial"),
    ]

    operations = [
        migrations.AlterField(
            model_name="class",
            name="note",
            field=models.TextField(null=True),
        ),
    ]
