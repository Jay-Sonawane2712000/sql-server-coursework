# DML Triggers in SQL Server

## Overview
This project demonstrates DML trigger implementation in Microsoft SQL Server using the MyGuitarShop sample database. The project focuses on validating product discount values during updates and automatically inserting the current date when a product is added without a `DateAdded` value.

## Objective
The objective of this project was to:
- Create SQL Server triggers
- Validate updated values before allowing changes
- Reject invalid discount percentages
- Automatically convert decimal discount values into percentage format
- Automatically populate missing insert-date values
- Test trigger behavior using `UPDATE`, `INSERT`, and `SELECT` statements

## Tools Used
- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- T-SQL
- MyGuitarShop sample database

## Triggers Created

### 1. `Products_UPDATE`
This trigger runs when the `Products` table is updated.

It checks the `DiscountPercent` column and:
- rejects values less than `0`
- rejects values greater than `100`
- converts decimal values between `0` and `1` into percentage values

Example:

```sql
0.2 → 20
