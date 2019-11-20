USE AdventureWorks2012;
GO 
--(comment for myself) dont forget to change Year 
CREATE PROCEDURE Product_Order_By_Year (
     @years nvarchar(50)
)
AS
BEGIN
     DECLARE @cmd NVARCHAR(MAX) = N'';
	 SET @cmd = @cmd + 'SELECT * FROM   
(
    SELECT 
	    prod.Name as product_name,
		sod.OrderQty as order_count, 
		year(soh.OrderDate) as order_date
    FROM 
        Sales.SalesOrderDetail sod,
		Sales.SalesOrderHeader soh, 
		Production.Product prod 
        WHERE sod.SalesOrderID = soh.SalesOrderID
		      AND prod.ProductID = sod.ProductID
) t 
PIVOT(
    SUM(order_count) 
    FOR order_date IN (' + @years + ')
) AS pivot_table;';
    EXEC (@cmd);
END;

EXEC dbo.Product_Order_By_Year '[2008], [2007], [2006]';