--OBJETOS DE PROGRAMACION DEL SQL SERVER
/* 
	VIEWS: 
		No es posible colocar la instruccion ORDER BY en las vistas, a menos que coloquemos la instruccion TOP.
	FUNCTIONS
	STORED PROCEDURES
	TRIGGERS
 */

USE Northwind;
GO

--Consulta AD HOC
SELECT * FROM [Order Details]
GO

--Consultas a traves de VIEWS
CREATE VIEW VIEW_VENTAS
AS
	SELECT 	C.CustomerID,
		C.CompanyName,
		C.Country,
		O.OrderID,
		O.OrderDate,
		CAT.CategoryName,
		P.ProductName,
		D.UnitPrice,
		D.Quantity,
		D.UnitPrice * D.Quantity AS TotalPartial
	FROM Customer AS C
	INNER JOIN Orders AS O on O.CustomerID = C.CustomerID
	INNER JOIN [Order Details] AS D ON D.OrderID = O.OrderID
	INNER JOIN Products AS P ON P.ProductID = D.ProductID
	INNER JOIN Categories AS CAT ON CAT.CategoryID = P.CategoryID
GO

SELECT * FROM VIEW_VENTAS
GO

--Se pueden cambiar el nombre de las columnas que se muestran en las VIEWS
CREATE VIEW VIEW_VENTAS (CodigoCliente, Compañia, Pais, NumeroOrder, Fecha, Categoria, Producto, Precio, Cantidad, Total)
AS
	SELECT 	C.CustomerID,
		C.CompanyName,
		C.Country,
		O.OrderID,
		O.OrderDate,
		CAT.CategoryName,
		P.ProductName,
		D.UnitPrice,
		D.Quantity,
		D.UnitPrice * D.Quantity AS TotalPartial
	FROM Customer AS C
	INNER JOIN Orders AS O on O.CustomerID = C.CustomerID
	INNER JOIN [Order Details] AS D ON D.OrderID = O.OrderID
	INNER JOIN Products AS P ON P.ProductID = D.ProductID
	INNER JOIN Categories AS CAT ON CAT.CategoryID = P.CategoryID
GO

SELECT * FROM VIEW_VENTAS
GO

--ORDER BY con la instruccion TOP
CREATE VIEW VIEW_VENTAS (CodigoCliente, Compañia, Pais, NumeroOrder, Fecha, Categoria, Producto, Precio, Cantidad, Total)
AS
	SELECT TOP(10) C.CustomerID,
		C.CompanyName,
		C.Country,
		O.OrderID,
		O.OrderDate,
		CAT.CategoryName,
		P.ProductName,
		D.UnitPrice,
		D.Quantity,
		D.UnitPrice * D.Quantity AS TotalPartial
	FROM Customer AS C
	INNER JOIN Orders AS O on O.CustomerID = C.CustomerID
	INNER JOIN [Order Details] AS D ON D.OrderID = O.OrderID
	INNER JOIN Products AS P ON P.ProductID = D.ProductID
	INNER JOIN Categories AS CAT ON CAT.CategoryID = P.CategoryID
	ORDER BY C.CompanyName
GO

--Para comprobar el script que origina la vista se utiliza el siguiente stored Procedure
SP_HELPTEXT VIEW_VENTAS

--Si queremos encriptar el script que origina la vista le agregamos a la vista WITH ENCRYPTION	
CREATE VIEW VIEW_VENTAS (CodigoCliente, Compañia, Pais, NumeroOrder, Fecha, Categoria, Producto, Precio, Cantidad, Total)
WITH ENCRYPTION
AS
	SELECT 	C.CustomerID,
		C.CompanyName,
		C.Country,
		O.OrderID,
		O.OrderDate,
		CAT.CategoryName,
		P.ProductName,
		D.UnitPrice,
		D.Quantity,
		D.UnitPrice * D.Quantity AS TotalPartial
	FROM Customer AS C
	INNER JOIN Orders AS O on O.CustomerID = C.CustomerID
	INNER JOIN [Order Details] AS D ON D.OrderID = O.OrderID
	INNER JOIN Products AS P ON P.ProductID = D.ProductID
	INNER JOIN Categories AS CAT ON CAT.CategoryID = P.CategoryID
GO


--Podemos vincular las tablas que originan una vista con el objetivo de que estas no puedan ser borradas y corrompan la vista. Esto se realiza con la instruccion SCHEMABINGING. Una vez agregada la instruccion
--se debe colocar el nombre de la tabla junto con su esquema, de esta forma queda la vinculacion definida
CREATE VIEW VIEW_VENTAS (CodigoCliente, Compañia, Pais, NumeroOrder, Fecha, Categoria, Producto, Precio, Cantidad, Total) 
WITH SCHEMABINDING
AS 
SELECT 	C.CustomerID,
		C.CompanyName,
		C.Country,
		O.OrderID,
		O.OrderDate,
		CAT.CategoryName,
		P.ProductName,
		D.UnitPrice,
		D.Quantity,
		D.UnitPrice * D.Quantity AS TotalPartial
	FROM dbo.Customer AS C
	INNER JOIN dbo.Orders AS O on O.CustomerID = C.CustomerID
	INNER JOIN dbo.[Order Details] AS D ON D.OrderID = O.OrderID
	INNER JOIN dbo.Products AS P ON P.ProductID = D.ProductID
	INNER JOIN dbo.Categories AS CAT ON CAT.CategoryID = P.CategoryID
