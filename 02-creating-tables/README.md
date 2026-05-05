# Creating Tables in SQL Server

## Overview
This project demonstrates relational database schema design using Microsoft SQL Server and SQL Server Management Studio (SSMS). The database includes tables for courses, faculty, students, classes, and student grades.

## Objective
The goal of this project was to create SQL Server tables using T-SQL, define primary keys and foreign keys, generate an ERD diagram, and verify that the tables were created successfully.

## Tools Used
- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- T-SQL
- SQL Server Database Diagram Tool

## Tables Created
- Course
- Faculty
- Student
- Class
- StudentGrade

## Key Concepts Demonstrated
- Creating tables using `CREATE TABLE`
- Safely dropping existing tables using `DROP TABLE`
- Primary key constraints
- Foreign key constraints
- Composite primary keys
- Composite foreign keys
- Check constraints
- ERD generation
- Schema verification queries

## Project Structure

```text
02-creating-tables/
├── README.md
├── sql/
│   └── create_tables.sql
└── screenshots/
    ├── 01_database_creation_and_script_header.png
    ├── 02_faculty_and_student_table_creation.png
    ├── 03_class_table_composite_key.png
    ├── 04_studentgrade_foreign_keys.png
    ├── 05_verification_tables_and_foreign_keys.png
    ├── 06_object_explorer_and_verification_output.png
    └── 07_erd_diagram.png
