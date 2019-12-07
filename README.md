# BD_epam

(AdventureWorks2012 was used as a target DataBase)
**TASKS**

*Lab1*
 -  BackUp DataBase
 -  Display all employees, whose position is in lists:   
                                                         -‘Accounts Manager’,
                                                         -’Benefits Specialist’,
                                                         -’Engineering Manager’,
                                                         -’Finance Manager’,
                                                         -’Maintenance Supervisor’,
                                                         -’Master Scheduler’,
                                                         -’Network Manager’. 
 -  Display everyone who was employed after 2004 including 2004
 -  Display 5 youngest married employees who were employed after 2004 including 2004
***
*Lab2*
 - 1 
      - Display list of employees and their maximun wage
      Break all hour-wages in groups[RankRate] so the equal ones would be in the same group
      Numbers are asc
      - Display all the information about departments and their employees, sorted by ShiftID in 'Documnet Control' Department
      and sorted by BusinessEntityID in others.
 - 2
      - a) create table dbo.Person with the structure of Person.Person, except xml fields, uniqueidentifier, without indexes,
         restrictions and triggers;
      - b) using ALTER TABLE, add to the table dbo.Person new ID field, which represents Primary Key of type bigint and has
         identity attribute. Start value is 10 with increment of +10;
      - c) using ALTER TABLE, for dbo.Person table create restriction for Title field, 
         so only values ‘Mr.’ or ‘Ms.’ could be stored in it;
      - d) using ALTER TABLE, for dbo.Person table create DEFAULT restriction for Suffix field, default value is ‘N/A’;
      - e) fill in new table with data from Person.Person only for employees, who exist in a HumanResources.Employee table,
         except employees from ‘Executive’ department;
      - f) change Suffix field size to 5 symbols.
***
*Lab3*
-  1
      - a) to the table dbo.Person add FullName field of nvarchar type with size 100;
      - b) declare table variable with the structure of dbo.Person and fill it with data of dbo.Person. Title field 
         fill in with data from Gender field of HumanResources.Employee table, so if gender=M then Title=’Mr.’, if gender=F 
         then Title=’Ms.’;
      - c) update FullName field in dbo.Person table with data from table variable mentioned above, join it with info from
         Title, FirstName, LastName fields(example ‘Mr. Jossef Goldberg’);
      - d) delete all info from dbo.Person table, where number of symbols in the FullName field is bigger than 20;
      - e) delete all restrictions and default values. After that delete ID field
      - f) delete dbo.Person table.
-  2  
      - a) execute Lab2,
         add SalesYTD MONEY, SalesLastYear MONEY and OrdersNum INT fields to dbo.Person table, 
         create calculated field SalesDiff, ( SalesYTD - SalesLastYear ).
      - b) create temporary table #Person, with PK of BusinessEntityID. This table should have all fields of dbo.Person table except
         SalesDiff field.
      - c) fill in #Person table with info from dbo.Person table. SalesYTD, SalesLastYear fields fill in with Sales.SalesPerson table. 
         Calculate orders by employees (SalesPersonID) of Sales.SalesOrderHeader and fill OrdersNum field with them. 
         Use Common Table Expression (CTE).
      - d) delete 1 line from dbo.Person (where BusinessEntityID = 290)
      - e) write Merge, that uses dbo.Person as a target, and #Person as source.
         Сommunicate through BusinessEntityID. Update SalesYTD, SalesLastYear, OrdersNum in dbo.Person table, if record exists in source
         and target. Add to dbo.Person if exists in source and doesnt in target, добавьте строку в dbo.Person.
         Delete from dbo.Person if the record exists only in target.
         
