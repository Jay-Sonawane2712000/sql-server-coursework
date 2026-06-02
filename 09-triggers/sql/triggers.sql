USE MyGuitarShop;
GO

/*
Assignment: Triggers
Description: Create Products_UPDATE and Products_INSERT triggers
For Questions: 1 and 2
*/

------------------------------------------------------------
-- Drop triggers if they already exist
------------------------------------------------------------
IF OBJECT_ID('dbo.Products_UPDATE', 'TR') IS NOT NULL
    DROP TRIGGER dbo.Products_UPDATE;
GO

IF OBJECT_ID('dbo.Products_INSERT', 'TR') IS NOT NULL
    DROP TRIGGER dbo.Products_INSERT;
GO

------------------------------------------------------------
-- Trigger 1: Products_UPDATE
------------------------------------------------------------
CREATE TRIGGER dbo.Products_UPDATE
ON dbo.Products
FOR UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(DiscountPercent)
    BEGIN
        -- Reject invalid discount values
        IF EXISTS
        (
            SELECT 1
            FROM inserted
            WHERE DiscountPercent < 0
               OR DiscountPercent > 100
        )
        BEGIN
            RAISERROR('DiscountPercent must be between 0 and 100.', 16, 1);
            ROLLBACK TRAN;
            RETURN;
        END

        -- Convert decimal discounts like 0.2 to 20
        UPDATE p
        SET p.DiscountPercent = i.DiscountPercent * 100
        FROM Products p
        JOIN inserted i
            ON p.ProductID = i.ProductID
        WHERE i.DiscountPercent BETWEEN 0 AND 1;
    END
END;
GO

------------------------------------------------------------
-- Test 1 for Products_UPDATE
-- Expected result: DiscountPercent becomes 20
------------------------------------------------------------
UPDATE Products
SET DiscountPercent = 0.2
WHERE ProductID = 1;
GO

SELECT ProductID, ProductName, DiscountPercent
FROM Products
WHERE ProductID = 1;
GO

------------------------------------------------------------
-- Test 2 for Products_UPDATE
-- Expected result: error message
------------------------------------------------------------
-- Uncomment this only when you want to test the error
/*
UPDATE Products
SET DiscountPercent = 120
WHERE ProductID = 1;
GO
*/

------------------------------------------------------------
-- Trigger 2: Products_INSERT
------------------------------------------------------------
CREATE TRIGGER dbo.Products_INSERT
ON dbo.Products
FOR INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE p
    SET DateAdded = GETDATE()
    FROM Products p
    JOIN inserted i
        ON p.ProductID = i.ProductID
    WHERE i.DateAdded IS NULL;
END;
GO

------------------------------------------------------------
-- Test for Products_INSERT
------------------------------------------------------------
INSERT INTO Products
    (CategoryID, ProductCode, ProductName, Description, ListPrice, DiscountPercent, DateAdded)
VALUES
    (1, 'test001', 'Test Product', 'Testing insert trigger', 999.99, 10, NULL);
GO

SELECT ProductID, ProductCode, ProductName, DateAdded
FROM Products
WHERE ProductCode = 'test001';
GO




