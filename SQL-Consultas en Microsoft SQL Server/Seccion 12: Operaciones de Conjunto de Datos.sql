---UNION, EXCEPT, INTERSECT AND APPLY
USE Northwind;
GO

--DEBEN TENER EL MISMO TIPO DE COLUMNA Y EL MISMO TIPO DE DATOS PARA USAR UNION ALL
/*
	UNION ALL DEVUELVE TODOS LOS ELEMENTOS AUNQUE ESTEN REPETIDOS
	UNION DEVUELVE TODOS LOS ELEMENTOS, PERO LAS FILAS SON DISTINTAS, PUEDE AFECTAR EL RENDIMIENTO
*/
SELECT CompanyName, ContactName, City, Country 
FROM Customers
UNION ALL
SELECT CompanyName, ContactName, City, Country 
FROM Suppliers; 
GO

--INTERSECT, DEVUELVE SOLO FILAS IGUALES QUE APARECEN EN AMBOS CONJUNTOS DE RESULTADOS
SELECT Country, Region, City
FROM Employees
INTERSECT
SELECT Country, Region, City
FROM Customers
GO

SELECT CustomerID FROM Customers
INTERSECT
SELECT CustomerID FROM Orders
GO

--EXCEPT DEVUELVE SOLO FILAS DISTINTAS QUE APRECEN EN EL CONJUNTO DE LA IZQUIERDA, PERO NO EN EL DERECHO
SELECT Country, Region, City
FROM Employees
EXCEPT
SELECT Country, Region, City
FROM Customers
GO

---------------------------------CROSS APPLY Y OUTER APPLY---------------------------------------
--DEVUELVE POR CADA FILA DE LA TABLA IZQUIERDA UNA EXPRESION DE TABLA DE LA DERECHA (SIMILAR A INNER JOIN, PERO PUEDE CORRELACIONAR DATOS ENTRE FUENTES)
SELECT S.SupplierID, S.CompanyName, P.ProductID, P.ProductName, P.UnitPrice
FROM Suppliers AS S
CROSS APPLY
	dbo.fn_TopProductsByShipper(S.SupplierID) AS P
GO

--FUNCION DE TABLA EN LINEA
CREATE FUNCTION fn_Cliente_Ordenes(@codigoCliente VARCHAR(5))
RETURNS TABLE 
AS
RETURN
	(
		SELECT OrderID, OrderDate
		FROM Orders
		WHERE CustomerID = @codigoCliente
	)
GO

--revisar funcion
SELECT * FROM fn_Cliente_Ordenes('ANTON');
GO

--UNION ENTRE LA TABLA CUSTOMERS Y LA FUNCION FN_CLIENTE_ORDENES (INNER JOIN NO PUEDE REALIZAR ESTA UNION)
SELECT	C.CustomerID,
		C.CompanyName,
		C.Country,
		O.OrderID,
		O.OrderDate
FROM Customers AS C
CROSS APPLY fn_Cliente_Ordenes(C.CustomerID) AS O
ORDER BY C.CustomerID
GO


----OUTER APPLY (SIMILAR A LEFT OUTER JOIN)
SELECT	S.SupplierID, 
		S.CompanyName,
		P.ProductID, 
		P.UnitPrice
FROM Suppliers AS S
OUTER APPLY
		dbo.fn_TopProductsByShipper(S.SupplierID) AS P
GO

--FUNCION DE TABLA EN LINEA
CREATE FUNCTION fn_Cliente_Ordenes(@codigoCliente VARCHAR(5))
RETURNS TABLE 
AS
RETURN
	(
		SELECT OrderID, OrderDate
		FROM Orders
		WHERE CustomerID = @codigoCliente
	)
GO

--revisar funcion
SELECT * FROM fn_Cliente_Ordenes('ANTON');
GO

--UNION ENTRE LA TABLA CUSTOMERS Y LA FUNCION FN_CLIENTE_ORDENES (OUTER JOIN NO PUEDE REALIZAR ESTA UNION)
SELECT	C.CustomerID,
		C.CompanyName,
		C.Country,
		O.OrderID,
		O.OrderDate
FROM Customers AS C
OUTER APPLY fn_Cliente_Ordenes(C.CustomerID) AS O
ORDER BY C.CustomerID
GO


