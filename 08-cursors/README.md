# Cursors in SQL Server

## Overview
This project demonstrates cursor-based row-by-row processing in Microsoft SQL Server using the MyGuitarShop database. The project uses cursors to process customer shipping averages from joined customer and order data.

## Objective
The objective of this project was to:
- Declare and use SQL Server cursors
- Fetch rows sequentially from a result set
- Use a `WHILE` loop with `@@FETCH_STATUS`
- Fetch cursor rows directly to the Results tab
- Fetch cursor rows into local variables
- Print formatted row output to the Messages tab

## Tools Used
- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- T-SQL
- MyGuitarShop sample database

## Problems Covered

### Problem 1: Cursor Fetching Directly to Results
This script declares a cursor for a query that returns customer last names and average shipping amounts. It uses `FETCH NEXT` and a `WHILE` loop to process each row directly in the Results tab.

### Problem 2: Cursor Fetching into Variables
This script modifies the first cursor by fetching each row into local variables. It then uses the `PRINT` statement to return each row in the format:

```text
Name, $0.00
