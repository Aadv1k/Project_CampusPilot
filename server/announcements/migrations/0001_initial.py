# Generated by Django 5.0.1 on 2024-06-15 07:36

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = []

    operations = [
        migrations.CreateModel(
            name="Announcement",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("title", models.CharField(max_length=255)),
                ("body", models.TextField()),
            ],
            options={
                "verbose_name": "Announcement",
                "verbose_name_plural": "Announcements",
            },
        ),
        migrations.CreateModel(
            name="AnnouncementScope",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                (
                    "scope",
                    models.CharField(
                        choices=[
                            ("student", "Student"),
                            ("teacher", "Teacher"),
                            ("all", "All"),
                        ],
                        max_length=10,
                    ),
                ),
                (
                    "filter_type",
                    models.CharField(
                        choices=[
                            ("division", "Division"),
                            ("standard", "Standard"),
                            ("full_name", "Full Name"),
                            ("department", "Department"),
                        ],
                        max_length=20,
                    ),
                ),
                ("filter_content", models.CharField(max_length=255)),
            ],
            options={
                "verbose_name": "Announcement Scope",
                "verbose_name_plural": "Announcement Scopes",
            },
        ),
        migrations.CreateModel(
            name="Attachment",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("file_name", models.CharField(max_length=255)),
                ("file_path", models.CharField(max_length=2048)),
                (
                    "file_type",
                    models.CharField(
                        choices=[("docx", "DOCX"), ("pdf", "PDF")], max_length=4
                    ),
                ),
            ],
            options={
                "verbose_name": "Announcement Attachment",
                "verbose_name_plural": "Announcement Attachments",
            },
        ),
    ]