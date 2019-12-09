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
***
*Lab4*
a) Создайте таблицу Production.ProductCategoryHst, которая будет хранить информацию об изменениях в таблице Production.ProductCategory.

Обязательные поля, которые должны присутствовать в таблице: ID — первичный ключ IDENTITY(1,1); Action — совершенное действие (insert, update или delete); ModifiedDate — дата и время, когда была совершена операция; SourceID — первичный ключ исходной таблицы; UserName — имя пользователя, совершившего операцию. Создайте другие поля, если считаете их нужными.

b) Создайте один AFTER триггер для трех операций INSERT, UPDATE, DELETE для таблицы Production.ProductCategory. Триггер должен заполнять таблицу Production.ProductCategoryHst с указанием типа операции в поле Action в зависимости от оператора, вызвавшего триггер.

c) Создайте представление VIEW, отображающее все поля таблицы Production.ProductCategory.

d) Вставьте новую строку в Production.ProductCategory через представление. Обновите вставленную строку. Удалите вставленную строку. Убедитесь, что все три операции отображены в Production.ProductCategoryHst.
***
a) Создайте представление VIEW, отображающее данные из таблиц Production.ProductCategory и Production.ProductSubcategory. Сделайте невозможным просмотр исходного кода представления. Создайте уникальный кластерный индекс в представлении по полям ProductCategoryID, ProductSubcategoryID.

b) Создайте три INSTEAD OF триггера для представления на операции INSERT, UPDATE, DELETE. Каждый триггер должен выполнять соответствующие операции в таблицах Production.ProductCategory и Production.ProductSubcategory.

c) Вставьте новую строку в представление, указав новые данные для ProductCategory и ProductSubcategory. Триггер должен добавить новые строки в таблицы Production.ProductCategory и Production.ProductSubcategory. Обновите вставленные строки через представление. Удалите строки.
***
*Lab5*
Создайте scalar-valued функцию, которая будет принимать в качестве входного параметра имя группы отделов (HumanResources.Department.GroupName) и возвращать количество отделов, входящих в эту группу.

Создайте inline table-valued функцию, которая будет принимать в качестве входного параметра id отдела (HumanResources.Department.DepartmentID), а возвращать 3 самых старших сотрудника, которые начали работать в отделе с 2005 года.

Вызовите функцию для каждого отдела, применив оператор CROSS APPLY. Вызовите функцию для каждого отдела, применив оператор OUTER APPLY.

Измените созданную inline table-valued функцию, сделав ее multistatement table-valued (предварительно сохранив для проверки код создания inline table-valued функции).
***
*Lab6*
Создайте хранимую процедуру, которая будет возвращать сводную таблицу (оператор PIVOT), отображающую данные о суммарном количестве проданных продуктов (Sales.SalesOrderDetail.OrderQty) за определенный год (Sales.SalesOrderHeader.OrderDate). Список лет передайте в процедуру через входной параметр.

Таким образом, вызов процедуры будет выглядеть следующим образом:

EXECUTE dbo.OrdersByYear ‘[2008], [2007], [2006]’
***
*Lab7*
1) Вывести значения полей [BusinessEntityID], [NationalIDNumber] и [JobTitle] из таблицы [HumanResources].[Employee] в виде xml, сохраненного в переменную. Формат xml должен соответствовать примеру:

<Employees>
  <Employee ID="1">
    <NationalIDNumber>295847284</NationalIDNumber>
    <JobTitle>Chief Executive Officer</JobTitle>
  </Employee>
  <Employee ID="2">
    <NationalIDNumber>245797967</NationalIDNumber>
    <JobTitle>Vice President of Engineering</JobTitle>
  </Employee>
</Employees>

Создать временную таблицу и заполнить её данными из переменной, содержащей xml.


