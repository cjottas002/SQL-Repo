USE Northwind/*
	UN PROCEDIMIENTO ALMACENADO ES UN OBJETO QUE ME PERMITE ENCAPSULAR UNA INSTRUCCION O UN CONJUNTO DE INSTRUCCIONES SQL, PERO A DIFERENCIA DE LA VISTA O LA FUNCION QUE ENCAPSULAN 
	LA SENTENCIA 'SELECT', UN PA, PUEDE ALMACENAR UN INSERT, UPDATE, SELECT O DELETE.
	SI ES UN SELECT ESTATICO LO MEJOR SERIA UNA VISTA
	SI ES UN SELECT DINAMICO ES MEJOR UNA FUNCION

*/

USE Northwind;
GO


CREATE PROCEDURE PROC_VENTAS 
(
	@cliente VARCHAR(5)
)
AS
SELECT 	C.CustomerID,
	C.CompanyName,
	O.OrderID,
	O.OrderDate
FROM Customers AS C
INNER JOIN Orders AS O ON C.CustomerID = O.CustomerID
WHERE C.CustomerID = @CLIENTE
GO

DROP PROCEDURE PROC_VENTAS;
GO

CREATE PROC PROC_INSERT_CLIENTE
(
	@customerID VARCHAR(5), 
	@CompanyName VARCHAR(100), 
	@ContactName VARCHAR(100), 
	@Country VARCHAR(100)
)
AS
	INSERT INTO Customers(customerID, CompanyName, ContactName, Country)
	VALUES(@customerID, @CompanyName, @ContactName, @Country)
GO

EXEC PROC_INSERT_CLIENTE 'VHCV3', 'VISOAL', 'JOSE', 'REP DOM'
GO

SELECT * FROM Customers WHERE CustomerID = 'VHCV3';
GO

-------------------------------------------PARAMETROS DE ENTRADA Y SALIDA EN LOS PROCEDIMIENTOS ALMACENADOS--------------------------------

CREATE PROC PROC_CAMBIO_PAIS
(
	@PaisNuevo VARCHAR(150),
	@PaisViejo VARCHAR(150),
	@filasAfectadas INT OUTPUT
)
AS
	UPDATE Customers SET Country = @PaisNuevo
	WHERE Country = @PaisViejo
SET @filasAfectadas = @@ROWCOUNT
GO

DECLARE @variableSalida INT
EXEC PROC_CAMBIO_PAIS 'Estados Unidos', 'USA', @variableSalida OUTPUT

SELECT @variableSalida
GO

SELECT * FROM Customers
WHERE Country = 'Estados Unidos'
GO

---VER LOS PARAMETROS QUE TIENE UN PROCEDIMIENTO ALMACENADO (vista sys.parameters)

SELECT * FROM sys.parameters
WHERE object_id = (SELECT [object_id] FROM sys.objects WHERE [name] = 'PROC_CAMBIO_PAIS')



-----------------------------------------PROCEDIMIENTOS QUE DEVUELVEN FILAS DE DATOS Y USO DE SQL DINAMICO-------------------------------------------
USE Northwind;
GO

CREATE PROC PROC_PRODUCTOSPORFECHA
(
	@mes INT, 
	@anio BIGINT
)
AS
	SELECT	DISTINCT P.ProductID,
					 P.ProductName
	FROM Products AS P
	INNER JOIN [Order Details] AS D ON P.ProductID = D.ProductID
	INNER JOIN Orders AS O ON O.OrderID = D.OrderID
	WHERE DATEPART(mm, O.OrderDate) = @mes AND DATEPART(yyyy, O.OrderDate) = @anio
GO

EXEC PROC_PRODUCTOSPORFECHA @mes = 3, @anio = 1998
GO

CREATE PROCEDURE PROC_CLIENTES_PAIS
(
	@pais VARCHAR(100)
)
AS
	SELECT CustomerID, CompanyName, ContactTitle 
	FROM Customers 
	WHERE Country = @pais
GO

EXEC PROC_CLIENTES_PAIS 'Mexico'
GO

---SQL DINAMICO: ES CODIGO T-SQL ENSAMBLADO EN UNA CADENA DE CARACTERES, INTERPRETADO COMO UN COMANDO Y EJECUTADO
--SE PUEDE EJECUTAR CODIGO DINAMICAMENTE DE DOS FORMAS: A) INSTRUCCION EXEC, B) PROCEDIMIENTO ALMACENADO SP_EXECUTESQL (ADMITE PARAMETROS)

--EXEC
DECLARE @tabla NVARCHAR(100) = N'Customers'
EXEC ('SELECT CustomerID, CompanyName, ContactTitle 
	FROM  ' + @tabla) --PELIGROSO POR EL SQL INJECTION
GO

DECLARE @dinamycVariable VARCHAR(200)
SET @dinamycVariable = 'SELECT CustomerID, CompanyName, ContactName FROM Customers'
EXECUTE (@dinamycVariable)


--SP_EXECUTESQL
DECLARE @sqlString NVARCHAR(500) = N'SELECT EmployeeID, FirstName, LastName, ReportsTo 
									 FROM Employees'
EXEC SP_EXECUTESQL @sqlString --MENOS PELIGROSO, PUEDE RECIBIR PARAMETROS Y PREVIENE EL SQL INJECTION
GO


DECLARE @sqlString NVARCHAR(500) = N'SELECT EmployeeID, FirstName, LastName, ReportsTo 
									 FROM Employees
									 WHERE ReportsTo = @report'
DECLARE @paramDescription NVARCHAR(500) = '@report INT'
EXEC SP_EXECUTESQL @sqlString, @paramDescription, @report = 5
GO

CREATE PROC PROC_SUBALTERNOS
(
	@report INT
)
AS
	DECLARE @sqlString NVARCHAR(500) = N'SELECT EmployeeID, FirstName, LastName, ReportsTo 
										 FROM Employees
										 WHERE ReportsTo = @report'
	DECLARE @paramDescription NVARCHAR(500) = '@report INT'
	EXEC SP_EXECUTESQL @sqlString, @paramDescription, @report = @report
GO

EXEC PRO_SUBALTERNOS 2