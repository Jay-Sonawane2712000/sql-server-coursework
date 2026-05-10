IF DB_ID('CreatingTablesDB') IS NULL
    CREATE DATABASE CreatingTablesDB;
GO

USE CreatingTablesDB;
GO

/* 
Name: Jay Sanjay Sonawane
Assignment: Creating Tables (Assignment 1)
Date: 02-01-2026
*/

------------------------------------------------------------
-- DROP TABLES (run first if you need to re-create)
------------------------------------------------------------
IF OBJECT_ID('dbo.StudentGrade', 'U') IS NOT NULL DROP TABLE dbo.StudentGrade;
IF OBJECT_ID('dbo.[Class]', 'U') IS NOT NULL DROP TABLE dbo.[Class];
IF OBJECT_ID('dbo.Student', 'U') IS NOT NULL DROP TABLE dbo.Student;
IF OBJECT_ID('dbo.Faculty', 'U') IS NOT NULL DROP TABLE dbo.Faculty;
IF OBJECT_ID('dbo.Course', 'U') IS NOT NULL DROP TABLE dbo.Course;
GO

------------------------------------------------------------
-- CREATE TABLE: Course
------------------------------------------------------------
CREATE TABLE dbo.Course
(
    CourseID          INT            NOT NULL,
    CourseDescription VARCHAR(200)   NOT NULL,
    CourseFee         DECIMAL(10, 2) NOT NULL,
    CONSTRAINT PK_Course PRIMARY KEY (CourseID)
);
GO

------------------------------------------------------------
-- CREATE TABLE: Faculty
------------------------------------------------------------
CREATE TABLE dbo.Faculty
(
    FacultyID     INT          NOT NULL,
    FirstName     VARCHAR(50)  NOT NULL,
    LastName      VARCHAR(50)  NOT NULL,
    PrimaryEmail  VARCHAR(255) NOT NULL,
    DateOfJoining DATE         NOT NULL,
    WorkPhone     VARCHAR(20)  NULL,
    CONSTRAINT PK_Faculty PRIMARY KEY (FacultyID)
);
GO

------------------------------------------------------------
-- CREATE TABLE: Student
------------------------------------------------------------
CREATE TABLE dbo.Student
(
    StudentID    INT         NOT NULL,
    FirstName    VARCHAR(50) NOT NULL,
    LastName     VARCHAR(50) NOT NULL,
    State        CHAR(2)     NULL,
    Zip          VARCHAR(10) NULL,
    Degree       VARCHAR(50) NULL,
    NoOfClasses  INT         NULL,
    CONSTRAINT PK_Student PRIMARY KEY (StudentID)
);
GO

------------------------------------------------------------
-- CREATE TABLE: Class (Composite PK: ClassID + CourseID)
------------------------------------------------------------
CREATE TABLE dbo.[Class]
(
    ClassID    INT          NOT NULL,
    CourseID   INT          NOT NULL,
    StartDate  DATE         NOT NULL,
    EndDate    DATE         NULL,
    Location   VARCHAR(100) NULL,

    CONSTRAINT PK_Class PRIMARY KEY (ClassID, CourseID),
    CONSTRAINT FK_Class_Course FOREIGN KEY (CourseID)
        REFERENCES dbo.Course (CourseID)
);
GO

------------------------------------------------------------
-- CREATE TABLE: StudentGrade (Composite PK: StudentID + ClassID + CourseID + FacultyID)
------------------------------------------------------------
CREATE TABLE dbo.StudentGrade
(
    StudentID INT          NOT NULL,
    ClassID   INT          NOT NULL,
    CourseID  INT          NOT NULL,
    FacultyID INT          NOT NULL,
    Grade     DECIMAL(3,2) NULL,   -- accepts values like 3.93, 4.00 etc.

    CONSTRAINT PK_StudentGrade PRIMARY KEY (StudentID, ClassID, CourseID, FacultyID),

    CONSTRAINT FK_StudentGrade_Student FOREIGN KEY (StudentID)
        REFERENCES dbo.Student (StudentID),

    CONSTRAINT FK_StudentGrade_Faculty FOREIGN KEY (FacultyID)
        REFERENCES dbo.Faculty (FacultyID),

    -- Composite FK back to Class table (this is the key requirement)
    CONSTRAINT FK_StudentGrade_Class FOREIGN KEY (ClassID, CourseID)
        REFERENCES dbo.[Class] (ClassID, CourseID)
);
GO

