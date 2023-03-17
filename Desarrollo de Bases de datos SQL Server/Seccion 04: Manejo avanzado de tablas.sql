--Tablas particionadas. Dividen los datos en varios discos duros
--Primero se crea el file group para asociarlos a archivos
USE Empresa
GO

ALTER DATABASE Empresa
ADD FILEGROUP GrupoPart1
GO

ALTER DATABASE Empresa
ADD FILEGROUP GrupoPart2
GO

ALTER DATABASE Empresa
ADD FILEGROUP GrupoPart3
GO

--Se asocia los archivos a los filegroups creados
ALTER DATABASE Empresa
ADD FILE
(
	NAME = EmpresaV1,
	FILENAME = '/var/opt/mssql/data/EmpresaV1.ndf',
	SIZE = 15mb,
	FILEGROWTH = 25%
)
TO FILEGROUP GrupoPart1
GO

ALTER DATABASE Empresa
ADD FILE
(
	NAME = EmpresaV2,
	FILENAME = '/var/opt/mssql/data/EmpresaV2.ndf',
	SIZE = 15mb,
	FILEGROWTH = 25%
)
TO FILEGROUP GrupoPart2
GO

ALTER DATABASE Empresa
ADD FILE
(
	NAME = EmpresaV3,
	FILENAME = '/var/opt/mssql/data/EmpresaV3.ndf',
	SIZE = 15mb,
	FILEGROWTH = 25%
)
TO FILEGROUP GrupoPart3
GO

--Funcion que tendra la division para indicar a que particion deben ir los datos, luego el esquema es quien hace la reparticion en los diferentes filegroups

CREATE PARTITION FUNCTION FunctionPartition (VARCHAR(150))
AS RANGE RIGHT
FOR VALUES ('I', 'P')
GO

CREATE PARTITION SCHEME SchemaPatition AS PARTITION FunctionPartition
TO (GrupoPart1, GrupoPart2, GrupoPart3)

--Crear Tabla particionada
CREATE TABLE Personas
(
	NumeroOrden VARCHAR(10),
	NumeroRegistro BIGINT,
	Nombre VARCHAR(150),
	Apellido VARCHAR(150)
)
ON SchemaPartition(Apellido)
GO

INSERT INTO Persona (NumeroOrden, NumeroRegistro, Nombre, Apellido)
SELECT Orden_ced, Numreg_ced, nom1, ape1 FROM Ciudadano.dbo.Ciudadano
GO

--Verificar los datos para conocer en cual partition estan
SELECT Apellido, $PARTITION.FunctionPart(Apellido) AS PARTITION
FROM Personas
GO

--Tablas Versionada: Permiten almacenar un historico de los datos
CREATE TABLE Individuos
(
	NumeroRegistro BIGINT IDENTITY(1,1) PRIMARY KEY,
	Nombre1 VARCHAR(150),
	Nombre2 VARCHAR(150),
	Apellido1 VARCHAR(150),
	Apellido2 VARCHAR(150),
	SysStartTime DATETIME2 GENERATED ALWAYS AS ROW START NOT NULL,
	SysEndTime DATETIME2 GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (SysStartTtime, SysEndTime)
)
WITH (SYSTEM_VERSIONING = ON)
GO

INSERT INTO Individuos 
(
	Nombre1, 
	Nombre2,
	Apellido1,
	Apellido2
)
SELECT
	nom1,
	nom2
	ape1,
	ape2
FROM Ciudadano.dbo.Ciudadano
WHERE Edad = 50
GO

SELECT * 
FROM [dbo].[MSSQL_TemporalHistoryFor_1253579504]
GO

UPDATE Individuos SET Nombre1 = 'Arnoldo'
WHERE Nombre = 'AROLDO'
GO

--Mas sobre tablas Versionadas
CREATE TABLE Customer
(
	CustomerID INT NOT NULL PRIMARY KEY CLUSTERED,
	PersonID INT NULL,
	StoreID INT NULL,
	TerritoryID INT NULL,
	AccountNumber NVARCHAR(25),
	SysStartTime DATETIME2 GENERATED ALWAYS AS ROW START NOT NULL,
	SysEndTime DATETIME2 GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime)
)

WITH (SYSTEM_VERSIONING = ON)
GO

--Podemos modificar una tabla normal ya existente y hacer que sea Versionada
USE Northwind;
GO

CREATE TABLE CustomerHistory
(
	CustomerID NCHAR(5) NOT NULL,
	CompanyName NVARCHAR(40) NOT NULL,
	ContactName NVARCHAR(30) NULL,
	ContactTitle NVARCHAR(30) NULL, 
	Address NVARCHAR(60) NOT NULL,
	City NVARCHAR(15) NULL,
	Region NVARCHAR(15) NULL,
	PostalCode NVARCHAR(10) NULL,
	Country NVARCHAR(15) NULL,
	Phone NVARCHAR(24) NULL,
	Fax NVARCHAR(24) NULL,
	SysStartTime DATETIME2 NOT NULL,
	SysEndTime DATETIME2 NOT NULL
)
GO

ALTER TABLE Customers
ADD 	SysStartTime DATETIME2 GENERATED ALWAYS AS ROW START NOT NULL DEFAULT GETUTCDATE(),
	SysEndTime DATETIME2 GENERATED ALWAYS AS ROW END NOT NULL DEFAULT CAST('9999-12-31 23:59:59.9999999' AS DATETIME2),
PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime)
GO

ALTER TABLE Customers
SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.CustomerHistory))
GO

