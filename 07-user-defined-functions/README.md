# User-Defined Functions in SQL Server

## Overview
This project demonstrates how to create and use user-defined functions in Microsoft SQL Server using the AP sample database. The project includes both scalar-valued and table-valued functions for invoice and vendor reporting.

## Objective
The objective of this project was to:
- Create a scalar-valued function
- Create a table-valued function
- Use functions inside `SELECT` statements
- Return invoice and vendor-related results
- Practice reusable SQL logic using user-defined functions

## Tools Used
- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- T-SQL
- AP sample database

## Functions Created

### 1. `fnUnpaidInvoiceID`
This scalar-valued function returns the `InvoiceID` of the earliest invoice with an unpaid balance.

The unpaid balance is calculated as:

```sql
InvoiceTotal - CreditTotal - PaymentTotal
