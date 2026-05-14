-- ---------------------------------Question 1 ---------------------------------------------------------

USE AP;
GO

/* 
Name: Jay Sanjay Sonawane
Assignment: Scripting (Q1)
Date: 2026-02-15
*/

DECLARE @InvoiceCount INT;
DECLARE @TotalDue     DECIMAL(18,2);

SELECT
    @InvoiceCount = COUNT(*),
    @TotalDue = COALESCE(SUM(InvoiceTotal - PaymentTotal - CreditTotal), 0)
FROM dbo.Invoices
WHERE (InvoiceTotal - PaymentTotal - CreditTotal) > 0;

IF @TotalDue >= 30000
BEGIN
    SELECT 'Invoice count:' AS [Label], CAST(@InvoiceCount AS VARCHAR(20)) AS [Value]
    UNION ALL
    SELECT 'Total due:'      AS [Label], CAST(CAST(ROUND(@TotalDue,0) AS INT) AS VARCHAR(20)) AS [Value];
END
ELSE
BEGIN
    SELECT 'Total balance due is less than $30,000.' AS [Message];
END;
GO


-- ---------------------------------Question 2 ---------------------------------------------------------

USE AP;
GO

/* 
Name: Jay Sanjay Sonawane
Assignment: Scripting (Q2)
Date: 2026-02-15
*/

DECLARE @TotalOutstanding DECIMAL(18,2);

-- Total outstanding balance due (only invoices with balance due)
SELECT
    @TotalOutstanding = COALESCE(SUM(InvoiceTotal - PaymentTotal - CreditTotal), 0)
FROM dbo.Invoices
WHERE (InvoiceTotal - PaymentTotal - CreditTotal) > 0;

IF @TotalOutstanding > 10000.00
BEGIN
    SELECT
        v.VendorName,
        i.InvoiceNumber,
        i.InvoiceDueDate,
        (i.InvoiceTotal - i.PaymentTotal - i.CreditTotal) AS Balance
    FROM dbo.Invoices i
    JOIN dbo.Vendors v
        ON i.VendorID = v.VendorID
    WHERE (i.InvoiceTotal - i.PaymentTotal - i.CreditTotal) > 0
    ORDER BY i.InvoiceDueDate ASC;   -- oldest due date first
END
ELSE
BEGIN
    SELECT 'Balance due is less than $10,000.00.' AS [Message];
END;
GO


-- ---------------------------------Question 3 ---------------------------------------------------------


USE AP;
GO

/* 
Name: Jay Sanjay Sonawane
Assignment: Scripting (Q3)
Date: 2026-02-15
*/

------------------------------------------------------------
-- Drop temp table if it already exists (so script is re-runnable)
------------------------------------------------------------
IF OBJECT_ID('tempdb..#FirstInvoiceDates') IS NOT NULL
    DROP TABLE #FirstInvoiceDates;

------------------------------------------------------------
-- Create temp table that replaces the derived table
------------------------------------------------------------
SELECT
    VendorID,
    MIN(InvoiceDate) AS FirstInvoiceDate
INTO #FirstInvoiceDates
FROM dbo.Invoices
GROUP BY VendorID;

------------------------------------------------------------
-- Final result set (same as the provided query)
------------------------------------------------------------
SELECT
    v.VendorName,
    fid.FirstInvoiceDate,
    i.InvoiceTotal
FROM dbo.Invoices i
JOIN #FirstInvoiceDates fid
    ON i.VendorID = fid.VendorID
   AND i.InvoiceDate = fid.FirstInvoiceDate
JOIN dbo.Vendors v
    ON i.VendorID = v.VendorID
ORDER BY v.VendorName, fid.FirstInvoiceDate;

------------------------------------------------------------
-- Optional cleanup (not required, but fine)
------------------------------------------------------------
DROP TABLE #FirstInvoiceDates;
GO
