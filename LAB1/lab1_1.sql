USE master;
GO 


CREATE DATABASE NewDatabase;
GO

USE NewDatabase;
GO

CREATE SCHEMA sales;
GO

CREATE SCHEMA persons;
GO

CREATE table sales.Orders (OrderNum INT NULL);
GO

BACKUP DATABASE NewDatabase
to DISK = 'D:\BD\LAB1\NewDatabase.bak';
GO

USE master;
GO 

DROP DATABASE NewDatabase;
GO

RESTORE DATABASE NewDatabase
  FROM DISK = 'D:\BD\LAB1\NewDatabase.bak'
  WITH NORECOVERY;