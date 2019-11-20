USE AdventureWorks2012;
GO 

--выполнить код из второй лабы

/*The server is executing the t-sql. It doesn't know where the client 
loaded the file from. You'll have to have the path embedded within the script.

DECLARE @RelDir varchar(1000)
SET @RelDir = 'D:\BD\LAB3\lab2_2.sql'
EXECUTE(@RelDir)*/

--a

ALTER TABLE dbo.Person
ADD SalesYTD MONEY, SalesLastYear MONEY, OrdersNum INT
  --computed
ALTER TABLE dbo.Person
ADD SalesDiff AS (SalesYTD - SalesLastYear)

--b
SELECT
             BusinessEntityID,
			 PersonType ,
			 NameStyle ,
			 Title,
			 FirstName,
			 MiddleName,
			 LastName,
			 Suffix,
			 EmailPromotion,
			 ModifiedDate,
			 SalesYTD,
			 SalesLastYear,
			 OrdersNum
INTO #Person --- temporary table
FROM
    dbo.Person

--c
INSERT INTO #Person (
             BusinessEntityID,
			 PersonType ,
			 NameStyle ,
			 Title,
			 FirstName,
			 MiddleName,
			 LastName,
			 Suffix,
			 EmailPromotion,
			 ModifiedDate,
			 SalesYTD,
			 SalesLastYear
)
SELECT
             P.BusinessEntityID,
			 P.PersonType ,
			 P.NameStyle ,
			 P.Title,
			 P.FirstName,
			 P.MiddleName,
			 P.LastName,
			 P.Suffix,
			 P.EmailPromotion,
			 P.ModifiedDate,
			 S.SalesYTD,
			 S.SalesLastYear
FROM
    dbo.Person P,
    Sales.SalesPerson S
WHERE S.BusinessEntityID = P.BusinessEntityID  ;

With SalesPerson_CTE (SalesPerson_ID, OrdersNum_)
as
(
    SELECT SO.SalesPersonID, COUNT(SO.SalesOrderID)
	FROM  Sales.SalesOrderHeader SO
	GROUP BY SO.SalesPersonID
)
update #Person
Set OrdersNum = OrdersNum_
from SalesPerson_CTE
where BusinessEntityID = SalesPerson_ID

--d
delete from dbo.Person WHERE  BusinessEntityID = 290;

--e
MERGE dbo.Person target
USING #Person source
ON (target.BusinessEntityID = source.BusinessEntityID)  -- условие связи между источником и изменяемой таблицей
WHEN MATCHED
THEN UPDATE SET 
        target.SalesYTD = source.SalesYTD,
        target.SalesLastYear = source.SalesLastYear,
		target.OrdersNum = source.OrdersNum
WHEN NOT MATCHED BY TARGET 
    THEN INSERT (BusinessEntityID,
			 PersonType ,
			 NameStyle ,
			 Title,
			 FirstName,
			 MiddleName,
			 LastName,
			 Suffix,
			 EmailPromotion,
			 ModifiedDate,
			 SalesYTD,
			 SalesLastYear,
			 OrdersNum)
         VALUES (source.BusinessEntityID,
			 source.PersonType ,
			 source.NameStyle ,
			 source.Title,
			 source.FirstName,
			 source.MiddleName,
			 source.LastName,
			 source.Suffix,
			 source.EmailPromotion,
			 source.ModifiedDate,
			 source.SalesYTD,
			 source.SalesLastYear,
			 source.OrdersNum)
WHEN NOT MATCHED BY SOURCE 
    THEN DELETE;