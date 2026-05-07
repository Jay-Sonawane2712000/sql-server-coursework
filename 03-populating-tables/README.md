# Populating Tables in SQL Server

## Overview
This project extends the relational database schema project by inserting sample data into SQL Server tables using T-SQL `INSERT` statements. The database includes course, faculty, student, class, and student grade records.

## Objective
The goal of this project was to populate the existing SQL Server tables with meaningful sample data and verify the inserted records using `SELECT` queries.

## Tools Used
- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- T-SQL

## Tables Populated
- Course
- Faculty
- Student
- Class
- StudentGrade

## Key Concepts Demonstrated
- Inserting records using `INSERT INTO`
- Populating independent and dependent tables
- Maintaining primary key and foreign key relationships
- Working with composite keys
- Verifying inserted data using `SELECT` statements
- Handling relational data dependencies during insertion

## Data Summary
The project inserts:
- 3 course records
- 3 faculty records
- 10 student records
- 3 class records
- 19 student grade records

The student data includes students from three states, with different course enrollment counts:
- 4 students taking 3 courses
- 3 students taking 1 course
- 2 students taking 2 courses
- 1 student taking 0 courses

## Project Structure

```text
03-populating-tables/
├── README.md
├── sql/
│   └── populate_tables.sql
└── screenshots/
