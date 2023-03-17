--Conectarse a la base de datos
USE Northwind;
GO

--Tipos de datos en SQL Server
DECLARE @variable AS [char](150)
SET @variable = 'Hola mundo!'
SELECT @variable
GO

DECLARE @variable AS [decimal](7,2)
SET @variable = 7.89 * 25
SELECT @variable
GO

CREATE TABLE [Empleados]
(
	[Codigo] [bigint],
	[Nombre] [varchar](100),
	[Apellido] [varchar](150)
)

--COLLATION (COLLATE)
/*
	Nomenclatura de simbolos. Hace referencia al patron de bits utilizados para la representacion y representacion de caracteres 
	y por lo tanto a las reglas utilizadas para ordenar y comparar caracteres. Por lo que afecta a los campos de textos.
	Cuando se crea una bbdd el collation se hereda. Pero se puede cambiar a nivel de bbdd o a nivel de tabla o a nivel de columna
	Dicta las reglas del orden de caracteres.
	Es interesante cuando hay relacion entre mas de una base de datos en juego.
*/
CREATE TABLE [Localizaciones]
(
	Lugar VARCHAR(15)
)
GO

INSERT Localizaciones (Lugar) VALUES ('Chiapas'), ('Colima'), ('Cinco Rios'), ('California');
GO

--Apply an typical collation
SELECT Lugar FROM Localizaciones
ORDER BY Lugar
COLLATE Latin1_General_CS_AS_KS_WS ASC;
GO

--Apply Spanish COLLATION
SELECT Lugar FROM Localizaciones
ORDER BY Lugar
COLLATE Traditional_Spanish_ci_ai ASC;
GO

--CONCAT
SELECT FirstName + ' ' + LastName AS Nombre 
FROM Employees;
GO

SELECT CONCAT(FirstName, ' ', LastName) AS Nombre 
FROM Employees;
GO

SELECT CompanyName, UPPER(CompanyName) AS Mayusculas,
		LOWER(CompanyName) AS Minusculas,
		LEN(CompanyName) AS NumeroLetras
FROM Suppliers
GO

--Busqueda en regex pattern
SELECT CompanyName, ContactName
FROM Suppliers
WHERE CompanyName LIKE '_a%';
GO

SELECT CompanyName, ContactName
FROM Suppliers
WHERE CompanyName LIKE '[^A-F]%'; --El caracter ^ indica negacion (Busca los que no empiecen por A-F)
GO

--Cuando queremos hacer referencia a un caracter que se utilice como patron de busqueda utilizamos la instruccion ESCAPE
UPDATE Suppliers SET CompanyName = '%Aux joyeux ecclésiastiques'
WHERE SupplierID = 1
GO

SELECT CompanyName, ContactName
FROM Suppliers
WHERE CompanyName LIKE '!%%' ESCAPE '!'
GO