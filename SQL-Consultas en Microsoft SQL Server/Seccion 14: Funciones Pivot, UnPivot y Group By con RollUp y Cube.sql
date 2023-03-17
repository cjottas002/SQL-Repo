--Pivot: PERMITE TRASPONER COLUMNAS POR FILAS

USE Northwind;
GO

SELECT CategoryName, [1996], [1997], [1998] 
FROM
	(SELECT C.CategoryName, YEAR(O.OrderDate) AS Anio, D.UnitPrice * D.Quantity AS Parcial
	FROM Orders AS O
	INNER JOIN [Order Details] AS D ON O.OrderID = D.OrderID
	INNER JOIN Products AS P ON D.ProductID = P.ProductID
	INNER JOIN Categories AS C ON C.CategoryID = P.CategoryID) AS T
PIVOT(SUM(Parcial) FOR Anio IN ([1996], [1997], [1998])) AS PVT
GO

--VISTA 
CREATE VIEW View_DetalleVenta
AS
SELECT C.CategoryName, YEAR(O.OrderDate) AS Anio, D.UnitPrice * D.Quantity AS Parcial
	FROM Orders AS O
	INNER JOIN [Order Details] AS D ON O.OrderID = D.OrderID
	INNER JOIN Products AS P ON D.ProductID = P.ProductID
	INNER JOIN Categories AS C ON C.CategoryID = P.CategoryID

--PIVOT
SELECT * FROM View_DetalleVenta
PIVOT(SUM(Parcial) FOR Anio IN([1996], [1997], [1998] )) AS PVT
GO

--CONSTRUIR TABLA CON UN PIVOT
SELECT * INTO TblPivot
FROM View_DetalleVenta
PIVOT(SUM(Parcial) FOR Anio IN([1996], [1997], [1998] )) AS PVT
GO

SELECT * FROM TblPivot;
GO

--UNPIVOT
SELECT CategoryName, Anio, Parcial 
FROM TblPivot
UNPIVOT(Parcial FOR Anio IN([1996], [1997], [1998]) ) AS UPVT


--------------FUNCION PIVOT CON SQL DINAMICO--------------------------------
USE Northwind;
GO

CREATE VIEW VIEW_VENTAS_CATEGORIA
AS
SELECT	C.CategoryName,
		DATEPART(yyyy, O.OrderDate) AS Anio,
		D.UnitPrice*D.Quantity AS Total
FROM Categories AS C
INNER JOIN Products AS P ON C.CategoryID = P.CategoryID
INNER JOIN [Order Details] AS D ON P.ProductID = D.ProductID
INNER JOIN Orders AS O ON O.OrderID = D.OrderID
GO

DECLARE @anios NVARCHAR(400) = ''

SELECT @anios = @anios + '[' + T.anio + '],' 
FROM 
	(SELECT DISTINCT CAST((DATEPART(yyyy, OrderDate)) AS VARCHAR(150)) as Anio 
	FROM Orders) AS T

SET @anios = LEFT(@anios, LEN(@anios)-1)

--SELECT @anios
EXEC ('SELECT * FROM VIEW_VENTAS_CATEGORIA 
PIVOT(SUM(Total) FOR Anio IN ('+ @anios +')) AS PVT')
GO

UPDATE Orders SET OrderDate = '01-01-2017'
WHERE OrderID < 10260
GO