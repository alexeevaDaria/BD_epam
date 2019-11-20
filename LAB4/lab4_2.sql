USE AdventureWorks2012;
GO 

--A
CREATE VIEW Production.ProductCategory_SubVIEW 
WITH SCHEMABINDING
AS
SELECT c.ProductCategoryID, c.Name, c.rowguid, c.ModifiedDate,
       sc.ProductSubcategoryID, sc.Name AS SubName, sc.rowguid AS Subguid, sc.ModifiedDate AS SubDate
FROM Production.ProductCategory c
JOIN Production.ProductSubcategory sc
ON c.ProductCategoryID = sc.ProductCategoryID

CREATE UNIQUE CLUSTERED INDEX id_index
ON Production.ProductCategory_SubVIEW (ProductCategoryID,ProductSubcategoryID); 

--B

CREATE TRIGGER Production.update_ProductTrigger
ON Production.ProductCategory_SubVIEW 
INSTEAD OF UPDATE AS
SET NOCOUNT ON
declare @cID int, @sID int, @nameC nvarchar(50), @nameS nvarchar(50)
begin
     select @cID =  ProductCategoryID from inserted
	 select @sID  = ProductSubcategoryID from inserted
     select @nameC =  Name from inserted
	 select @nameS  = SubName from inserted
    IF UPDATE (Name)
	begin
      UPDATE Production.ProductCategory
	  SET Name = @nameC
	  where ProductCategoryID = @cID
	end

    IF UPDATE (ProductCategoryID)
	begin
      UPDATE Production.ProductSubcategory
	  SET ProductCategoryID = @cID
	  where ProductSubcategoryID = @sID
	end

	IF UPDATE(SubName)
	begin
	  UPDATE Production.ProductSubcategory
	  SET Name = @nameS
	  where ProductSubcategoryID = @sID
	end
end

CREATE TRIGGER Production.insert_ProductTrigger
ON Production.ProductCategory_SubVIEW 
INSTEAD OF INSERT AS
SET NOCOUNT ON
declare @cID int, @sID int, @nameC nvarchar(50), @nameS nvarchar(50);
--insert
begin
	 select @nameC =  Name from inserted
	 select @nameS  = SubName from inserted
    if not exists (select * from ProductCategory p where p.Name = @nameC)
	begin
      INSERT into Production.ProductCategory(Name) 
	  VALUES (@nameC)
	  /*SELECT i.Name
	  from inserted i
	  where i.ProductCategoryID = ProductCategoryID*/
	end

    if not exists (select * from ProductSubcategory p where p.Name = @names)
	and exists (select * from ProductCategory p where p.Name = @nameC)
	begin
	  select @cID = p.ProductCategoryID from Production.ProductCategory p where p.Name = @nameC;
	  INSERT into Production.ProductSubcategory(ProductCategoryID, Name) 
	  VALUES (@cID,@nameS)
	end
end

CREATE TRIGGER Production.delete_ProductTrigger
ON Production.ProductCategory_SubVIEW 
INSTEAD OF DELETE AS
SET NOCOUNT ON
declare @cID int, @sID int, @nameC nvarchar(50), @nameS nvarchar(50);
--delete
begin 
	 select @cID =  ProductCategoryID from deleted
	 select @sID  = ProductSubcategoryID from deleted
    if exists (select * from ProductCategory p where p.ProductCategoryID = @cID) 
	begin
	  if exists(select * from ProductSubcategory s   
	  where @cID = s.ProductCategoryID)
	    DELETE FROM Production.ProductSubcategory
	    WHERE ProductCategoryID = @cID

      DELETE FROM Production.ProductCategory
	  WHERE ProductCategoryID = @cID
	end

	if exists (select * from ProductSubcategory p where p.ProductSubcategoryID = @sID) 
	begin
	  DELETE FROM Production.ProductSubcategory
	  WHERE ProductSubcategoryID = @sID
	end
end;

--C
insert into Production.ProductCategory_SubVIEW ( Name,
        SubName
)
values ('CHAIRS','KITCHEN')

UPDATE Production.ProductCategory_SubVIEW 
SET Name='Tables'
WHERE ProductCategoryID = '17'

UPDATE Production.ProductCategory_SubVIEW 
SET SubName='Dinning room'
WHERE ProductSubcategoryID = '39'

UPDATE Production.ProductCategory_SubVIEW 
SET ProductCategoryID='17'
WHERE ProductSubcategoryID = '39'

DELETE FROM Production.ProductCategory_SubVIEW  WHERE ProductCategoryID = '17'
DELETE FROM Production.ProductCategory_SubVIEW  WHERE ProductSubcategoryID = '38'

select * from Production.ProductCategory
select * from Production.ProductSubcategory
