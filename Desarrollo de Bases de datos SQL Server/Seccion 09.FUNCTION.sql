/*
	FUNCTIONS
		Las funciones son VIEWS que reciben parametros, es decir, que encapsulan un SELECT.
		Existen varios tipos de FUNCTIONS como son:
							- Scalar-valued Functions: Devuelven un solo valor de datos. Pueden devolver cualquier valor excepto
							ROWVERSION, CURSOR y TABLE cuando se implementa en Transact-SQL.
							Puede devolver cualquier tipo de datos excepto ROWVERSION, CURSOR, TABLE, TEXT, NTEXT e IMAGEN
							cuando se implementa en codigo administrado.

							- Table-valued Functions: Funciones que retornan mas de un valor, encapsulado en una sentencia SELECT. Dos tipos
								- Line Table Value Function
								- Multiple instructions Table Value Function
*/

USE Northwind
GO

--Creacion de una FUNCTION
CREATE FUNCTION IVA
(
	@monto MONEY
)
RETURNS MONEY
AS
BEGIN
	DECLARE @impuesto MONEY 
	SET @impuesto = @monto * 0.12
	RETURN(@impuesto)
END
GO

SELECT ProductName, UnitPrice, dbo.IVA(UnitPrice) AS IVA
FROM Products
GO

[CREATE | ALTER] FUNCTION COMISION
(
	@monto MONEY
)
RETURNS MONEY
AS
BEGIN
	DECLARE @resultado MONEY
	IF(@monto >= 250)
		BEGIN
			SET @resultado = @monto * 0.10
		END
	ELSE
		BEGIN
			SET @resultado = 0
		END
RETURN(@resultado)
END
GO

--Ejecutar la Scalar Function
SELECT OrderID, ProductID, UnitPrice, Quantity, (UnitPrice * Quantity) AS Partial, dbo.COMISION(UnitPrice * Quantity) AS Comision
FROM [Order Details]
GO


--Crear una funcion con valores de tabla de multiples instrucciones
CREATE FUNCTION FN_ListaPaises 
(
	@pais VARCHAR(160)
)
RETURNS @cliente TABLE
(
	@CustomerID VARCHAR(5),
	@CompanyName VARCHAR(160),
	@ContactName VARCHAR(160),
	@Country VARCHAR(160)
)
AS
BEGIN
	INSERT @cliente 
	SELECT CustomerID, CompanyName, ContactName, Country
	FROM Customers 
	WHERE Country = @pais
RETURN
END
GO

--Probamos la funcion, se hace con la sentencia SELECT ya que devuelve mas de un valor
SELECT * FROM FN_ListaPaises('ARGENTINA')
GO

--Crear una funcion con valores de tabla en linea
CREATE FUNCTION FN_OrdenesFecha 
(
	@FechaInicial DATE,
	@FechaFinal DATE
)
AS
RETURN TABLE
AS
RETURN
(
	SELECT O.OrderID, O.OrderDate, P.ProductID, D.UnitPrice, D.Quantity, D.UnitPrice * D.Quantity AS Partial
	FROM Orders AS O
	INNER JOIN [Order Details] AS D ON D.OrderID = O.OrderID
	INNER JOIN Products AS P ON P.ProductID = D.ProductID
	WHERE O.OrderDate BETWEEN @FechaInicial AND @FechaFinal
)
GO

--Ejecutar la funcion
SELECT * 
FROM FN_OrdenesFecha('1998-01-01', '1998-12-31')

--Mas ejemplos de ejecucion de funciones
SELECT 	SOH.CustomerID,
	SOH.SalesOrderID,
FROM Sales.SalesOrderHeader AS SOH
WHERE SOH.SalesOrderID =
			dbo.GetLatestBulkOrder(SOH.CustomerID)
ORDER BY SOH.CustomerID, SOH.SalesOrderID;
GO

--CROSS APPLY puede hacer que los TVF se ejecuten repetidamente
SELECT	C.CustomerID,
	C.AccountNumber,
	GLOFC.SalesOrderID,
	GLOFC.OrderDate
FROM Sales.Customer AS C
CROSS APPLY Sales.GetLastOrdersForCustomer(C.CustomerID, 3) AS GLOFC
ORDER BY C.CustomerID, GLOFC.SalesOrderID;
GO
