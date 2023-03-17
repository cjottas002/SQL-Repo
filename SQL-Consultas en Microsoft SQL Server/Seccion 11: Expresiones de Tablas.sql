---EXPRESIONES DE TABLA
--EXPRESIONES QUE DEVUELVEN SET DE DATOS COMO LA VISTA
USE Northwind;
GO

----VISTA
CREATE VIEW Ventas --(Compania, factura, fecha, producto, precio, cantidad) SE LE PUEDEN CAMBIAR LOS NOMBRES A LAS COLUMNAS DE UNA VISTA
AS
	SELECT	C.CustomerID,
			C.CompanyName,
			C.Country,
			O.OrderID,
			O.OrderDate,
			P.ProductName,
			D.UnitPrice,
			D.Quantity,
			(D.UnitPrice * D.Quantity) AS Total
	FROM Customers AS C
	INNER JOIN Orders AS O ON O.CustomerID = C.CustomerID
	INNER JOIN [Order Details] AS D ON D.OrderID = O.OrderID
	INNER JOIN Products AS P ON P.ProductID = D.ProductID
	--ORDER BY O.OrderDate NO PUEDE IR EN UNA VISTA POR SI SOLA SOLAMENTE CON EL USO DE TOP, OFFSET/FETCH O FOR XML
GO

SELECT * FROM Ventas;
GO

DROP VIEW Ventas;
GO


--------------------FUNCIONES DE TABLA EN LINEA (ADMITE PARAMETROS)
--FUNCION ESCALAR (DEVUELVE UN VALOR)


--FUNCION CON VALORES DE TABLA EN LINEA
CREATE FUNCTION fn_LineTotal(@orderID INT)
RETURNS TABLE
AS
RETURN
	SELECT  orderID,
			CAST((Quantity*UnitPrice * (1 - discount)) AS DECIMAL(8,2)) AS line_total
	FROM [Order Details]
	WHERE OrderID = @orderID;
GO

CREATE FUNCTION Ventas_Producto(@idProducto INT)
RETURNS TABLE
AS
RETURN
	(SELECT	C.CompanyName,
			O.OrderID,
			O.OrderDate,
			P.ProductID,
			P.ProductName,
			D.UnitPrice,
			D.Quantity
	FROM Customers AS C
	INNER JOIN Orders AS O ON O.CustomerID = C.CustomerID
	INNER JOIN [Order Details] AS D ON D.OrderID = O.OrderID
	INNER JOIN [Products] AS P ON P.ProductID = D.ProductID
	WHERE P.ProductID = @idProducto)
GO

--USAR LA FUNCION
SELECT * FROM Ventas_Producto(23)
GO

--ELIMINAR UNA FUNCION
DROP FUNCTION Ventas_Producto;
GO


--------------------TABLAS DERIVADAS
--SUB-CONSULTAS QUE NO SE QUEDAN ALMACENADAS COMO UNA VISTA O UNA FUNCION

SELECT T.CompanyName, T.OrderID, SUM(T.UnitPrice * T.Quantity)
FROM
	(SELECT	C.CompanyName,
				O.OrderID,
				O.OrderDate,
				P.ProductID,
				P.ProductName,
				D.UnitPrice,
				D.Quantity
		FROM Customers AS C
		INNER JOIN Orders AS O ON O.CustomerID = C.CustomerID
		INNER JOIN [Order Details] AS D ON D.OrderID = O.OrderID
		INNER JOIN [Products] AS P ON P.ProductID = D.ProductID) AS T
GROUP BY T.CompanyName, T.OrderID;
GO

--PASANDOLE VARIABLE POR PARAMETRO
DECLARE @anio BIGINT
SET @anio = 1996
SELECT N.CompanyName, N.OrderID, N.Total
FROM
(SELECT T.CompanyName, T.OrderID, SUM(T.UnitPrice * T.Quantity) AS Total
FROM
	(SELECT	C.CompanyName,
				O.OrderID,
				O.OrderDate,
				P.ProductID,
				P.ProductName,
				D.UnitPrice,
				D.Quantity
		FROM Customers AS C
		INNER JOIN Orders AS O ON O.CustomerID = C.CustomerID
		INNER JOIN [Order Details] AS D ON D.OrderID = O.OrderID
		INNER JOIN [Products] AS P ON P.ProductID = D.ProductID
		WHERE YEAR(O.OrderDate) = @anio
) AS T
GROUP BY T.CompanyName, T.OrderID) AS N
WHERE N.OrderID > 11000;
GO


	--Tabla relacional virtual
SELECT T.Jefe, COUNT(T.Subalterno) AS NumSubalterno
FROM
	(SELECT	J.FirstName + ' ' + J.LastName AS Jefe,
			S.FirstName + ' ' + S.LastName AS Subalterno
	FROM Employees AS J
	INNER JOIN Employees AS S ON S.ReportsTo = J.EmployeeID) AS T --(Jefe, Subalterno) EL ALIAS SE PUEDE COLOCAR FUERA DE LA SUBCONSULTA TAMBIEN
GROUP BY T.Jefe;
GO



-------------------COMMON TABLE EXPRESSION (CTEs) (SON TABLAS DERIVADAS CON NOMBRE)
USE Northwind;
GO

WITH CTE_year AS(
SELECT CustomerID, YEAR(OrderDate) AS YearOrder
FROM Orders)--SOLO EXISTE EN TIEMPO DE EJECUCION

SELECT YearOrder, COUNT(DISTINCT CustomerID)
FROM CTE_year
GROUP BY YearOrder;
GO

