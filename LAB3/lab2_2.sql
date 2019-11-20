USE AdventureWorks2012;
GO 
--a
CREATE TABLE dbo.Person (
             BusinessEntityID int not null,
			 PersonType nchar(2) not null,
			 NameStyle bit not null,
			 Title nvarchar(8) null,
			 FirstName nvarchar(50) not null,
			 MiddleName nvarchar(50) null,
			 LastName nvarchar(50) not null,
			 Suffix nvarchar(10) null,
			 EmailPromotion int not null,
			 ModifiedDate datetime not null,
			 FOREIGN KEY (BusinessEntityID)
             REFERENCES Person.BusinessEntity (BusinessEntityID)
);
--b
ALTER TABLE dbo.Person
ADD ID bigint identity(10, 10) ;
ALTER TABLE dbo.Person
ADD CONSTRAINT ID primary key (ID, BusinessEntityID);
--c
ALTER TABLE dbo.Person
ADD CONSTRAINT Title_type CHECK (Title IN('Mr.', 'Ms.'));
--d
ALTER TABLE dbo.Person
ADD DEFAULT 'N/A' FOR "Suffix";
--e
INSERT INTO dbo.Person (BusinessEntityID, 
                        PersonType, 
						NameStyle, 
						Title, 
						FirstName, 
						MiddleName, 
						LastName, 
						Suffix,
						EmailPromotion,
						ModifiedDate)

SELECT                  p.BusinessEntityID, 
                        PersonType, 
						NameStyle, 
						Title, 
						FirstName, 
						MiddleName, 
						LastName, 
						Suffix,
						EmailPromotion,
						p.ModifiedDate
FROM Person.Person p, 
     HumanResources.Employee e, 
     HumanResources.EmployeeDepartmentHistory edh, 
	 HumanResources.Department d
WHERE p.BusinessEntityID = e.BusinessEntityID 
AND  e.BusinessEntityID = edh.BusinessEntityID
AND edh.DepartmentID = d.DepartmentID
AND d.Name <> 'Executive';

--F
ALTER TABLE dbo.Person
ALTER COLUMN "Suffix" nvarchar(5);