------------------------------------------------------------
-- TEST QUERIES (to show tables were created)
------------------------------------------------------------
SELECT TOP (0) * FROM dbo.Course;
SELECT TOP (0) * FROM dbo.Faculty;
SELECT TOP (0) * FROM dbo.Student;
SELECT TOP (0) * FROM dbo.[Class];
SELECT TOP (0) * FROM dbo.StudentGrade;

SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
  AND TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME IN ('Course','Faculty','Student','Class','StudentGrade')
ORDER BY TABLE_NAME;

SELECT fk.name AS ForeignKeyName,
       OBJECT_NAME(fk.parent_object_id) AS FromTable,
       OBJECT_NAME(fk.referenced_object_id) AS ToTable
FROM sys.foreign_keys fk
WHERE OBJECT_NAME(fk.parent_object_id) IN ('Class','StudentGrade')
ORDER BY FromTable, ForeignKeyName;
GO

------------------------------------------------------------
-- ASSIGNMENT 2 STARTS HERE: POPULATING TABLES
------------------------------------------------------------

USE CreatingTablesDB;
GO

/* 
Name: Jay Sanjay Sonawane
Assignment: Populating Tables (Assignment 2)
Date: 02-01-2026
*/

------------------------------------------------------------
-- POPULATE: Course (3 courses)
------------------------------------------------------------
INSERT INTO dbo.Course (CourseID, CourseDescription, CourseFee) VALUES
(101, 'Database Systems', 1200.00),
(102, 'Data Mining',      1300.00),
(103, 'Machine Vision',   1400.00);
GO
SELECT * FROM dbo.Course;
GO

------------------------------------------------------------
-- POPULATE: Faculty (3 faculty)
------------------------------------------------------------
INSERT INTO dbo.Faculty (FacultyID, FirstName, LastName, PrimaryEmail, DateOfJoining, WorkPhone) VALUES
(201, 'Amit',   'Sharma', 'amit.sharma@example.com',   '2020-08-15', '602-555-0101'),
(202, 'Neha',   'Gupta',  'neha.gupta@example.com',    '2019-01-10', '602-555-0102'),
(203, 'Priya',  'Nair',   'priya.nair@example.com',    '2021-06-20', '602-555-0103');
GO
SELECT * FROM dbo.Faculty;
GO

------------------------------------------------------------
-- POPULATE: Student (10 students, 3 states)
-- 4 take 3 courses: Students 1-4
-- 3 take 1 course : Students 5-7
-- 2 take 2 courses: Students 8-9
-- 1 take 0 course : Student 10
-- Degree only: Undergraduate/Bachelor/Masters
-- No duplicate (State+Zip)
------------------------------------------------------------
INSERT INTO dbo.Student (StudentID, FirstName, LastName, State, Zip, Degree, NoOfClasses) VALUES
(1,  'Aarav',  'Patel',     'AZ', '85281', 'Masters',       3),
(2,  'Meera',  'Shah',      'AZ', '85282', 'Bachelor',      3),
(3,  'Rohan',  'Kale',      'CA', '94105', 'Undergraduate', 3),
(4,  'Isha',   'Verma',     'TX', '73301', 'Masters',       3),
(5,  'Neha',   'Joshi',     'CA', '90001', 'Bachelor',      1),
(6,  'Kunal',  'Singh',     'AZ', '85004', 'Undergraduate', 1),
(7,  'Pooja',  'Nair',      'TX', '77001', 'Masters',       1),
(8,  'Vivek',  'Kulkarni',  'CA', '92101', 'Bachelor',      2),
(9,  'Ananya', 'Rao',       'AZ', '85301', 'Undergraduate', 2),
(10, 'Sahil',  'Deshmukh',  'TX', '78701', 'Masters',       0);
GO
SELECT * FROM dbo.Student;
GO

------------------------------------------------------------
-- POPULATE: Class (one class per course)
-- Composite PK: (ClassID, CourseID)
------------------------------------------------------------
INSERT INTO dbo.[Class] (ClassID, CourseID, StartDate, EndDate, Location) VALUES
(1, 101, '2026-01-27', '2026-05-01', 'Tempe'),
(2, 102, '2026-01-27', '2026-05-01', 'Tempe'),
(3, 103, '2026-01-27', '2026-05-01', 'Tempe');
GO
SELECT * FROM dbo.[Class];
GO

