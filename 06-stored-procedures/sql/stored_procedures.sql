USE AP;
GO

/* 

Assignment: Working with Stored Procedures
Date: 2026-02-15
*/

------------------------------------------------------------
-- EXERCISE 1: Create stored procedure spBalanceRange
------------------------------------------------------------
IF OBJECT_ID('dbo.spBalanceRange', 'P') IS NOT NULL
    DROP PROCEDURE dbo.spBalanceRange;
GO

CREATE PROCEDURE dbo.spBalanceRange
    @VendorVar  VARCHAR(50) = '%',   -- mask for vendor name
    @BalanceMin MONEY       = 0,     -- min balance due
    @BalanceMax MONEY       = 0      -- max balance due (0 means "no max")
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        v.VendorName,
        i.InvoiceNumber,
        (i.InvoiceTotal - i.PaymentTotal - i.CreditTotal) AS Balance
    FROM dbo.Invoices i
    JOIN dbo.Vendors v
        ON i.VendorID = v.VendorID
    WHERE (i.InvoiceTotal - i.PaymentTotal - i.CreditTotal) > 0
      AND v.VendorName LIKE @VendorVar
      AND (
            @BalanceMax = 0
            OR (i.InvoiceTotal - i.PaymentTotal - i.CreditTotal) BETWEEN @BalanceMin AND @BalanceMax
          )
    ORDER BY Balance DESC;
END;
GO
---------Execution (Verification) for Exercise 1-----------------
EXEC dbo.spBalanceRange;
GO

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* 

Assignment: Working with Stored Procedures
Date: 2026-02-15
*/

------------------------------------------------------------
-- EXERCISE 2: Three required calls to spBalanceRange
------------------------------------------------------------

-- (a) passed by position with @VendorVar='M%' and no balance range
EXEC dbo.spBalanceRange 'M%';
GO

-- (b) passed by name, @VendorVar omitted, balance range $200 to $1000
EXEC dbo.spBalanceRange @BalanceMin = 200, @BalanceMax = 1000;
GO

-- (c) passed by position, balance due less than $200, vendors begin with C or F
-- LIKE supports [CF]% to match names starting with C or F
EXEC dbo.spBalanceRange '[CF]%', 0, 199.99;
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

USE AP;
GO

/* 

Assignment: Working with Stored Procedures
Date: 2026-02-15
*/

------------------------------------------------------------
-- EXERCISE 3: Create stored procedure spDateRange
------------------------------------------------------------
IF OBJECT_ID('dbo.spDateRange', 'P') IS NOT NULL
    DROP PROCEDURE dbo.spDateRange;
GO

CREATE PROCEDURE dbo.spDateRange
    @DateMin VARCHAR(50) = NULL,
    @DateMax VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- If called with no parameters OR with null values, raise an error
    IF @DateMin IS NULL OR @DateMax IS NULL
    BEGIN
        THROW 50001, 'Both @DateMin and @DateMax are required (non-NULL).', 1;
    END;

    -- Validate that the strings are valid dates
    IF TRY_CONVERT(date, @DateMin) IS NULL
    BEGIN
        THROW 50002, 'Invalid date for @DateMin. Provide a valid date string.', 1;
    END;

    IF TRY_CONVERT(date, @DateMax) IS NULL
    BEGIN
        THROW 50003, 'Invalid date for @DateMax. Provide a valid date string.', 1;
    END;

    -- Validate that @DateMin is earlier than @DateMax
    IF TRY_CONVERT(date, @DateMin) >= TRY_CONVERT(date, @DateMax)
    BEGIN
        THROW 50004, '@DateMin must be earlier than @DateMax.', 1;
    END;

    -- Return the requested result set
    SELECT
        i.InvoiceNumber,
        i.InvoiceDate,
        i.InvoiceTotal,
        (i.InvoiceTotal - i.PaymentTotal - i.CreditTotal) AS Balance
    FROM dbo.Invoices i
    WHERE i.InvoiceDate >= TRY_CONVERT(date, @DateMin)
      AND i.InvoiceDate <= TRY_CONVERT(date, @DateMax)
    ORDER BY i.InvoiceDate ASC;
END;
GO

---------Execution (Verification) for Exercise 3-----------------
USE AP;
GO
EXEC dbo.spDateRange '2022-10-10', '2022-10-20';
GO


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

USE AP;
GO

/* 

Assignment: Working with Stored Procedures
Date: 2026-02-15
*/

------------------------------------------------------------
-- EXERCISE 4: Call spDateRange for Oct 10–Oct 20, 2022
--             Catch errors and print error number + description
------------------------------------------------------------
BEGIN TRY
    EXEC dbo.spDateRange '2022-10-10', '2022-10-20';
END TRY
BEGIN CATCH
    PRINT 'Error number: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
    PRINT 'Error description: ' + ERROR_MESSAGE();
END CATCH;
GO
