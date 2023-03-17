--Para cambiar a la base de datos
USE Empresa;
GO

--Para crear una tabla en la base de datos en buffer actualmente
CREATE TABLE Cliente
(
	CodigoCliente INT IDENTITY(1,) NOT NULL PRIMARY KEY,
	Nombre VARCHAR(150) NULL,
	Direccion VARCHAR(150) NOT NULL,
	Telefono VARCHAR(300) DEFAULT('0000-00000'),
	Email VARCHAR(300)
)
GO

--Manipular columnas después de creada la tabla
ALTER TABLE Cliente
ADD Categoria INT NOT NULL
GO

ALTER TABLE Cliente
DROP COLUMN Categoria;
GO

ALTER TABLE Cliente
ALTER COLUMN Categoria DECIMAL(5,2)
GO

EXECUTE SP_RENAME 'dbo.ErrorLog.ErrorTime', 'ErrorDateTime', 'COLUMN';
GO

--Para visualizar los valores de una tabla
SELECT * FROM Cliente;
GO

--Para eliminar la tabla completa de la base de datos en buffer
DROP TABLE Cliente;
GO

--Existen diferentes tipos de datos para almacenar datos
CREATE TABLE Cliente 
(
	CodigoCiente INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Nombre NVARCHAR(150),
	Email NVARCHAR(MAX)
	Direccion CHAR(150),
	Telefono NCHAR(150),
	Edad INT, 
	--Agregamos restriccion check
	CONSTRAINT CK_EDAD CHECK(Edad >= 18)
)
GO
INSERT INTO Cliente (Nombre, Direccion, Email, Edad)
VALUES
	('JOSE', 'Santiago', 'Jotta@gmail.com', 15)
GO

SELECT * FROM Cliente;
GO


--En SQL Server Existe el login de usuario (a traves de AD DS o a traves de usuario y contraseña), este solo permite acceder al servidor, pero luego hay que crear el User de la bbdd que suele estar identificado a un schema (por ejemplo dbo)

--Establecemos la base de datos master para poder crear usuarios
USE master;
GO

--Creamos un Login para que pueda acceder al servidor de bases de datos
CREATE LOGIN UserInformatica WITH PASSWORD = 'P@ssw0rd'

--Colocamos la base de datos en el buffer para poderle crear el User y pueda ver esa base de datos en concreto
USE northwind;
GO

--Creamos el User y lo enlazamos tanto al login para que pueda acceder al servidor como al schema para que pueda manipular la bbdd (Si el esquema no existe, lo debemos crear)
CREATE USER UserInformatica FOR LOGIN UserInformatica
WITH DEFAULT_SCHEMA = Informatica
GO

--Creamos el esquema si no existiera (por defecto el esquema es el dbo)
USE Northwind;
GO

CREATE SCHEMA Curso AUTHORIZATION UserInformatica;
GO

CREATE SCHEMA Informatica AUTHORIZATION UserInformatica;
GO

--Utilizamos el sublenguaje DCL para proporcionar los permisos necesarios de creacio, borrado y demás comandos para el usuario que queremos. Dependiendo del esquema que le hayamos asignado al usuario, este una vez comience a crear objetos dentro de la base de datos lo hará con el esquema asignado.
GRANT CREATE TABLE TO UserInformatica;
GO

--Para ver el usuario con el que estoy logeado
SELECT USER;
GO

--Para poder ejecutar un comando en nombre de otro usuario. (Este sólo lo puede hacer el sa)
EXECUTE AS USER = 'UserInformatica'
GO

--Creamos una tabla en nombre de UserInformatica, despues de haber ejecutado el comando anterior
CREATE TABLE Empleado
(
	Codigo INT,
	Nombre VARCHAR(100)
)
GO

--Para volver al estado anterior
REVERT
GO


--Campos calculados, columna virtual, que no esta almacenada fisicamente en la tabla,  a menos que se ponga la palabra PERSISTED en su definicion
USE Northwind;
GO

CREATE TABLE OrdenDetalle
(
	OrdenDetalleID INT NOT NULL PRIMARY KEY,
	OrdenID INT NOT NULL,
	ProductoID INT NOT NULL,
	Precio DECIMAL(7,2),
	Cantidad INT,
	Partial AS Precio * Cantidad PERSISTED
)
GO

INSERT INTO OrdenDetalle (OrdenDetalleID, OrdenID, ProductoID, Precio, Cantidad)
VALUES
	(1, 22, 7, 56.70, 7)
GO

SELECT * FROM OrdenDetalle;
GO

SELECT * FROM [Orden Details]
GO

ALTER TABLE [Order Details]
ADD Partial AS UnitPrice * Quantity;
GO

--Restricciones (Tablas Categoria y Producto)
USE Empresa
GO

CREATE TABLE Category
(
	CategoryID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	CategoryName VARCHAR(200) NOT NULL UNIQUE,
	Descriptions VARCHAR(500)
)
GO

CREATE TABLE Products
(
	ProductID INT IDENTITY(1,1) NOT NULL,
	ProductName NVARCHAR(40) NOT NULL,
	SupplierID INT NULL,
	CategoryID INT NULL,
	QuantityPerUnit NVARCHAR(20) NULL,
	UnitPrice MONEY NULL CONSTRAINT DF_Products_UnitPrice DEFAULT(0),
	UnitInStock SMALLINT NULL CONSTRAINT DF_Products_UnitInStock DEFAULT(0),
	UnitOnOrder SMALLINT NULL CONSTRAINT DF_Products_UnitOnOrder DEFAULT(0),
	ReorderLevel SMALLINT NULL CONSTRAINT DF_Products_ReorderLevel DEFAULT(0),
	CONSTRAINT PK_Products PRIMARY KEY CLUSTERED (ProductID),
	CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryID) REFERENCES dbo.Category(CategoryID) ON UPDATE CASCADE ON DELETE NO ACTION,
	CONSTRAINT CK_Products_UnitPrice CHECK (UnitPrice >= 0),
	CONSTRAINT CK_ReorderLevel CHECK (ReorderLevel >= 0),
	CONSTRAINT CK_UnitsInStock CHECK (UnitsInStock >= 0),
	CONSTRAINT CK_UnitsOnOrder CHECK (UnitsOnOrder >= 0)
	
)
GO

--Otra forma de agregar CONSTRAINT o quitarlos
ALTER TABLE Products
ADD CONSTRAINT DF_ProductName DEFAULT('*****') FOR ProductName
GO

ALTER TABLE Products
NOCHECK CONSTRAINT CK_ReorderLevel;
GO

--Para colocar un CONSTRAINT sin que verifique los datos que ya existen en la columna indicada
ALTER TABLE Products
WITH NOCHECK
ADD CONSTRAINT CK_UnitsOnOrder CHECK (UnitsOnOrder >= 0)
GO
