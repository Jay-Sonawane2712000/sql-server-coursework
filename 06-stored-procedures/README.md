# Stored Procedures in SQL Server

## Overview
This project demonstrates stored procedure development in Microsoft SQL Server using the AP sample database. The project focuses on creating reusable database procedures with parameters, filtering logic, validation, and error handling.

## Objective
The objective of this project was to:
- Create stored procedures using T-SQL
- Use input parameters with default values
- Filter invoice records by vendor name and balance range
- Validate date parameters before running queries
- Use `TRY...CATCH` blocks for error handling
- Execute stored procedures with different parameter combinations

## Tools Used
- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- T-SQL
- AP sample database

## Stored Procedures Created

### 1. `spBalanceRange`
This stored procedure returns invoice balances based on vendor name and balance range filters.

Parameters:
- `@VendorVar`
- `@BalanceMin`
- `@BalanceMax`

It supports flexible filtering, such as:
- all vendors
- vendors starting with a specific letter
- balances within a specific range
- balances below a threshold

### 2. `spDateRange`
This stored procedure returns invoices within a given invoice date range.

Parameters:
- `@DateMin`
- `@DateMax`

The procedure validates:
- both dates are provided
- both values are valid dates
- the minimum date is earlier than the maximum date

## Exercises Covered
- Exercise 1: Create and execute `spBalanceRange`
- Exercise 2: Execute `spBalanceRange` using different parameter styles
- Exercise 3: Create and execute `spDateRange`
- Exercise 4: Use `TRY...CATCH` error handling with `spDateRange`

## Key Concepts Demonstrated
- `CREATE PROCEDURE`
- `DROP PROCEDURE`
- Stored procedure parameters
- Default parameter values
- `LIKE` filtering
- `BETWEEN`
- Date validation using `TRY_CONVERT`
- Custom errors using `THROW`
- `TRY...CATCH` error handling
- Reusable database logic

## Project Structure

```text
06-stored-procedures/
├── README.md
├── sql/
│   └── stored_procedures.sql
└── screenshots/
