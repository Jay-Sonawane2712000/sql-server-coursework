USE AP;
GO

/* 
IFT530 — Working on User Define Function (Chapter 15, Q5–Q7)
Name: Jay Sanjay Sonawane
ASU ID: 1233750832
Assignment: User-Defined Functions (Scalar + Table-Valued)
*/

/********************************************************************
Q5) Scalar-valued function: fnUnpaidInvoiceID
Returns the InvoiceID of the earliest invoice with an unpaid balance.
Unpaid balance = InvoiceTotal - CreditTotal - PaymentTotal
********************************************************************/

IF OBJECT_ID('dbo.fnUnpaidInvoiceID', 'FN') IS NOT NULL
    DROP FUNCTION dbo.fnUnpaidInvoiceID;
GO

CREATE FUNCTION dbo.fnUnpaidInvoiceID()
RETURNS INT
AS
BEGIN
    DECLARE @InvoiceID INT;

    SELECT TOP (1)
        @InvoiceID = i.InvoiceID
    FROM Invoices i
    WHERE (i.InvoiceTotal - i.CreditTotal - i.PaymentTotal) > 0
    ORDER BY i.InvoiceDate ASC, i.InvoiceID ASC;

    RETURN @InvoiceID;
END;
GO

-- TEST for Q5 (use the exact statement from the assignment)
SELECT  VendorName,
        InvoiceNumber,
        InvoiceDueDate,
        InvoiceTotal - CreditTotal - PaymentTotal AS Balance
FROM Vendors v
JOIN Invoices i
    ON v.VendorID = i.VendorID
WHERE InvoiceID = dbo.fnUnpaidInvoiceID();
GO


/* 
IFT530 — Working on User Define Function (Chapter 15, Q5–Q7)
Name: Jay Sanjay Sonawane
ASU ID: 1233750832
Assignment: User-Defined Functions (Scalar + Table-Valued)
*/


/********************************************************************
Q6) Table-valued function: fnDateRange
- Similar to stored procedure exercise 3
- Requires two DATE parameters
- DO NOT validate parameters
Returns: InvoiceNumber, InvoiceDate, InvoiceTotal, Balance
For invoices where InvoiceDate is within the date range
********************************************************************/

IF OBJECT_ID('dbo.fnDateRange', 'IF') IS NOT NULL
    DROP FUNCTION dbo.fnDateRange;
GO

CREATE FUNCTION dbo.fnDateRange
(
    @DateMin DATE,
    @DateMax DATE
)
RETURNS TABLE
AS
RETURN
(
    SELECT  InvoiceNumber,
            InvoiceDate,
            InvoiceTotal,
            (InvoiceTotal - CreditTotal - PaymentTotal) AS Balance
    FROM Invoices
    WHERE InvoiceDate BETWEEN @DateMin AND @DateMax
);
GO

-- TEST for Q6: invoices with InvoiceDate between Oct 10 and Oct 20, 2022
SELECT  InvoiceNumber,
        InvoiceDate,
        InvoiceTotal,
        Balance
FROM dbo.fnDateRange('2022-10-10', '2022-10-20');
GO


/* 
IFT530 — Working on User Define Function (Chapter 15, Q5–Q7)
Name: Jay Sanjay Sonawane
ASU ID: 1233750832
Assignment: User-Defined Functions (Scalar + Table-Valued)
*/


/********************************************************************
Q7) Use fnDateRange in a SELECT that returns 5 columns:
VendorName + the 4 columns from fnDateRange
********************************************************************/

SELECT  v.VendorName,
        f.InvoiceNumber,
        f.InvoiceDate,
        f.InvoiceTotal,
        f.Balance
FROM dbo.fnDateRange('2022-10-10', '2022-10-20') AS f
JOIN Invoices i
    ON  i.InvoiceNumber = f.InvoiceNumber
    AND i.InvoiceDate   = f.InvoiceDate
    AND i.InvoiceTotal  = f.InvoiceTotal
JOIN Vendors v
    ON v.VendorID = i.VendorID
ORDER BY v.VendorName, f.InvoiceDate, f.InvoiceNumber;
GO
