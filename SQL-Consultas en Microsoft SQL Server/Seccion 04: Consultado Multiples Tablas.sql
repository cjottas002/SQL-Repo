USE Northwind;
GO

--INNER JOIN
--ISO-ANSI SQL-92
SELECT [Customers].[CustomerID], [Customers].[CompanyName], [Customers].[ContactName], 
[Orders].[OrderID], [Orders].[OrderDate]
FROM [Customers]
INNER JOIN [Orders] 
ON [Orders].[CustomerID] = [Customers].[CustomerID];
GO

--ISO-ANSI SQL-89
SELECT [Customers].[CustomerID], [Customers].[CompanyName], [Customers].[ContactName], 
[Orders].[OrderID], [Orders].[OrderDate]
FROM [Customers], [Orders]
WHERE [Orders].[CustomerID] = [Customers].[CustomerID];
GO


--CONSULTA MAS DE DOS TABLAS
SELECT [C].[CustomerID], [C].[CompanyName], [C].[ContactName], 
[O].[OrderID], [O].[OrderDate], [P].[ProductName], [OD].[UnitPrice], [OD].[Quantity]
FROM [Customers] AS C
INNER JOIN [Orders] AS O ON [O].[CustomerID] = [C].[CustomerID]
INNER JOIN [Order Details] AS OD ON [OD].[OrderID] = [O].[OrderID]
INNER JOIN [Products] AS P ON [P].[ProductID] = [OD].[ProductID];
GO

SELECT [P].[ProductName], [S].[CompanyName], [C].[CategoryName]
FROM [Products] AS P
INNER JOIN [Suppliers] AS S ON [S].[SupplierID] = [S].[SupplierID]
INNER JOIN [Categories] AS C ON [P].[CategoryID] = [C].[CategoryID];
GO

-----------------------------------OUTER JOIN---------------------------------------------------------------------
--COMBINA DOS TABLAS Y DEVUELVE TODAS LAS FILAS DONDE TODAS LAS FILAS DONDE AMBAS TABLAS COINCIDEN + LAS FILAS QUE NO COINCIDEN DE UNA DE LAS DOS TABLAS
--SI ES LEFT DE LA TABLA DE LA IZQUIERDA Y SI ES RIGHT DE LA TABLA DE LA DERECHA
--FULL ES LA COMBINACION DE TODAS LAS FILAS QUE COINCIDEN DE AMBAS TABLAS + LAS FILAS QUE NO COINCIDEN DE NINGUNA DE LAS TABLAS (NO CONFUNDIR CON CROSS JOIN)

--LEFT OUTER JOIN
SELECT [Customers].[CustomerID], [Customers].[CompanyName], [Customers].[ContactName], 
[Orders].[OrderID], [Orders].[OrderDate]
FROM [Customers]
LEFT OUTER JOIN [Orders] 
ON [Orders].[CustomerID] = [Customers].[CustomerID]
GO


--RIGHT OUTER JOIN
SELECT [Customers].[CustomerID], [Customers].[CompanyName], [Customers].[ContactName], 
[Orders].[OrderID], [Orders].[OrderDate]
FROM [Customers]
RIGHT OUTER JOIN [Orders] 
ON [Orders].[CustomerID] = [Customers].[CustomerID];
GO

--FULL OUTER JOIN
SELECT [Customers].[CustomerID], [Customers].[CompanyName], [Customers].[ContactName], 
[Orders].[OrderID], [Orders].[OrderDate]
FROM [Customers]
FULL OUTER JOIN [Orders] 
ON [Orders].[CustomerID] = [Customers].[CustomerID];
GO

--CROSS JOIN
--COMBINACION DE TODAS LAS FILAS DE LA TABLA A CON LOS DE LA TABLA B. DEVUELVE UN PRODUCTO CARTESIANO
SELECT [Customers].[CustomerID], [Customers].[CompanyName], [Customers].[ContactName], 
[Orders].[OrderID], [Orders].[OrderDate]
FROM [Customers]
CROSS JOIN [Orders] --ES POCO FUNCIONAL EN PRODUCCION, SOLO COMO CONCEPTO MATEMATICO
GO


--SELF JOIN
SELECT [J].[FirstName], [J].[LastName], [S].[FirstName], [S].[LastName]
FROM [Employees] AS J
INNER JOIN [Employees] AS S
ON [J].[EmployeeID] = [S].[ReportsTo]
WHERE S.FirstName IS NOT NULL;
GO

 

