/*
	TRIGGERS:
		Son procedimientos almacenados que se ejecutan antes o despues de una accion realizada. Los TRIGGERS son reactivos, es decir, se ejecutan antes o despues de una accion.
		Existen los TRIGGERS DML(INSERT, UPDATE o DELETE) y los TRIGGERS DDL(CREATE, ALTER o DROP)
*/

USE Northwind
GO

--TRIGGERS DML--
--TRIGGER AFTER(INSERT, UPDATE, DELETE)
CREATE TABLE HistorialBorrado
(
	Fecha DATE,
	Decripcion VARCHAR(100),
	Usuario VARCHAR(100)
)
GO

CREATE TRIGGER TR_DeleteCustomers ON Customers
AFTER DELETE
AS
	INSERT INTO HistorialBorrado
	(
		Fecha,
		Descripcion,
		Usuario
	)
	VALUES
		(GETDATE(), 'Se ha eliminado un cliente', [User])
GO

--Consultar los TRIGGERS en una tabla
SP_HELPTRIGGER Customers
GO

--Eliminar un cliente para probar el trigger
DELETE Customers WHERE CustomerID = 'ABCD1'

SELECT * FROM HistorialBorrado
GO

--Borrar el trigger
DROP TRIGGER TR_DeleteCustomers
GO

--Crear una tabla a partir de los datos de Customers
SELECT * INTO DeleteCustomers
FROM Customers
GO

--Eliminar los datos a DeleteCustomers
DELETE DeleteCustomers
GO

SELECT * FROM DeleteCustomers
GO

--Crear un TRIGGER usando la tabla Deleted
CREATE TRIGGER TR_BorradoCliente
ON Customers
AFTER DELETE
AS
	INSERT INTO DeleteCustomers 
	SELECT * FROM Deleted
GO

--Consultar la tabla DeleteCustomers
SELECT * FROM DeleteCustomers
GO

--Eliminar un cliente
DELETE FROM Customers WHERE CustomerID = 'PARIS'

--Actualizar el precio del producto al insertar un detalle de orden
CREATE TRIGGER TR_InsertDetail ON [Order Details]
FOR INSERT
AS
	UPDATE D SET D.UnitPrice = P.UnitPrice
	FROM [Order Details] AS D 
	INNER JOIN Inserted AS I ON I.OrderID = O.OrderID AND I.ProductID = D.ProductID
	INNER JOIN Products AS P ON P.ProductID = I.ProductID
GO

--Insertar un dato al detalle
INSERT INTO [Order Details]
(
	OrderID,
	ProductID,
	UnitPrice,
	Quantity,
	Discount
)
VALUES
(
	10248, 
	32,
	0.0,
	20,
	0
)
GO

SELECT * FROM [Order Details]
WHERE OrderID = 10248 AND ProductID = 32
GO

SELECT * FROM [Order Details]
GO

DELETE FROM [Order Details]
WHERE OrderID = 10248 AND ProductID = 32
GO

--Actualiza Inventario
CREATE TRIGGER ActualizaInventario 
ON [Order Details] 
FOR INSERT
AS
	UPDATE P SET P.UnitInStock = P.UnitSinStock - D.Quantity
	FROM Products AS P
	INNER JOIN Inserted AS D ON D.ProductID = P.ProductID
GO

--Se hace una Insercion de datos
INSERT INTO [Order Details]
(
	OrderID,
	ProductID,
	UnitPrice,
	Quantity,
	Discount
)
VALUES
(
	10248, 
	32,
	0.0,
	5,
	0
)
GO

--Se comprueban las tablas afectadas
SELECT * FROM [Order Details] WHERE OrderID = 10248 AND ProductID = 32
SELECT * FROM Products WHERE ProductID = 32


--Cargar inventario
CREATE TRIGGER ActualizaInventario 
ON [Order Details] 
FOR DELETE
AS
	UPDATE P SET P.UnitInStock = P.UnitSinStock + D.Quantity
	FROM Products AS P
	INNER JOIN Deleted AS D ON D.ProductID = P.ProductID
GO

--Actualizar una fila de Order Details 
CREATE TRIGGER TR_Actualiza_Inventario
ON [Order Details]
FOR UPDATE
AS
	UPDATE P SET P.UnitInStock = P.UnitSinStock + D.Quantity
	FROM Products AS P
	INNER JOIN Deleted AS D ON D.ProductID = P.ProductID
	
	UPDATE P SET P.UnitInStock = P.UnitSinStock - I.Quantity
	FROM Products AS P
	INNER JOIN Inserted AS I ON I.ProductID = P.ProductID
GO


--Actualizamos
UPDATE [Order Details] SET Quantity = 8
WHERE OrderID=10248 AND ProductID = 32



----TRIGGERS INSTEAD OF: Cancela la operacion desencadenadora de una accion para realizar la del trigger----
CREATE VIEW VIEW_CATALOGO
WITH SCHEMABINDING
AS
	SELECT CompanyName, ContactName, ContactTitle, Country, 'Customers' AS [Type] FROM dbo.Customers
	UNION
	SELECT CompanyName, ContactName, ContactTitle, Country, 'Suppliers' AS [Type] FROM dbo.Suppliers
GO

SELECT * FROM Catalogo
GO


CREATE TRIGGER INSERT_CATALOGO
ON [VIEW_CATALOGO]
INSTEAD OF INSERT 
AS	
	INSERT INTO Customers (CustomerID, CompanyName, ContactName, ContactTitle, Country)
	SELECT SUBSTRING(CompanyName, 1, 5), CompanyName, ContactName, ContactTitle, Country, FROM INSERTED 
	WHERE [Type] = 'Customers'

	INSERT INTO Suppliers (CustomerID, CompanyName, ContactName, ContactTitle, Country)
	SELECT CompanyName, ContactName, ContactTitle, Country, FROM INSERTED 
	WHERE [Type] = 'Suppliers'
GO

INSERT INTO [CATALOGO]
(
	CompanyName, 
	ContactName,
	ContatTitle,
	Country,
	[Type]
)
VALUES
(
	'VISOAL',
	'JOSE',
	'ING',
	'REP DOM',
	'Suppliers'
)
GO

--Comprobacion de los datos
SELECT * FROM Suppliers
SELECT * FROM Customers

----TRIGGERS DDL----
CREATE TRIGGER PROTEGER
ON DATABASE
FOR DROP_TABLE, ALTER_TABLE
AS
	PRINT 'Usted no puede eliminar o modificar una tabla, consulte a su administrador'
	ROLLBACK
GO

DROP TABLE DeleteCustomer;
GO
