USE AdventureWorks2012;
GO 
--1
SELECT e.BusinessEntityID, e.JobTitle, eph.Rate as MaxRate 
FROM HumanResources.Employee e
INNER JOIN HumanResources.EmployeePayHistory eph ON e.BusinessEntityID = eph.BusinessEntityID
WHERE eph.Rate = (SELECT max(Rate) from HumanResources.EmployeePayHistory
                                 WHERE e.BusinessEntityID = EmployeePayHistory.BusinessEntityID)
ORDER BY e.BusinessEntityID ASC;

--2
SELECT e.BusinessEntityID, 
       e.JobTitle, 
	   eph.Rate,
	   DENSE_RANK() OVER(ORDER BY eph.Rate) rnk_dense 
FROM HumanResources.Employee e
INNER JOIN HumanResources.EmployeePayHistory eph ON e.BusinessEntityID = eph.BusinessEntityID
GROUP BY eph.Rate, e.JobTitle, e.BusinessEntityID;

--3
SELECT d.Name as DepName, e.BusinessEntityID, e.JobTitle, edh.ShiftID
FROM HumanResources.Department d
INNER JOIN HumanResources.EmployeeDepartmentHistory edh on edh.DepartmentID = d.DepartmentID
INNER JOIN HumanResources.Employee e on e.BusinessEntityID = edh.BusinessEntityID
ORDER BY d.Name,
      CASE 
	  WHEN d.Name = 'Document Control'
	  THEN edh.ShiftID
	  ELSE e.BusinessEntityID
	  END;

         



