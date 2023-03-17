USE Northwind;
GO

SELECT * 
FROM Customers;
GO

-----Funciones Escalares
--diAS trasncurridos desde la Fecha de pedido hasta hoy
SELECT OrderID, OrderDate
, DATEDIFF(dd, [OrderDate], GETDATE()) AS DiasTranscurridos
FROM orders
GO

--Edad
DECLARE @Fechanacimiento date= '01-25-76'
SELECT DATEDIFF(yy, @Fechanacimiento, GETDATE()) AS Edad
GO

--Usando funcion escalar substring --calculo fila por fila
SELECT CompanyName, SUBSTRING(CompanyName, 1, 3) AS PrimerasTresLetras
FROM Customers
GO

-----Funciones de Agregado---------------
SELECT COUNT(*) 
FROM Customers;
GO

SELECT Country, COUNT(*) 
FROM Customers
GROUP BY Country;
GO

/* Usando funciones de agregado determine cuanto
ha sido el total de ventAS que ha realizado en todas las 
ordenes un ciente, debe usar Customers, orders, [order details]
*/
---Uso de la funcion CAST
SELECT 'El producto: ' + ProductName + ', tiene el precio de: '+ CAST(UnitPrice AS VARCHAR(10)) AS Precio
FROM Products
GO
--

SELECT CAST(SYSDATETIME() AS DATE);
GO
---------CONVERT
SELECT 'El producto: '+ ProductName + ', tiene el precio de: ' + CONVERT(VARCHAR(10), UnitPrice) as Precio
FROM Products
GO

SELECT TRY_CONVERT(INT, ProductName) as Precio
FROM Products
GO

----
SELECT CURRENT_TIMESTAMP as Fecha
SELECT CONVERT(char(8), CURRENT_TIMESTAMP, 101) AS ISO_USA;
SELECT CONVERT(char(8), CURRENT_TIMESTAMP, 102) AS ISO_ANSI;
SELECT CONVERT(char(8), CURRENT_TIMESTAMP, 103) AS ISO_UK_FR;
SELECT CONVERT(char(8), CURRENT_TIMESTAMP, 104) AS ISO_GER;
GO
---PARSE SQL 2012
SELECT PARSE('ddfdf Monday, 13 december 2010' 
AS DATETIME2 USING 'EN-us')  AS Fecha

 SELECT TRY_PARSE('Monday, 13 december 2010' 
 AS DATETIME2 USING 'EN-us')  AS Fecha

 --------------CHOOSE---------
 SELECT ProductName, UnitPrice, 
 choose(categoryid,
'Beverages' ,'Condiments','Confections','Dairy Products'
,'Grains/Cereals','Meat/Poultry','Produce','Seafood') AS category
 FROM Products
 GO

----------------ISNULL
 SELECT CompanyName, FAX FROM Customers
 GO

 SELECT CompanyName, ISNULL(FAX,'0000-0000') FROM Customers
 GO

 SELECT ProductName, UnitPrice, 
 IIF( Discontinued=0 , 'EnExistencia','Descontinuado') 
 AS Discontinued 
 FROM Products
 GO

 -------------------Count
 SELECT COUNT(*) FROM orders  --el numero de filAS
 SELECT COUNT(CustomerID) FROM orders  ---el numero de filas
 SELECT COUNT(DISTINCT CustomerID) FROM orders --el numero de clientes
 GO

 --no repetidos que ordenaron
 SELECT DISTINCT COUNT_BIG(CustomerID) FROM orders
 GO

SELECT COUNT(COALESCE(fax,'00-00')) FROM Customers
GO

SELECT COALESCE(fax,'00-00') FROM Customers
GO

SELECT ISNULL(fax,'00-00') FROM Customers
GO
SELECT DISTINCT Country FROM Customers

SELECT Country FROM Customers
GROUP BY Country
GO

--------------------------------------------------------
SELECT c.CompanyName, p.ProductName
, SUM(od.UnitPrice * od.Quantity) AS total, GROUPING(c.CompanyName)
FROM Customers AS c INNER JOIN orders AS o
on c.CustomerID=o.CustomerID
INNER JOIN [Order Details] AS od
on o.orderid=od.orderid
INNER JOIN Products AS p
on p.ProductID=od.ProductID
GROUP BY  c.CompanyName, p.ProductName with rollup
order by c.CompanyName, p.ProductName
 














