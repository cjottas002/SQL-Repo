/*
	STORED PROCEDURES:
				Es un conjunto de instrucciones Transact empaquetadas y que son mandadas a ejecutar a traves de la instruccion EXECUTE. Este puede recibir parametros de entrada, pero tambien puede
				devolver parametros. Este tambien puede devolver consultas, pero tambien puede ejecutar, actualizar, borrar datos o una secuencia de estos. 
				Mejora la seguridad porque los usuarios pueden tener permisos para ejecutar el SP, pero no a los objetos a los que accede.

				Habilita la vinculacion retardada de objetos ya que este puede hacer referencia a objetos que aun no existen, pero que al final cuando este se ejecute sí que deben existir.
				Lo mas importante es que mejora el rendimiento, ya que una sola linea de codigo a traves de la red, puede ejecutar cientos de lineas de codigo T-SQL.
				Mejora las oportunidades para la reutilizacion de los planes de ejecucion. 

				Existen dos tipos basicos de procedimientos almacenado del sistema:
				1) Procedimientos almacenados del sistema. Se utiliza para fines administrativos como configurar servidores, bases de datos u objetos o para ver informacion de estos.
				2) Procedimientos almacenados Extendidos. Amplia la funcionalidad de SQL Server pudiendo hacer llamadas a funciones fuera de este (DLLs)
				
				Alguna de las restricciones de los Stored Procedures son: No se pueden realizar sentencias 
					CREATE AGGREGATE, 
					CREATE DEFAULT,
					CREATE OR ALTER FUNCTION, 
					CREATE OR ALTER PROCEDURE,
					SET PARSEONLY,
					SET SHOWPLAN_TEXT,
					USE DatabaseName,
					CREATE RULE,
					CREATE SCHEMA,
					CREATE OR ALTER TRIGGER,
					CREATE OR ALTER VIEW,
					SET SHOWPLAN_ALL,
					SET SHOWPLAN_XML
*/

USE Northwind;
GO

--Creacion de un Stored Procedure
CREATE PROCEDURE NUMEROS
AS
	DECLARE @valor int = 0;
	WHILE (@valor <= 10)
	BEGIN
		IF(@valor % 2 = 0)
		BEGIN
			PRINT CAST(@valor AS VARCHAR(10)) + ' el numero es par'
		END
		ELSE
		BEGIN	
			PRINT CAST(@valor AS VARCHAR(10)) + ' el numero es impar'
		END
	SET @valor = @valor + 1;
	END
GO

EXEC NUMEROS
GO

CREATE PROCEDURE INSERT_SUPPLIER 
(
	@CompanyName VARCHAR(150),
	@ContactName VARCHAR(150), 
	@ContactTittle VARCHAR(150), 
	@Country VARCHAR(150)
)
AS
	INSERT INTO Suppliers (CompanyName, ContactName, ContactTitle, Country) 
	VALUES 
		(@CompanyName, @ContactName, @ContactTittle, @Country)
GO

EXECUTE INSERT_SUPPLIER 'VISOAL', 'JOSE', 'ING', 'REP DOM'
GO

SELECT * FROM Suppliers
WHERE CompanyName = 'VISOAL'

--Para modificar un Stored Procedure se hace como hasta ahora con la instruccion ALTER
ALTER PROCEDURE INSERT_SUPPLIER
(
	@CompanyName VARCHAR(150),
	@ContactName VARCHAR(150), 
	@ContactTittle VARCHAR(150), 
	@Country VARCHAR(150),
	@Address VARCHAR(150)
)
AS
	INSERT INTO Suppliers (CompanyName, ContactName, ContactTitle, Country, [Address]
	VALUES
		(@CompanyName, @ContactName, @ContactTittle, @Country, @Address)
GO

--Eliminar Stored Procedure
DROP PROCEDURE INSERT_SUPPLIER
GO

--CONSULTAR TABLAS DEL SISTEMA PARA DEVOLVER LOS PROCEDIMIENTOS EXISTENTES
SELECT * FROM [sys].PROCEDURES
SP_HELPTEXT INSERT_SUPPLIER

--Para encriptar el script que genera el procedimiento almacenado
ALTER PROCEDURE INSERT_SUPPLIER
(
	@CompanyName VARCHAR(150),
	@ContactName VARCHAR(150), 
	@ContactTittle VARCHAR(150), 
	@Country VARCHAR(150),
	@Address VARCHAR(150)
)
WITH ENCRYPTION
AS
	INSERT INTO Suppliers (CompanyName, ContactName, ContactTitle, Country, [Address]
	VALUES
		(@CompanyName, @ContactName, @ContactTittle, @Country, @Address)
GO

--Utilizar el procedimiento
EXECUTE INSERT_SUPPLIER 'VISOAL2', 'JOSE LUIS', 'ING', 'REP DOM', 'CIUDAD CAPITAL'
GO

SELECT * FROM Supplier WHERE CompanyName = 'VISOAL2'
GO

--Procedimiento con parametros de salida
CREATE PROCEDURE ELIMINA_PAIS
(
	@pais VARCHAR(150),
	@filas INT OUTPUT
)
AS
	DELETE FROM Suppliers WHERE Country = @pais
	SET @filas = @@ROWCOUNT
GO

--Para comprobar el parametro de salida del Stored Procedure
DECLARE @datos INT
EXEC ELIMINA_PAIS 'GUATEMALA', @datos OUTPUT
SELECT @datos
GO

--Los procedimientos almacenados tambien tienen la opcion de una suplantacion e indicar ejecutar el procedimiento a nombre de un USER x con la instruccion EXECUTE AS
[CREATE | ALTER] PROCEDURE ELIMINA_PAIS
(
	@pais VARCHAR(150),
	@filas INT OUTPUT
)
WITH EXECUTE AS OWNER
AS
	DELETE FROM Suppliers WHERE Country = @pais
	SET @filas = @@ROWCOUNT
GO

--Para indicar al Stored Procedure que se recompile (e.i. que genere un nuevo plan de ejecucion) se utiliza la instruccion RECOMPILE
[CREATE | ALTER] PROCEDURE ELIMINA_PAIS
(
	@pais VARCHAR(150),
	@filas INT OUTPUT
)
WITH RECOMPILE 
AS
	DELETE FROM Suppliers WHERE Country = @pais
	SET @filas = @@ROWCOUNT
GO

EXECUTE ELIMINA_PAIS 'REP DOM', @datos OUTPUT
WITH RECOMPILE 
GO








