--Yo hice
SELECT TOP(1) C.CompanyName, COUNT(O.*) 
FROM Customers AS C
INNER JOIN Orders AS O ON O.CustomerID = C.CustomerID
GROUP BY C.CompanyName
ORDER BY COUNT(O.*)
GO

--Resultado
SELECT TOP(1) FROM C.CompanyName, SUM(OD.Quantity*OD.UnitPrice)
FROM Customers AS C
INNER JOIN Orders AS O ON C.CustomerID = O.CustomerID
INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
GROUP BY C.CompanyName
ORDER BY SUM(OD.Quantity*OD.UnitPrice)
GO

DECLARE @orderID = '';
DELETE [Order Details] 
WHERE OrderID = @orderID
DELETE Orders 
WHERE OrderID = @orderID
GO

--Yo hice
DELETE FROM Orders AS O
INNER JOIN [Order Details] AS OD ON OD.OrderID = O.OrderID
INNER JOIN Products AS P ON P.ProductID = OD.ProductID
WHERE P.ProductID = 23
GO

--Resultado
DELETE FROM O
FROM [Order Details] AS OD
INNER JOIN Orders AS O ON O.OrderID = OD.OrderID
WHERE OD.ProductID = 23
GO

SELECT *
FROM Customers AS C
LEFT OUTER JOIN Orders AS O ON O.CustomerID = C.CustomerID
WHERE O.OrderID IS NULL
GO

--Yo hice
UPDATE Products AS P
INNER JOIN [Order Details] AS OD ON P.ProductID = OD.ProductID
INNER JOIN Orders AS O ON O.OrderID = OD.OrderID
SET OD.UnitPrice = (OD.UnitPrice*1.05), P.UnitPrice = (P.UnitPrice*0.05)
WHERE O.YEAR = 1998
GO

--Resultado
UPDATE OD SET OD.UnitPrice = OD.UnitPrice*1.05
FROM [Order Details] AS OD 
INNER JOIN Productos AS P ON P.ProductID = P.ProductID
INNER JOIN Suppliers AS S ON S.SupplierID = P.SupplierID
WHERE S.Country = 'USA'
GO


Cree un script que devuelva la cantidad de unidades vendidas del producto 23.  

--Yo hice
SELECT Quantity
FROM [Order Details]
WHERE ProductID = 23
GO

--Resultado
SELECT SUM(Quantity)
FROM [Order Details]
WHERE ProductID = 23
GO

--7. Cree un script que devuelva todos los clientes que han comprado productos de Estados Unidos, teniendo en cuenta que la procedencia del producto es en base al proveedor.  
--Yo hice
SELECT 	DISTINCT C.CustomerName,
	P.ProductName,
FROM Customer AS C
INNER JOIN Orders AS O ON O.CustomerID = C.CustomerID
INNER JOIN [Order Details] AS OD ON OD.OrderID = O.OrderID
INNER JOIN Products AS P ON P.ProductID = OD.ProductID
INNER JOIN Suppliers AS S ON S.SupplierID = P.ProductID
WHERE S.Country = 'USA'
GROUP BY P.ProductName
GO

--Resultado
SELECT C.CompanyName
FROM Customers AS C 
INNER JOIN Orders AS O ON C.CustomerID = O.CustomerID
INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
INNER JOIN Product AS P ON OD.ProductID = P.ProductID
INNER JOIN Suppliers AS S ON S.SupplierID = P.SupplierID
WHERE S.Country = 'USA'

--8.    Cree un script al que se le ingrese el código del producto a través de asignar el valor a una variable y devuelva los clientes que han solicitado este producto.   
DECLARE @codigo INT = 23;
SELECT DISTINCT C.CompanyName
FROM Customers AS C 
INNER JOIN Orders AS O ON C.CustomerID = O.CustomerID
INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
INNER JOIN Product AS P ON OD.ProductID = P.ProductID
WHERE P.ProductID = @codigo;
GO

--9.   Escriba un script que permita obtener el total de ventas de los clientes de México. 
--Yo hice
SELECT COUNT(*)
FROM [Order Details] AS OD
INNER JOIN Orders AS O ON O.OrderID = OD.OrderID
INNER JOIN Customers AS C ON C.CustomerID = O.CustomerID
WHERE C.Country = 'Mexico'
GO

--Resultado
SELECT C.Country, SUM(D.UnitPrice*D.Quantity) AS Total
FROM Customers AS C
INNER JOIN Orders AS O ON O.CustomerID = C.CustomerID
INNER JOIN [Order Details] AS D ON D.OrderID = O.OrderID
GROUP BY C.Country


--10. Cree una consulta que muestre la unión de las tablas “Customers” y “Suppliers” (unión horizontal) uso solo los campos “Companyname” y “Country”.  
SELECT CompanyName, Country FROM Customers
UNION
SELECT CompanyName, Country FROM Suppliers
GO

--11. Muestre los 10 productos mas caros de la tabla “Products”.  
SELECT TOP(10) ProductName
FROM Products
ORDER BY UnitPrice
GO

--Resultado
SELECT TOP 10 ProductName, UnitPrice
FROM Products
ORDER BY UnitPrice DESC

--12. Escriba una consulta usando la tabla “Employees” que devuelva nombre y apellido del empleado junto con el nombre y apellido del jefe.  
SELECT 	E.FirstName, 
	E.LastName, 
	J.FirstName
FROM Employees AS E
INNER JOIN Employees AS J ON J.ReporstTo = E.EmployeeID
GO
