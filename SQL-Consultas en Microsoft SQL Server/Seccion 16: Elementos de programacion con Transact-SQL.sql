/*
	LOTES/BATCH: 
		COLECCIONES DE SENTENCIAS ENVIADAS A SQL SERVER COMO UNA UNIDAD DE ANALISIS, OPTIMIZACION Y EJECUCION, SE LIMITA CON 'GO'
		HAY LOTES QUE NO PUEDEN SER COMBINADAS COMO CREATE FUNCTION, CREATE PROCEDURE, CREATE VIEW, ETC
	
	VARIABLES: 
		OBJETOS QUE PERMITEN ALMACENAR UN VALOR EN MEMORIA PARA SU USO POSTERIOR. SE DEFINEN CON LA PALABRA RESERVADA 'DECLARE'
		DECLARE @tabla VARCHAR(50) = 'Products'
		EXEC ('SELECT * FROM ' + @tabla)


	CONTROL DE FLUJO DE PROGRAMAS
	
	SINONIMOS: 
		ES UN ALIAS O ENLACE A UN OBJETO ALMACENADO YA SEA EN LA MISMA INSTANCIA SQL SERVER O EN UN SERVIDOR VINCULADO
		SE UTILIZA LA SECUANCIA CREATE Y DROP PARA ADMINISTRAR SINONIMOS

*/

USE Northwind;
GO

---SINONIMOS
USE tempdb;
GO

CREATE SYNONYM dbo.ProdsByCaterory FOR
		TSQL.Production.ProdsByCategory;
GO

EXEC dbo.ProdsByCategory @numrows = 3, @catid = 2;
GO

CREATE VIEW VentasAnuales
AS
	SELECT  C.CompanyName, 
			DATEPART(yyyy, O.OrderDate) AS Anio,
			SUM(D.UnitPrice*D.Quantity) AS Total
	FROM Customers AS C 
	INNER JOIN Orders AS O ON C.CustomerID = O.CustomerID
	INNER JOIN [Order Details] AS D ON O.OrderID = D.OrderID
	GROUP BY C.CompanyName, DATEPART(yyyy, O.OrderDate)
GO

CREATE SYNONYM TotalesAnio
FOR VentasAnuales
GO

----INSTRUCCIONES DE CONTROL DE FLUJO
--CICLO WHILE

DECLARE @empID INT = 1, @lName NVARCHAR(20)
WHILE @empID <= 5
	BEGIN
		SELECT @lName = LastName FROM Employees WHERE EmployeeID = @empID
		PRINT @lName
		SET @empID += 1
	END
GO

DECLARE @i INT = 0;
WHILE @i <= 10
	BEGIN
		IF(@i%2 != 0)
			PRINT @i
		SET @i += 1;
	END;
GO

CREATE PROCEDURE InsertarCatalogo
(
	@CompanyName VARCHAR(150),
	@ContactName VARCHAR(150),
	@ContactTitle VARCHAR(150),
	@Country VARCHAR(150),
	@Tabla VARCHAR(100)
)
AS
	IF(@Tabla = 'Customers')
		BEGIN
			INSERT INTO Customers(CustomerID, CompanyName, ContactName, ContactTitle, Country)
			VALUES(SUBSTRING(@CompanyName, 1, 5), @CompanyName, @ContactName, @ContactTitle, @Country)
		END
	ELSE
		BEGIN
			INSERT INTO Suppliers(CompanyName, ContactName, ContactTitle, Country)
			VALUES(@CompanyName, @ContactName, @ContactTitle, @Country)
		END
GO

EXEC InsertarCatalogo 'VISOAL, S.A', 'JOSE', 'ING', 'REP DOM', 'Suppliers'
GO

SELECT * FROM Suppliers
GO
