/*
  SELECT es equivalente a decir: 'Devuelvame'
  
*/

--USAR LA BASE DE DATOS NORTHWIND
USE Northwind;
GO

--HACER UNA CONSULTA DE TODOS LOS DATOS Y TODAS LAS COLUMNAS DE LA TABLA Suppliers
SELECT * FROM Suppliers;
GO

--Limitar las columnas a mostrar
SELECT  CompanyName,
        ContactName,
        ContactTitle,
        [Address],
        Phone,
        Country
FROM dbo.Suppliers;
GO

--Valores Unicos
SELECT  CustomerID,
        CompanyName,
        Country
FROM Customers;
GO

--Alias
SELECT  CompanyName AS Compañia,
        ContactName AS Persona_Contacto,
        [Address] AS Direccion
FROM dbo.Suppliers;
GO

--El ALIAS tambien puede ser usado de la siguiente forma
SELECT  OrderID,
        UnitPrice,
        Quantity = qty
FROM Sales.OrderDetails;
GO

--ALIAS de tabla
SELECT O.OrderID, O.ProductID, O.UnitPrice
FROM [Order Details] AS O;
GO

--Realizar calculos, consultado la tabla productos
SELECT ProductName, UnitPrice, UnitPrice * 0.12 AS ImpuestoIVA
FROM Products;
GO

SELECT CustomerID, OrderID, OrderDate, YEAR(OrderDate) AS Anio, MONTH(OrderDate) AS Mes
FROM Orders;
GO

SELECT OrderID, PruductID, UnitPrice, Quantity, Discount,
       (UnitPrice * Quantity) - (UnitPrice * Quantity * Discount) AS Partial
FROM [Order Details];
GO

--INSTRUCCION DISTINCT
SELECT  CustomerID,
        CompanyName,
        Country
FROM Customers
ORDER BY Country;
GO

SELECT DISTINCT Country 
FROM Customers
ORDER BY Country;
GO

--Funcion CASE: Devuelven un univo valor(escalar). 
--La clausula SELECT, CASE se comporta como una columna calculada que requiere un alias
SELECT  ProductName, CategoryID
FROM Products;
GO

SELECT  ProductName,
        Category =
        CASE CategoryID
          WHEN 1 THEN 'Bebidas'
          WHEN 2 THEN 'Lacteos'
          WHEN 3 THEN 'Condimentos'
          WHEN 4 THEN 'Otros'
          ELSE 'No en venta'
        END
FROM Products
ORDER BY ProductName;
GO

 
SELECT  ProductName,
        CASE CategoryID
          WHEN 1 THEN 'Bebidas'
          WHEN 2 THEN 'Lacteos'
          WHEN 3 THEN 'Condimentos'
          WHEN 4 THEN 'Otros'
          ELSE 'No en venta'
        END AS Category
FROM Products
ORDER BY ProductName;
GO
