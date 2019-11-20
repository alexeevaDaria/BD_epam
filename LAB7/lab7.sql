USE AdventureWorks2012;
GO 

DECLARE @XMLvariable xml;

SET @XMLvariable = (SELECT [BusinessEntityID] as "@ID",
       [NationalIDNumber],
       [JobTitle]
FROM [HumanResources].[Employee] 
FOR XML PATH('Employee'), ROOT('Employees'));

--SELECT @XMLvariable;

CREATE TABLE #xml_table (
     NationalIDNumber nvarchar(15) not null,
	 JobTitle nvarchar(50) not null
);

DECLARE @XML_Doc_Handle INT;

EXEC sp_xml_preparedocument @XML_Doc_Handle OUTPUT, @XMLvariable;

INSERT INTO #xml_table SELECT *
FROM OPENXML(@XML_Doc_Handle,'/Employees/Employee')
WITH (
     NationalIDNumber nvarchar(15) 'NationalIDNumber',
	 JobTitle nvarchar(50) 'JobTitle'
);
EXEC sp_xml_removedocument @XML_Doc_Handle;

SELECT * FROM #xml_table