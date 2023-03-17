/*
	SUB-CONSULTAS
		- CONSULTAS ANIDADAS
		- LOS RESULTADOS DE LA CONSULTA INTERNA SON PASADOS A LA CONSULTA EXTERNA
		- LAS SUBCONSULTAS PUEDEN SER INDEPENDIENTES O CORRELACIONADAS
		- LAS SUBCONSULTAS PUEDEN SER ESCALARES, MULTIVALUADAS O CON VALORES DE TABLA
	
*/

-----SUB-CONSULTAS INDEPENDIENTES
USE Northwind;
GO

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
INNER JOIN Products AS P ON P.ProductID = D.ProductID;
GO

---CONVERTIR EL SET DE  DATOS ANTERIOR A SUB-CONSULTA
SELECT T.CompanyName, SUM(T.Total) AS Total FROM
(
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
) AS T
GROUP BY T.CompanyName;
GO


--SUBCONSULTAS CON SET DE DATOS (MULTIVALUADOS)
--COMPARACION DE DOS TABLAS CON UNA CONJUNTO DE DATOS
SELECT	CompanyName,
		Country,
		Phone,
		Fax
FROM Customers
WHERE CustomerID IN (
						SELECT DISTINCT CustomerID
						FROM Orders
					)
GO

SELECT	CompanyName,
		Country,
		Phone,
		Fax
FROM Customers
WHERE CustomerID NOT IN (
					SELECT DISTINCT CustomerID
					FROM Orders
					)
GO

--SUB-CONSULTA ESCALAR (DEVUELVE UN VALOR)
SELECT  OrderID, 
		ProductID,
		UnitPrice,
		Quantity
FROM [Order Details]
WHERE OrderID = (
					SELECT MAX(OrderID) AS LastOrder
					FROM Orders
				)
GO

-------------------------------------------SUB-CONSULTAS ANIDADAS Y USO DE EXIST--------------------------------
--CONSULTA ANONIMA YA QUE EL RESULTADO LO CONVIERTO EN UN ALIAS
--SUB-CONSULTA COMO TABLA DERIVADA
SELECT T.CompanyName, SUM(T.Total) AS Total FROM
	(
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
	) AS T
GROUP BY T.CompanyName;
GO

SELECT	T.Anio, 
		T.UnitPrice, 
		T.Quantity 
FROM (SELECT C.Country,
			C.CompanyName,
			C.CustomerID,
			O.OrderID,
			O.OrderDate,
			DATEPART(yyyy, O.OrderDate) AS Anio,
			DATEPART(mm, O.OrderDate) AS Mes,
			P.ProductName,
			D.UnitPrice,
			D.Quantity,
			(D.UnitPrice * D.Quantity) AS Parcial
			FROM Customers AS C
			INNER JOIN Orders AS O ON C.CustomerID = O.CustomerID
			INNER JOIN [Order Details] AS D ON D.OrderID = O.OrderID
			INNER JOIN Products AS P ON P.ProductID = D.ProductID) AS T
GO

--SUBQUERY DEVUELTO COMO UN ESCALAR CALCULADO
--FILA POR FILA
SELECT	ProductName, 
		UnitPrice, 
		(SELECT AVG(UnitPrice) FROM Products) AS Average,
		(SELECT AVG(UnitPrice) FROM Products) - UnitPrice AS Varianza
FROM Products
GO

--SUB-CONSULTAS CORRELACIONADAS
--PASO DE PARAMETRO DE UNA CONSULTA EXTERNA A UNA INTERNA
SELECT CustomerID, CompanyName, ContactName, Country
FROM Customers AS C
WHERE EXISTS (SELECT * FROM Orders AS O
				WHERE C.CustomerID = O.CustomerID)
GO

--TAMBIEN SE PUEDE HACER CON INNER JOIN
SELECT O.CustomerID, O.OrderID, O.OrderDate
FROM Orders AS O
WHERE
	(
	SELECT D.Quantity
	FROM [Order Details] AS D
	WHERE D.ProductID = 23 AND D.OrderID = O.OrderID
	) > 20

--SUBQUERY CON RESULTADO DE MULTIPLES VALORES
SELECT C.CompanyName, C.Country, C.ContactName
FROM Customers AS C
WHERE EXISTS (
				SELECT O.CustomerID
				FROM Orders AS O
				WHERE C.CustomerID = O.CustomerID)
GO

SELECT C.CompanyName, C.Country, C.ContactName
FROM Customers AS C
WHERE NOT EXISTS (
				SELECT *
				FROM Orders AS O
				WHERE C.CustomerID = O.CustomerID)
GO
