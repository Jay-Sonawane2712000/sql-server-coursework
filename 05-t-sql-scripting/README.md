# T-SQL Scripting in SQL Server

## Overview
This project demonstrates T-SQL scripting using the SQL Server AP database. The focus of this project is to use variables, conditional logic, aggregate calculations, joins, temporary tables, and query control flow to solve practical database reporting tasks.

## Objective
The objective of this project was to:
- Use T-SQL variables to store calculated values
- Apply `IF...ELSE` logic based on business conditions
- Calculate invoice balances using aggregate functions
- Join invoice and vendor data
- Use a temporary table to replace a derived table
- Return meaningful result sets for accounts payable analysis

## Tools Used
- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- T-SQL
- AP sample database

## Problems Covered

### Problem 1: Invoice Count and Total Due
This script calculates the number of invoices with outstanding balances and the total amount due. If the total due is at least `$30,000`, it displays the invoice count and total due. Otherwise, it displays a message.

### Problem 2: Outstanding Vendor Balances
This script calculates the total outstanding balance. If the total is greater than `$10,000`, it displays vendor names, invoice numbers, invoice due dates, and balances using a join between `Invoices` and `Vendors`.

### Problem 3: First Invoice Date by Vendor
This script uses a temporary table to store each vendor's first invoice date. It then joins the temporary table with the `Invoices` and `Vendors` tables to display vendor names, first invoice dates, and invoice totals.

## Key Concepts Demonstrated
- `DECLARE` variables
- `IF...ELSE` conditional logic
- Aggregate functions such as `COUNT`, `SUM`, and `MIN`
- `COALESCE`
- Joins between related tables
- Temporary tables using `#tempTable`
- `ORDER BY`
- Re-runnable scripts
- Accounts payable reporting logic

## Project Structure

```text
05-t-sql-scripting/
├── README.md
├── sql/
│   └── t_sql_scripting.sql
└── screenshots/
