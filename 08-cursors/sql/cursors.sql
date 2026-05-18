/*=============================================
Name: Jay Sanjay Sonawane
ASU ID: 1233750832
Assignment: Cursor Assignment - Problem 1
Description: Cursor with WHILE loop fetching directly
             to Results tab (no INTO clause)
=============================================*/

USE MyGuitarShop;
GO

DECLARE CustomerShipCursor CURSOR
FOR
SELECT LastName, AVG(ShipAmount) AS ShipAmountAvg
FROM Customers
JOIN Orders
    ON Customers.CustomerID = Orders.CustomerID
GROUP BY LastName;

OPEN CustomerShipCursor;

FETCH NEXT FROM CustomerShipCursor;

WHILE @@FETCH_STATUS = 0
BEGIN
    FETCH NEXT FROM CustomerShipCursor;
END

CLOSE CustomerShipCursor;
DEALLOCATE CustomerShipCursor;
GO

/*=============================================
Name: Jay Sanjay Sonawane
ASU ID: 1233750832
Assignment: Cursor Assignment - Problem 2
Description: Cursor with WHILE loop fetching into
             local variables and printing to Messages tab
=============================================*/

USE MyGuitarShop;
GO

DECLARE @LastName VARCHAR(50);
DECLARE @ShipAmountAvg DECIMAL(10,2);

DECLARE CustomerShipCursor CURSOR
FOR
SELECT LastName, AVG(ShipAmount) AS ShipAmountAvg
FROM Customers
JOIN Orders
    ON Customers.CustomerID = Orders.CustomerID
GROUP BY LastName;

OPEN CustomerShipCursor;

FETCH NEXT FROM CustomerShipCursor
INTO @LastName, @ShipAmountAvg;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT @LastName + ', $' + CAST(@ShipAmountAvg AS VARCHAR(20));

    FETCH NEXT FROM CustomerShipCursor
    INTO @LastName, @ShipAmountAvg;
END

CLOSE CustomerShipCursor;
DEALLOCATE CustomerShipCursor;
GO
