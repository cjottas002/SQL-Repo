/*
	FUNCIONES DE VENTANA:
		RANKING, OFFSET Y DE AGREGADO
		LAS FUNCIONES DE VENTANA PERMITE ESPECIFICAR UNA ORDEN COMO PARTE DE UN CALCULO, SIN TENER EN CUENTA EL ORDEN
		DE ENTRADA O LA ORDEN DE SALIDA FINAL
		PERMITEN REALIZAR CALCULOS ANALITICOS DE DATOS COMO LO HACEN LAS FUNCIONES DE AGREGADO CON GROUP BY

		SELECT Category, Qty, OrderYear,
		SUM(Qty) OVER(
				PARTITION BY Category
				ORDER BY OrderYear
				ROWS BETWEEN UNBOUNDED PRECEDING
				AND CURRENT ROW) AS RunningQty
		FROM CategoryQtyYear;

*/
USE Northwind;
GO
--FUNCION OVER
SELECT	O.OrderID,
		OrderDate,
		D.ProductID,
		D.Quantity,
		SUM(D.Quantity) OVER (PARTITION BY O.OrderID) AS Total,
		AVG(D.Quantity) OVER (PARTITION BY O.OrderID) AS Promedio,
		COUNT(D.Quantity) OVER (PARTITION BY O.OrderID) AS Cuenta,
		MIN(D.Quantity) OVER (PARTITION BY O.OrderID) AS Minimo,
		MAX(D.Quantity) OVER (PARTITION BY O.OrderID) AS Maximo
FROM Orders AS O 
INNER JOIN [Order Details]AS D ON O.OrderID = D.OrderID
GO

SELECT	O.OrderID,
		OrderDate,
		D.ProductID,
		D.Quantity,
		SUM(D.Quantity) OVER (PARTITION BY O.OrderID) AS Total,
		CAST(1.*D.Quantity / SUM(D.Quantity) OVER (PARTITION BY O.OrderID) * 100 AS DECIMAL(5,2)) AS [Porcentaje Por Productro]
FROM Orders AS O 
INNER JOIN [Order Details]AS D ON O.OrderID = D.OrderID
GO

--USAR LA TABLA CUSTOMERS Y HACER UNA CUENTA DE FILAS POR PAIS
SELECT Country, CompanyName, ROW_NUMBER() OVER (PARTITION BY Country ORDER BY CompanyName DESC)
FROM Customers
GO

---USAR LA FUNCION RANK()
SELECT	C.CategoryName,
		P.ProductName,
		P.UnitPrice,
		RANK() OVER (ORDER BY P.UnitPrice DESC) AS Position --SI QUITAMOS EL PARTITION BY LO QUE HACE ES ORDENARLO POR POSITION EN VEZ DE HACER LA DIVISION LOGICA POR CATEGORYNAME COMO EN EL CASO DE LA SENTENCIA DE ABAJO
FROM Products AS P
INNER JOIN Categories AS C ON C.CategoryID = P.CategoryID


SELECT	C.CategoryName,
		P.ProductName,
		P.UnitPrice,
		DENSE_RANK() OVER (PARTITION BY C.CategoryName ORDER BY P.UnitPrice DESC) AS Position --SI QUITAMOS EL PARTITION BY LO QUE HACE ES ORDENARLO POR POSITION EN VEZ DE HACER LA DIVISION LOGICA POR CATEGORYNAME
FROM Products AS P
INNER JOIN Categories AS C ON C.CategoryID = P.CategoryID


---FUNCION LAG Y LEAD
CREATE TABLE PreciosProducto
(
	NombreProducto VARCHAR(100), 
	FechaEvaluacion DATE,
	Precio MONEY
)
GO

INSERT INTO PreciosProducto
VALUES	('Pintura Spray Rojo Fuego', '01-01-2015', 23.32),
		('Pintura Spray Rojo Fuego', '01-02-2015', 26.11),
		('Pintura Spray Rojo Fuego', '01-03-2015', 25.26),
		('Pintura Spray Rojo Fuego', '01-04-2015', 30.45)
GO

SELECT Actual.NombreProducto, Actual.FechaEvaluacion, Actual.Precio, Anterior.Precio
FROM PreciosProducto AS Actual
LEFT OUTER JOIN PreciosProducto AS Anterior ON Actual.FechaEvaluacion = DATEADD(dd, 1, Anterior.FechaEvaluacion)
GO

SELECT NombreProducto, FechaEvaluacion, Precio,
LAG(Precio) OVER(ORDER BY FechaEvaluacion) AS PrecioAnterior,
LEAD(Precio) OVER(ORDER BY FechaEvaluacion) AS PrecioSiguiente
FROM PreciosProducto
GO