# Project Campus Pilot

The school communication platform for the post-modern era.

## Features

The goal isn't to completely replace school's infrastructure, but rather
complement it in the form of simple, easy-to-use tools.

- Scoped announcements
    - Teachers can make announcements that are only visible to users to fit the
      scope criteria 
- Student Information System
    - Users with the right permissions can view each student, what class,
      subject and their contact info
- Scheduling
    - allows the admin to define a schedule, which will show up personalized for
      a teacher
    - allow for proxies to be setup 

## Tech-Stack

- The back-end is a RestAPI built using Python and Django
- The front-end is built using Dart, Flutter and Material design system

## Back-end

### Data models

**School**

```sql
CREATE TABLE School (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(120) NOT NULL,
    address VARCHAR(255),
    email VARCHAR(255),
    website_url VARCHAR(2083),
    logo_url VARCHAR(2083),

    PRIMARY KEY (id)
)
```


**User**

A user must belong to a school, they may also have a One-To-One relationship with details for specific roles

```sql
CREATE TABLE User (
    UserID INT NOT NULL AUTO_INCREMENT,
    
    SchoolID INT NOT NULL,

    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,

    user_type ENUM ("student", "teacher") NOT NULL,

    PRIMARY KEY (UserID)
    FOREIGN KEY (SchoolID) References School(SchoolID)
)

CREATE TABLE UserPermissions (
    UserID INT,
    

)

CREATE TABLE UserContact (
    UserID INT,
    country_code VARCHAR(3) NOT NULL,
    phone_number VARCHAR(15) NOT NULL,
    email VARCHAR(255) NOT NULL,
    relation_type ENUM ("primary", "secondary") NOT NULL,
    relation ENUM ("father" , "mother" , "guardian"),
    FOREIGN KEY (UserID) REFERENCES User(UserID)
)

CREATE TABLE StudentDetail ( -- OneToOne Relationship with User
    -- TBD: left empty for now, we add as requirements come
) 

CREATE TABLE TeacherDetail ( -- OneToOne Relationship with User
    -- TBD: left empty forClassnow, we add as requirements come
) 
```

**User permissions**

A user can have certain permission, which can be enabled or disabled  

```sql
CREATE TABLE UserPermission (
    PermissionID INT NOT NULL AUTO_INCREMENT,
    UserID INT,
    type ENUM ("read_announcements", "write_announcements", "write_users", "read_users")
    PRIMARY KEY (PermissionID),
    FOREIGN KEY (UserID) references User(UserID)
) 
```


**Class**

A class defines a relationship between students, and teacher.

```sql
CREATE TABLE Class ( 
    ClassID INT NOT NULL AUTO_INCREMENT,
    standard INT unsigned NOT NULL,
    division VARCHAR(1) NOT NULL,
    PRIMARY KEY (ClassID)
    
    -- NOTE: this can be extended with class_subjects,
) 

CREATE TABLE StudentClass ( -- represents a ManyToOne relationship (Many students) -> (One class)
    StudentID int
    ClassID int,
    FOREIGN KEY (StudentID) References User(UserID)
    FOREIGN KEY (ClassID) References Class(ClassID)
)

CREATE TABLE TeacherClass ( -- represents a ManyToMany relationships (Many teachers) -> (Many Classes)
    TeacherID int
    ClassID int,
    FOREIGN KEY (TeacherID) References User(UserID)
    FOREIGN KEY (ClassID) References Class(ClassID)
)
```

**Announcement** 

represents a scoped announcement

```sql
CREATE TABLE Announcement (
    AnnouncementID INT NOT NULL AUTO_INCREMENT,
    announcer VARCHAR(100) NOT NULL,
    title VARCHAR(255) NOT NULL,
    body TEXT,
    PRIMARY KEY (AnnouncementID)
);

CREATE TABLE AnnouncementScope (
    AnnouncementScopeID INT NOT NULL AUTO_INCREMENT,
    AnnouncementID INT NOT NULL,
    scope ENUM('student', 'teacher', 'all') NOT NULL,
    filter_type ENUM('division', 'standard', 'full_name', 'department'),
    filter_content VARCHAR(255),
    PRIMARY KEY (AnnouncementScopeID),
    FOREIGN KEY (AnnouncementID) REFERENCES Announcement(AnnouncementID) ON DELETE CASCADE
);

CREATE TABLE AnnouncementAttachment (
    AttachmentID INT NOT NULL AUTO_INCREMENT,
    AnnouncementID INT NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(2048) NOT NULL,
    file_type ENUM ("docx", "pdf")
    PRIMARY KEY (AttachmentID),
    FOREIGN KEY (AnnouncementID) REFERENCES Announcement(AnnouncementID) ON DELETE CASCADE
);
```
