USE AdventureWorks2012;
GO 

SELECT * FROM HumanResources.Department;

--функция, возвращающая количество департаментов относящихся к введенному имени
CREATE FUNCTION HumanResources.Number_Of_Departments(
       @departmentName nvarchar(50)
)
RETURNS INT
WITH EXECUTE AS CALLER
AS
BEGIN
      DECLARE @quantity INT;
      SELECT @quantity = COUNT(d.DepartmentID) FROM HumanResources.Department d
	  WHERE d.GroupName = @departmentName;

	  RETURN @quantity;
END;
--example
SELECT 
      HumanResources.Number_Of_Departments('Research and Development') quantity;


--функция, возвращающая 3 самых старших сотрудников по id департамента
CREATE FUNCTION HumanResources.Dep_Oldest_Employee_ILTVF(
       @departmentID smallint
)
RETURNS TABLE 
AS
RETURN (
      SELECT TOP 3 e.*
	  FROM 
	       HumanResources.EmployeeDepartmentHistory edh,
		   HumanResources.Employee e
      WHERE 
	       edh.DepartmentID = @departmentID
	       AND edh.BusinessEntityID = e.BusinessEntityID
		   AND e.HireDate > '2005-01-01'
      ORDER By e.HireDate ASC
);

SELECT * FROM HumanResources.Dep_Oldest_Employee_ILTVF(5);
--cross apply 
SELECT d.DepartmentID, e.* FROM HumanResources.Department d 
CROSS APPLY HumanResources.Dep_Oldest_Employee_ILTVF(d.DepartmentID) e
--outer apply
SELECT d.DepartmentID, e.* FROM HumanResources.Department d 
OUTER APPLY HumanResources.Dep_Oldest_Employee_ILTVF(d.DepartmentID) e


--функция, возвращающая 3 самых старших сотрудников по id департамента multi statement
CREATE FUNCTION HumanResources.Dep_Oldest_Employee_MSTVF(
       @departmentID smallint
)
RETURNS @table TABLE (
        BusinessEntityID int, 
		JobTitle nvarchar(50),
		HireDate date
)
AS
BEGIN
      INSERT INTO @table
	  SELECT top 3    
	    e.BusinessEntityID, 
		e.JobTitle,
		e.HireDate
	  FROM 
	       HumanResources.EmployeeDepartmentHistory edh,
		   HumanResources.Employee e
      WHERE 
	       edh.DepartmentID = @departmentID
	       AND edh.BusinessEntityID = e.BusinessEntityID
		   AND e.HireDate > '2005-01-01'
      ORDER By e.HireDate ASC;
	  RETURN;
END;


select * from HumanResources.Dep_Oldest_Employee_MSTVF(5);
