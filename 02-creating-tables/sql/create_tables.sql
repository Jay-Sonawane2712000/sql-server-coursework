/*
Name: Jay Sanjay Sonawane
ASU ID: 1233750832
Project: Creating Tables in SQL Server
Subject: IFT 530 - Advanced Database Management Systems
Description: This script creates Course, Faculty, Student, Class, and StudentGrade tables
             with primary keys, foreign keys, composite keys, and verification queries.
*/

IF DB_ID('CreatingTablesDB') IS NULL
    CREATE DATABASE CreatingTablesDB;
GO

USE CreatingTablesDB;
GO

------------------------------------------------------------
-- DROP TABLES
------------------------------------------------------------
IF OBJECT_ID('dbo.StudentGrade', 'U') IS NOT NULL
    DROP TABLE dbo.StudentGrade;

IF OBJECT_ID('dbo.[Class]', 'U') IS NOT NULL
    DROP TABLE dbo.[Class];

IF OBJECT_ID('dbo.Student', 'U') IS NOT NULL
    DROP TABLE dbo.Student;

IF OBJECT_ID('dbo.Faculty', 'U') IS NOT NULL
    DROP TABLE dbo.Faculty;

IF OBJECT_ID('dbo.Course', 'U') IS NOT NULL
    DROP TABLE dbo.Course;
GO

------------------------------------------------------------
-- CREATE TABLE: Course
------------------------------------------------------------
CREATE TABLE dbo.Course
(
    CourseID INT NOT NULL,
    CourseDescription VARCHAR(200) NOT NULL,
    CourseFee DECIMAL(10, 2) NOT NULL,

    CONSTRAINT PK_Course PRIMARY KEY (CourseID),
    CONSTRAINT CK_CourseFee_NonNegative CHECK (CourseFee >= 0)
);
GO

------------------------------------------------------------
-- CREATE TABLE: Faculty
------------------------------------------------------------
CREATE TABLE dbo.Faculty
(
    FacultyID INT NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    PrimaryEmail VARCHAR(255) NOT NULL,
    DateOfJoining DATE NOT NULL,
    WorkPhone VARCHAR(20) NULL,

    CONSTRAINT PK_Faculty PRIMARY KEY (FacultyID),
    CONSTRAINT UQ_Faculty_PrimaryEmail UNIQUE (PrimaryEmail)
);
GO

------------------------------------------------------------
-- CREATE TABLE: Student
------------------------------------------------------------
CREATE TABLE dbo.Student
(
    StudentID INT NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    State CHAR(2) NULL,
    Zip VARCHAR(10) NULL,
    Degree VARCHAR(50) NULL,
    NoOfClasses INT NULL,

    CONSTRAINT PK_Student PRIMARY KEY (StudentID),
    CONSTRAINT CK_Student_NoOfClasses_NonNegative 
        CHECK (NoOfClasses IS NULL OR NoOfClasses >= 0)
);
GO

------------------------------------------------------------
-- CREATE TABLE: Class
------------------------------------------------------------
CREATE TABLE dbo.[Class]
(
    ClassID INT NOT NULL,
    CourseID INT NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NULL,
    Location VARCHAR(100) NULL,

    CONSTRAINT PK_Class PRIMARY KEY (ClassID, CourseID),

    CONSTRAINT FK_Class_Course 
        FOREIGN KEY (CourseID)
        REFERENCES dbo.Course(CourseID),

    CONSTRAINT CK_Class_EndDate 
        CHECK (EndDate IS NULL OR EndDate >= StartDate)
);
GO

------------------------------------------------------------
-- CREATE TABLE: StudentGrade
------------------------------------------------------------
CREATE TABLE dbo.StudentGrade
(
    StudentID INT NOT NULL,
    ClassID INT NOT NULL,
    CourseID INT NOT NULL,
    FacultyID INT NOT NULL,
    Grade DECIMAL(3,2) NULL,

    CONSTRAINT PK_StudentGrade 
        PRIMARY KEY (StudentID, ClassID, CourseID, FacultyID),

    CONSTRAINT FK_StudentGrade_Student 
        FOREIGN KEY (StudentID)
        REFERENCES dbo.Student(StudentID),

    CONSTRAINT FK_StudentGrade_Faculty 
        FOREIGN KEY (FacultyID)
        REFERENCES dbo.Faculty(FacultyID),

    CONSTRAINT FK_StudentGrade_Class 
        FOREIGN KEY (ClassID, CourseID)
        REFERENCES dbo.[Class](ClassID, CourseID),

    CONSTRAINT FK_StudentGrade_Course 
        FOREIGN KEY (CourseID)
        REFERENCES dbo.Course(CourseID),

    CONSTRAINT CK_StudentGrade_GradeRange 
        CHECK (Grade IS NULL OR (Grade >= 0 AND Grade <= 4.00))
);
GO

------------------------------------------------------------
-- VERIFICATION QUERIES
------------------------------------------------------------

-- Check created tables
SELECT 
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
  AND TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME IN ('Course', 'Faculty', 'Student', 'Class', 'StudentGrade')
ORDER BY TABLE_NAME;

-- Check foreign key relationships
SELECT 
    fk.name AS ForeignKeyName,
    OBJECT_NAME(fk.parent_object_id) AS FromTable,
    OBJECT_NAME(fk.referenced_object_id) AS ToTable
FROM sys.foreign_keys fk
WHERE OBJECT_NAME(fk.parent_object_id) IN ('Class', 'StudentGrade')
ORDER BY FromTable, ForeignKeyName;
GO