------------------------------------------------------------
-- POPULATE: StudentGrade
-- Total rows = 19 (12 + 3 + 4 + 0)
------------------------------------------------------------
INSERT INTO dbo.StudentGrade (StudentID, ClassID, CourseID, FacultyID, Grade) VALUES
(1, 1, 101, 201, 3.90), (1, 2, 102, 202, 3.80), (1, 3, 103, 203, 3.70),
(2, 1, 101, 201, 3.60), (2, 2, 102, 202, 3.95), (2, 3, 103, 203, 3.85),
(3, 1, 101, 201, 3.40), (3, 2, 102, 202, 3.50), (3, 3, 103, 203, 3.75),
(4, 1, 101, 201, 3.20), (4, 2, 102, 202, 3.60), (4, 3, 103, 203, 3.90),
(5, 1, 101, 201, 3.10),
(6, 2, 102, 202, 3.30),
(7, 3, 103, 203, 3.50),
(8, 1, 101, 201, 3.70), (8, 3, 103, 203, 3.60),
(9, 1, 101, 201, 3.80), (9, 2, 102, 202, 3.65);
GO
SELECT * FROM dbo.StudentGrade;
GO

------------------------------------------------------------
-- ASSIGNMENT 3 STARTS HERE: SQL QUERIES (VIEWS)
------------------------------------------------------------

USE CreatingTablesDB;
GO

/* 
Name: Jay Sanjay Sonawane
Assignment: SQL Queries (Assignment 3)
Date: 02-08-2026
*/

------------------------------------------------------------
-- Drop views if they already exist (so re-run is safe)
------------------------------------------------------------
IF OBJECT_ID('dbo.vStudentGradeDetails', 'V') IS NOT NULL
    DROP VIEW dbo.vStudentGradeDetails;
GO

IF OBJECT_ID('dbo.vCourseEnrollmentSummary', 'V') IS NOT NULL
    DROP VIEW dbo.vCourseEnrollmentSummary;
GO

------------------------------------------------------------
-- VIEW 1: Student grade details (joins 5 tables, restricted)
-- Restriction: Only show grades >= 3.00 (restricted result set)
------------------------------------------------------------
CREATE VIEW dbo.vStudentGradeDetails
AS
SELECT
    s.StudentID,
    s.FirstName,
    s.LastName,
    s.State,
    s.Zip,
    s.Degree,
    c.CourseID,
    c.CourseDescription,
    cl.ClassID,
    cl.StartDate,
    cl.EndDate,
    cl.Location,
    f.FacultyID,
    f.FirstName AS FacultyFirstName,
    f.LastName  AS FacultyLastName,
    sg.Grade
FROM dbo.StudentGrade sg
JOIN dbo.Student s
    ON sg.StudentID = s.StudentID
JOIN dbo.[Class] cl
    ON sg.ClassID = cl.ClassID
   AND sg.CourseID = cl.CourseID
JOIN dbo.Course c
    ON sg.CourseID = c.CourseID
JOIN dbo.Faculty f
    ON sg.FacultyID = f.FacultyID
WHERE sg.Grade >= 3.00;
GO

------------------------------------------------------------
-- VIEW 2: Course enrollment + average grade summary (joins 4 tables, restricted)
-- Restriction: Only show courses with at least 2 enrolled students
------------------------------------------------------------
CREATE VIEW dbo.vCourseEnrollmentSummary
AS
SELECT
    c.CourseID,
    c.CourseDescription,
    c.CourseFee,
    COUNT(DISTINCT sg.StudentID) AS StudentsEnrolled,
    CAST(AVG(CAST(sg.Grade AS DECIMAL(5,2))) AS DECIMAL(5,2)) AS AvgGrade
FROM dbo.Course c
JOIN dbo.[Class] cl
    ON c.CourseID = cl.CourseID
JOIN dbo.StudentGrade sg
    ON cl.ClassID = sg.ClassID
   AND cl.CourseID = sg.CourseID
JOIN dbo.Student s
    ON sg.StudentID = s.StudentID
GROUP BY
    c.CourseID, c.CourseDescription, c.CourseFee
HAVING COUNT(DISTINCT sg.StudentID) >= 2;
GO

------------------------------------------------------------

-- REQUIRED CHECKS / SELECTS (prove both views work)
------------------------------------------------------------

-- View outputs
SELECT * FROM dbo.vStudentGradeDetails;
SELECT * FROM dbo.vCourseEnrollmentSummary;

-- “Parameter-style” filtering (you filter the view during SELECT)
SELECT * 
FROM dbo.vStudentGradeDetails
WHERE State = 'AZ' AND Grade >= 3.80;

SELECT *
FROM dbo.vCourseEnrollmentSummary
WHERE CourseFee >= 1300.00;
GO
