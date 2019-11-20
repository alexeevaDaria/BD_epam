USE AdventureWorks2012;
GO 
--a
ALTER TABLE dbo.Person
ADD FullName nvarchar(100) ;
--b
--how i resolve 1077 msg: One way to overcome this error message is not to 
--specify an explicit value for the IDENTITY column when inserting a new row in a table
DECLARE @exPerson TABLE (
             BusinessEntityID int not null,
			 PersonType nchar(2) not null,
			 NameStyle bit not null,
			 Title nvarchar(8) null,
			 FirstName nvarchar(50) not null,
			 MiddleName nvarchar(50) null,
			 LastName nvarchar(50) not null,
			 Suffix nvarchar(5) null,
			 EmailPromotion int not null,
			 ModifiedDate datetime not null,
			 ID bigint identity(10, 10)
);

--SET IDENTITY_INSERT @exPerson ON
INSERT into @exPerson (
       BusinessEntityID,
       PersonType,
	   NameStyle,
	   Title,
	   FirstName,
	   MiddleName,
	   LastName,
	   Suffix,
	   EmailPromotion,
	   p.ModifiedDate
)
SELECT p.BusinessEntityID,
       PersonType,
	   NameStyle,

	   CASE e.Gender WHEN 'M' THEN 'Mr.'
	                 WHEN 'F' THEN 'Ms.'
					 END AS Title,
	   FirstName,
	   MiddleName,
	   LastName,
	   Suffix,
	   EmailPromotion,
	   p.ModifiedDate
FROM dbo.Person p
INNER JOIN HumanResources.Employee e
ON p.BusinessEntityID = e.BusinessEntityID;

--c
UPDATE dbo.Person
SET FullName = CONCAT(e.Title, e.FirstName, e.LastName)
FROM @exPerson e
WHERE dbo.Person.BusinessEntityID = e.BusinessEntityID;
--d
DELETE FROM dbo.Person 
WHERE LEN(FullName) > 20;
--default constraints
SELECT *
FROM AdventureWorks2012.INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Person';

--delete constraints
DECLARE @dbo VARCHAR(5)
DECLARE @person VARCHAR(10)
DECLARE @sql NVARCHAR(MAX) = N''

SET @dbo = 'dbo'
SET @person = 'person'

select @sql = @sql + 'alter table ' + @dbo + '.' + @person + ' DROP CONSTRAINT '+ advW.CONSTRAINT_NAME + ' '
from AdventureWorks2012.INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE advW
WHERE TABLE_SCHEMA = @dbo AND TABLE_NAME = @Person

print @sql;
execute(@sql);

--extract default values

SELECT isc.column_name, isc.column_default
FROM information_schema.columns isc
WHERE table_schema = 'dbo' and table_name = 'Person'
ORDER BY ordinal_position;

--'modify' in server sql is 'alter column'
DECLARE @cmd NVARCHAR(MAX) = N''

select @cmd = @cmd + 'ALTER TABLE dbo.Person DROP CONSTRAINT ' + so.name + ' ; '
from sysobjects so
join sysconstraints sc ON so.id = sc.constid
where sc.id = OBJECT_ID('dbo.Person')

print @cmd
exec(@cmd)

--e
DROP TABLE dbo.Person