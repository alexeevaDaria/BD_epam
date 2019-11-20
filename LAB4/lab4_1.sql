USE AdventureWorks2012;
GO 

--A
CREATE TABLE Production.ProductCategoryHst(
             ID bigint identity(1, 1),
			 Action_ nvarchar(8) null,
			 ModifiedDate datetime not null,
			 SourceID int not null,
			 UserName nvarchar(50) not null,
			 PRIMARY KEY (ID)
);

alter table Production.ProductCategoryHst
Add constraint action_type check (Action_ in ('insert','update','delete'));

--B

CREATE TRIGGER Production.MyProductTrigger
ON Production.ProductCategory
AFTER UPDATE, INSERT, DELETE AS
SET NOCOUNT ON
declare @EmpID int, @user nvarchar(50), @activity nvarchar(8), @dataMod datetime;
if exists(SELECT * from inserted) and exists (SELECT * from deleted)
begin
    SET @activity = 'update';
    SELECT @user = Name from inserted i;
    SELECT @EmpID = ProductCategoryID from inserted i;
	SELECT @dataMod = ModifiedDate from inserted i;
    INSERT into Production.ProductCategoryHst(Action_, ModifiedDate, SourceID, UserName) 
	values (@activity,@dataMod,@EmpID,@user);
end

If exists (Select * from inserted) and not exists(Select * from deleted)
begin
    SET @activity = 'insert';
    SELECT @user = Name from inserted i;
    SELECT @EmpID = ProductCategoryID from inserted i;
	SELECT @dataMod = ModifiedDate from inserted i;
    INSERT into Production.ProductCategoryHst(Action_, ModifiedDate, SourceID, UserName) 
	values (@activity,@dataMod,@EmpID,@user);
end

If exists(select * from deleted) and not exists(Select * from inserted)
begin 
    SET @activity = 'update';
    SELECT @user = Name from deleted i;
    SELECT @EmpID = ProductCategoryID from deleted i;
	SELECT @dataMod = ModifiedDate from deleted i;
    INSERT into Production.ProductCategoryHst(Action_, ModifiedDate, SourceID, UserName) 
	values (@activity,@dataMod,@EmpID,@user);
end

--C
CREATE VIEW Production.ProductCategoryVIEW AS
SELECT ProductCategoryID, Name, rowguid, ModifiedDate
FROM Production.ProductCategory

--D
insert into Production.ProductCategoryVIEW (
           Name
)
VALUES ('Books')

update Production.ProductCategoryVIEW
set Name = 'Book'
WHERE ProductCategoryID='12'

delete from Production.ProductCategoryVIEW where ProductCategoryID='12'
--

select * from Production.ProductCategory
select * from Production.ProductCategoryHst