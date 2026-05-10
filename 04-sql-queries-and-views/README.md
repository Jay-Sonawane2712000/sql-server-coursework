# SQL Queries and Views in SQL Server

## Overview
This project extends the SQL Server coursework database by creating SQL views using joins, filters, grouping, and aggregation. The goal was to convert SQL queries into reusable views that provide useful academic and administrative insights.

## Objective
The objective of this project was to:
- Write SQL queries using joins across multiple tables
- Convert the queries into SQL Server views
- Restrict the result sets using filters and conditions
- Verify the views using `SELECT` statements
- Explain why each view is useful and who would use it

## Tools Used
- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- T-SQL

## Views Created

### 1. `vStudentGradeDetails`
This view joins the following tables:
- Student
- StudentGrade
- Class
- Course
- Faculty

It displays student grade details along with course, class, and faculty information. The view is restricted to show only records where the grade is greater than or equal to `3.00`.

This view is useful for academic advisors and instructors because it helps them quickly review student performance across courses and instructors.

### 2. `vCourseEnrollmentSummary`
This view joins the following tables:
- Course
- Class
- StudentGrade
- Student

It summarizes course enrollment and average grades by course. The view is restricted to courses with at least two enrolled students.

This view is useful for department administrators because it helps track course demand, enrollment levels, and overall student performance by course.

## Key Concepts Demonstrated
- SQL joins across multiple tables
- Creating reusable views using `CREATE VIEW`
- Dropping existing views safely using `DROP VIEW`
- Filtering view results using `WHERE`
- Aggregating data using `COUNT` and `AVG`
- Grouping results using `GROUP BY`
- Restricting grouped results using `HAVING`
- Parameter-style filtering using `SELECT` queries on views

## Project Structure

```text
04-sql-queries-and-views/
├── README.md
├── sql/
│   └── sql_queries_and_views.sql
└── screenshots/
