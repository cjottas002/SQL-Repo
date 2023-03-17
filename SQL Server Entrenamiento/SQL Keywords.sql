--Adds a column in an existing table
ALTER TABLE Customers
ADD Email varchar(255);

--Adds a constraint after a table is already created
ALTER TABLE Persons
ADD CONSTRAINT PK_Person PRIMARY KEY (ID,LastName);

--Returns true if all of the subquery values meet the condition
SELECT ProductName
FROM Products
WHERE ProductID = ALL (SELECT ProductID FROM OrderDetails WHERE Quantity = 10);

--	Adds, deletes, or modifies columns in a table, or changes the data type of a column in a table
ALTER TABLE Customers
ADD Email varchar(255);

--Changes the data type of a column in a table
ALTER TABLE Employees
ALTER COLUMN BirthDate year;

--	Adds, deletes, or modifies columns in a table
ALTER TABLE Customers
ADD Email varchar(255);

--	Only includes rows where both conditions is true
SELECT * FROM Customers
WHERE Country='Germany' AND City='Berlin';

--	Returns true if any of the subquery values meet the condition
SELECT ProductName
FROM Products
WHERE ProductID = ANY (SELECT ProductID FROM OrderDetails WHERE Quantity = 10);

--Renames a column or table with an alias
SELECT CustomerID AS ID, CustomerName AS Customer
FROM Customers;

--Sorts the result set in ascending order
SELECT * FROM Customers
ORDER BY CustomerName ASC;

--Creates a back up of an existing database
BACKUP DATABASE testDB
TO DISK = 'D:\backups\testDB.bak';

--	Selects values within a given range
SELECT * FROM Products
WHERE Price BETWEEN 10 AND 20;

--	Creates different outputs based on conditions
SELECT OrderID, Quantity,
CASE
    WHEN Quantity > 30 THEN 'The quantity is greater than 30'
    WHEN Quantity = 30 THEN 'The quantity is 30'
    ELSE 'The quantity is under 30'
END
FROM OrderDetails;

--A constraint that limits the value that can be placed in a column.
--The following SQL creates a CHECK constraint on the "Age" column when the "Persons" table is created. The CHECK constraint ensures that you can not have any person below 18 years
CREATE TABLE Persons (
    Age int,
    CHECK (Age>=18)
);

--Changes the data type of a column or deletes a column in a table
ALTER TABLE Employees
ALTER COLUMN BirthDate year;

--	Adds or deletes a constraint
ALTER TABLE Persons
ADD CONSTRAINT PK_Person PRIMARY KEY (ID,LastName);

--Creates a database, index, view, table, or procedure
CREATE DATABASE testDB;

CREATE CLUSTERED INDEX IX_Contact_Email
ON [Person].[Contact] (Email); 

CREATE VIEW view_FactInternetSalesTerritory  
AS 
SELECT fis.CustomerKey, fis.ProductKey, fis.OrderDateKey, 
  fis.SalesTerritoryKey, dst.SalesTerritoryRegion  
FROM FactInternetSales AS fis   
LEFT OUTER JOIN DimSalesTerritory AS dst   
ON (fis.SalesTerritoryKey=dst.SalesTerritoryKey);

--Creates a new SQL database
CREATE DATABASE testDB;

--Creates an index on a table (allows duplicate values)
CREATE INDEX idx_lastname
ON Persons (LastName);

--	Creates a unique index on a table (no duplicate values)
CREATE UNIQUE INDEX uidx_pid
ON Persons (PersonID);

--Updates a view
CREATE OR REPLACE VIEW [Brazil Customers] AS
SELECT CustomerName, ContactName, City
FROM Customers
WHERE Country = "Brazil";

--	Creates a new table in the database
CREATE TABLE Persons (
    PersonID int,
    LastName varchar(255),
    FirstName varchar(255),
    Address varchar(255),
    City varchar(255)
);

--Creates a stored procedure
CREATE PROCEDURE SelectAllCustomers
AS
SELECT * FROM Customers
GO;

--	Creates a view based on the result set of a SELECT statement
CREATE VIEW [Brazil Customers] AS
SELECT CustomerName, ContactName
FROM Customers
WHERE Country = "Brazil";

--A constraint that provides a default value for a column
CREATE TABLE Persons (
    City varchar(255) DEFAULT 'Sandnes'
);

--Deletes rows from a table
DELETE FROM Customers WHERE CustomerName='Alfreds Futterkiste';

--	Sorts the result set in descending order
SELECT * FROM Customers
ORDER BY CustomerName DESC;

--Selects only distinct (different) values
SELECT DISTINCT Country FROM Customers;

--	Deletes a column, constraint, database, index, table, or view
ALTER TABLE Customers
DROP COLUMN ContactName;

--Deletes a column in a table
ALTER TABLE Customers
DROP COLUMN ContactName;

--Deletes a UNIQUE, PRIMARY KEY, FOREIGN KEY, or CHECK constraint
ALTER TABLE Persons
DROP CONSTRAINT UC_Person;

--Deletes an existing SQL database
DROP DATABASE testDB;

