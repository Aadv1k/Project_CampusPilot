USER_NAME_LENGTH = 50
PHONE_NO_LENGTH = 15
USER_ADDRESS_LENGTH = 255
USER_TYPE_MAX_LENGTH = 7

USER_TYPE_CHOICES = (
    ("student", "Student"),
    ("teacher", "Teacher")
)

TEACHER_SUBJECT_CHOICES = (
    ("math", "Mathematics"),
    ("science", "Science"),
    ("english", "English"),
)
MAX_SUBJECT_LEN = 50

USER_PERMISSIONS = (
    ("read_announcement", "Read Announcement"),
    ("read_write_announcement", "Read, Write Announcement"),
)

COUNTRY_CODE_CHOICES = (
    ("+1", "United States/Canada"),
    ("+91", "India"),
    ("+44", "United Kingdom"),
)
MAX_COUNTRY_CODE_LEN = 4