GO

--Comprobacion que no se puede borrar ninguna de las tablas relacionadas con la vista VIEW_VENTAS
DROP TABLE [Order Details]
GO

DROP TABLE Products;
GO

DROP TABLE Categories;
GO

--Para hacerle creer al cliente que utilice la vista de que esta es una "tabla" se utiliza la instruccion VIEW_METADATA
CREATE VIEW VIEW_VENTAS (CodigoCliente, Compañia, Pais, NumeroOrder, Fecha, Categoria, Producto, Precio, Cantidad, Total)
WITH VIEW_METADATA
AS
	SELECT 	C.CustomerID,
		C.CompanyName,
		C.Country,
		O.OrderID,
		O.OrderDate,
		CAT.CategoryName,
		P.ProductName,
		D.UnitPrice,
		D.Quantity,
		D.UnitPrice * D.Quantity AS TotalPartial
	FROM Customer AS C
	INNER JOIN Orders AS O on O.CustomerID = C.CustomerID
	INNER JOIN [Order Details] AS D ON D.OrderID = O.OrderID
	INNER JOIN Products AS P ON P.ProductID = D.ProductID
	INNER JOIN Categories AS CAT ON CAT.CategoryID = P.CategoryID
GO


--WITH CHECK OPTIONS, se utiliza para que si el cliente trata de insertar datos a traves de una vista, necesitaria cumplir con la/s condicion/es que incluya el query
CREATE VIEW VIEW_CLIENTESPORPAIS
AS
	SELECT CustomerID, CompanyName, ContactName, ContactTitle, Country
	FROM Customers
	WHERE Country = 'USA'
WITH CHECK OPTION
GO

SELECT * FROM VIEW_CLIENTESPORPAIS
GO

INSERT INTO VIEW_CLIENTESPORPAIS (CustomerID, CompanyName, ContactName, ContactTitle, Country)
VALUES
	('ABCD3', 'VISOAL, S.A.', 'JUAN PEREZ', 'ING', 'REP DOM')
GO

--Vistas Particionadas. Estas contienen la instruccion UNION
CREATE VIEW VIEW_CATALOGO
AS
	SELECT CustomerID, CompanyName, ContactName, ContactTitle, Country
	FROM Customers
	UNION --ALL, UNION ALL Incluye todos los datos incluso los repetidos
	SELECT CustomerID, CompanyName, ContactName, ContactTitle, Country
	FROM Suppliers
GO

--Se puede crear una VIEW a partir de otra. No sería óptimo crear vistas sobre vistas más allá de 3 niveles
CREATE VIEW VIEW_LISTAEMPRESAS
AS
	SELECT * FROM VIEW_CATALOGO
GO

--A las VIEWS se le pueden agregar indices, pero con ciertas restricciones. En algunas BBDD se les denonima Vistas Materializadas (porque deben crear una struct para esos indices y materializarlos)
/*
	Restricciones de los indice en las vistas
		1) Debe existir un CLUSTERED UNIQUE INDEX creado previamente para la vista y luego se puede agregar otros NONCLUSTERED INDEX 
		2) La VIEW debe estar enlazada a SCHEMA	
*/

CREATE UNIQUE CLUSTERED INDEX IDX_VENTAS ON VIEW_VENTAS (CodigoCliente, NumeroOrden, Producto) --Juntas no tienen repetidos, ya que es un index unique
GO

--Ya se pueden agregar indices NONCLUSTERED
CREATE NONCLUSTERED INDEX IDX_Compania ON VIEW_VENTAS (COMPAÑIA)
GO

--Verificar si usa el INDEX
SELECT * FROM VIEW_VENTAS;
GO

SELECT COMPAÑIA FROM VIEW_VENTAS WHERE COMPAÑIA = 'Victuailles en stock';
GO

--Verificar el plan de ejecucion para confirmar que esta utilizando el indice de la vista y no el de la tabla--

--VISTAS DEL SISTEMA: Se utilizan generalmente para ver la metadata--
--Para consultar los CONSTRAINTS de la bbdd
SELECT * FROM INFORMATION_SCHEMA.CHECK_CONSTRAINTS
GO

--CONSTRAINT de llave primaria y llave foranea
SELECT * FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
GO

--VISTAS DE ADMINISTRACION DINAMICAS: tambien sirven para consultar metadata. Existen en el SCHEMA [sys]
SELECT WAIT_TYPE, WAIT_TIME_MS 
FROM [sys].DM_OS_WAIT_STATS;
GO