--Deletes a DEFAULT constraint
ALTER TABLE Persons
ALTER COLUMN City DROP DEFAULT;

--Deletes an index in a table
DROP INDEX table_name.index_name;

--Deletes an existing table in the database
DROP TABLE Shippers;

--Deletes a view
DROP VIEW [Brazil Customers];

--	Executes a stored procedure
EXEC SelectAllCustomers;

--Tests for the existence of any record in a subquery
SELECT SupplierName
FROM Suppliers
WHERE EXISTS (SELECT ProductName FROM Products WHERE SupplierId = Suppliers.supplierId AND Price < 20);

--A constraint that is a key used to link two tables together
CREATE TABLE Orders (
    OrderID int NOT NULL PRIMARY KEY,
    OrderNumber int NOT NULL,
    PersonID int FOREIGN KEY REFERENCES Persons(PersonID)
);

CREATE TABLE Orders (
    OrderID int NOT NULL,
    OrderNumber int NOT NULL,
    PersonID int,
    PRIMARY KEY (OrderID),
    CONSTRAINT FK_PersonOrder FOREIGN KEY (PersonID)
    REFERENCES Persons(PersonID)
);

ALTER TABLE Orders
ADD FOREIGN KEY (PersonID) REFERENCES Persons(PersonID);

ALTER TABLE Orders
ADD CONSTRAINT FK_PersonOrder
FOREIGN KEY (PersonID) REFERENCES Persons(PersonID);

ALTER TABLE Orders
DROP CONSTRAINT FK_PersonOrder;

--Specifies which table to select or delete data from
SELECT CustomerName, City FROM Customers;

--Returns all rows when there is a match in either left table or right table
SELECT Customers.CustomerName, Orders.OrderID
FROM Customers
FULL OUTER JOIN Orders ON Customers.CustomerID=Orders.CustomerID
ORDER BY Customers.CustomerName;

--Groups the result set (used with aggregate functions: COUNT, MAX, MIN, SUM, AVG)
SELECT COUNT(CustomerID), Country
FROM Customers
GROUP BY Country;

--Used instead of WHERE with aggregate functions
SELECT COUNT(CustomerID), Country
FROM Customers
GROUP BY Country
HAVING COUNT(CustomerID) > 5;

--Allows you to specify multiple values in a WHERE clause
SELECT * FROM Customers
WHERE Country IN ('Germany', 'France', 'UK');

--	Creates or deletes an index in a table
CREATE INDEX idx_lastname
ON Persons (LastName);

CREATE INDEX idx_pname
ON Persons (LastName, FirstName);

--Returns rows that have matching values in both tables
SELECT Orders.OrderID, Customers.CustomerName
FROM Orders
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID;

--Inserts new rows in a table
INSERT INTO Customers (CustomerName, ContactName, Address, City, PostalCode, Country)
VALUES ('Cardinal', 'Tom B. Erichsen', 'Skagen 21', 'Stavanger', '4006', 'Norway');

--Copies data from one table into another table
INSERT INTO Customers (CustomerName, City, Country)
SELECT SupplierName, City, Country FROM Suppliers;

--Tests for empty values
SELECT CustomerName, ContactName, Address
FROM Customers
WHERE Address IS NULL;

--Tests for non-empty values
SELECT CustomerName, ContactName, Address
FROM Customers
WHERE Address IS NOT NULL;

--	Returns all rows from the left table, and the matching rows from the right table
SELECT Customers.CustomerName, Orders.OrderID
FROM Customers
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID
ORDER BY Customers.CustomerName;

--Searches for a specified pattern in a column
SELECT * FROM Customers
WHERE CustomerName LIKE 'a%';

--	Specifies the number of records to return in the result set
SELECT TOP 3 * FROM Customers;


--Only includes rows where a condition is not true
SELECT * FROM Customers
WHERE NOT Country='Germany';

--A constraint that enforces a column to not accept NULL values
CREATE TABLE Persons (
    ID int NOT NULL,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255) NOT NULL,
    Age int
);

--Includes rows where either condition is true
SELECT * FROM Customers
WHERE City='Berlin' OR City='München';

--Sorts the result set in ascending or descending order
SELECT * FROM Customers
ORDER BY CustomerName;

--Returns all rows when there is a match in either left table or right table
SELECT Customers.CustomerName, Orders.OrderID
FROM Customers
FULL OUTER JOIN Orders ON Customers.CustomerID=Orders.CustomerID
ORDER BY Customers.CustomerName;

--A constraint that uniquely identifies each record in a database table
CREATE TABLE Persons (
    ID int NOT NULL PRIMARY KEY,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int
);

CREATE TABLE Persons (
    ID int NOT NULL,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int,
    CONSTRAINT PK_Person PRIMARY KEY (ID,LastName)
);

ALTER TABLE Persons
ADD PRIMARY KEY (ID);

ALTER TABLE Persons
ADD CONSTRAINT PK_Person PRIMARY KEY (ID,LastName);

ALTER TABLE Persons
DROP CONSTRAINT PK_Person;