--Una vez hecho en cambio de tabla normal a tabla versionada, introducimos datos para ver los cambios historicos
UPDATE dbo.Customers SET Country = 'Estados Unidos'
WHERE Country = 'USA';
GO

UPDATE dbo.Customers SET Country = 'Brasil'
WHERE Country = 'Brazil'
GO


---Particionado en detalle
USE MASTER
GO

CREATE DATABASE Corporacion
ON PRIMARY
(
	NAME = CorporacionData,
	FILENAME = '/var/opt/mssql/data/CorporacionData.mdf',
	SIZE = 50MB,
	FILEGROWTH = 25%
)
LOG ON
(
	NAME = CorporacionLog,
	FILENAME = '/var/opt/mssql/data/CorporacionLog.ldf',
	SIZE = 25MB,
	FILEGROWTH = 25%
)
GO

--FILEGROUPS
ALTER DATABASE Coporacion
ADD FILEGROUP CorpoPart1
GO

ALTER DATABASE Coporacion
ADD FILEGROUP CorpoPart2
GO

ALTER DATABASE Coporacion
ADD FILEGROUP CorpoPart3
GO

--AGREGAR ARCHIVOS AL FILEGROUP
ALTER DATABASE Coprporacion
ADD FILE
(
	NAME = Corporacion1 ,
	FILENAME = '/var/opt/mssql/data/CorporacionData1.ndf',
	SIZE = 50MB,
	FILEGROWTH = 25% 
)
TO FILEGROUP CorpoPart1
GO

ALTER DATABASE Coprporacion
ADD FILE
(
	NAME = Corporacion2,
	FILENAME = '/var/opt/mssql/data/CorporacionData2.ndf',
	SIZE = 50MB,
	FILEGROWTH = 25%
)
TO FILEGROUP CorpoPart2
GO

ALTER DATABASE Coprporacion
ADD FILE
(
	NAME = Corporacion3,
	FILENAME = '/var/opt/mssql/data/CorporacionData3.ndf',
	SIZE = 50MB,
	FILEGROWTH = 25%
)
TO FILEGROUP CorpoPart3
GO

--FUNCION DE PARTICION
CREATE PARTITION FUNCTION FunctionPartition (BIGINT)
AS RANGE LEFT FOR VALUES (500,1000)
GO


/*
Visualizacion de la particion
|-----------------|------------------|-----------------|
100		 500		    1000	      infinite

	LEFT <= 500 | > 500 y <= 1000 | > 1000
	RIGHT < 500| >=500 y <1000 | >= 1000
*/

--SCHEMA DE PARTICION
CREATE PARTITION SCHEME SchemaPartition AS PARTITION FunctionPartition
TO (
	CorpoPart1,
	CorpoPart2,
	CorpoPart3
)
GO

--Crear la tabla
CREATE TABLE Cliente
(
	Codigo BIGINT NOT NULL PRIMARY KEY,
	Nombre VARCHAR(200),
	Apellido VARCHAR(200)
)
ON SchemaPartition(Codigo)
GO

--Insertar datos
INSERT INTO Cliente 
(
	Codigo, 
	Nombre, 
	Apellido
)
VALUES
(1, 'JOSE', 'Garcia'),
(2, 'Ana', 'Perez'),
(501, 'Miguel', 'Lopez'),
(502, 'Ana', 'Acunia'),
(1001, 'Amado', 'Juarez'),
(1002, 'Claudia', 'Lajo')
GO

--Verificar las particiones donde se almacenan los datos
SELECT Codigo, Nombre, Apellido, $PARTITION.FunctionPartition(Codigo) AS Partition
FROM Cliente
GO

--Indice particionado
CREATE NONCLUSTERED INDEX IDX_APELLIDO
ON Cliente (Apellido)
ON SchemaPartition (Codigo)
GO

--Crear nueva particion sobre las que ya existen
ALTER DATABASE Corporacion
ADD FILEGROUP CorpoPart4
GO

ALTER DATABASE Corporacion
ADD FILE
(
	NAME = Corporacion4,
	FILENAME = '/var/opt/mssql/data/Corporacion4.ndf',
	SIZE = 50MB,
	FILEGROWTH = 25%
)
GO

--Se modifica la funcion y el esquema de la particion
ALTER PARTITION SCHEME SchemaPartition NEXT USED CorpoPart4
GO
ALTER PARTITION FUNCTION FunctionPartition() SPLIT RANGE (2000)
GO

--Si quisieramos combinar partiticiones
ALTER PARTITION FUNCTION FunctionPartition() MERGE RANGE (2000)
GO


--Compresion de datos: Sirven para ahorrar espacio en disco, mejora de rendimiento. 1)Compresion de pagina, 2)compresion de fila y 3)compresion de unicode.
--Para comprobar si un objeto merece ser comprimido o no
USE Northwind;
GO

EXECUTE SP_ESTIMATE_DATA_COMPERSSION_SAVINGS 'dbo', 'Order Details', NULL, NULL, 'ROW';
GO

EXECUTE SP_ESTIMATE_DATA_COMPRESSION_SAVINGS 'dbo', 'Order Details', NULL, NULL, 'PAGE';
GO

SP_HELPINDEX [Order Details];
GO

ALTER TABLE [dbo].[Order Details] REBUILD PARTITION = ALL
WITH (DATA_COMPRESSION = ROW)
GO
ALTER TABLE [dbo].[Order Details] REBUILD PARTITION = ALL
WITH (DATA_COMPRESSION = PAGE)
GO

