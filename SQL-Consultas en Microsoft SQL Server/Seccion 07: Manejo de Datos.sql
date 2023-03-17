USE Northwind;
GO

SET NOCOUNT ON;
GO

-------------------------------------------------------------------INSERT
INSERT INTO Customers (CustomerID, CompanyName, ContactName, ContactTitle, [Address], City, Region, PostalCode, Country, Phone, Fax)
VALUES
('ABCD5', 'Company, S.A', 'Juan Perez', 'Ing', '7av 3-3 Zona 5', 'REP DOM', 'REP DOM', '01005', 'REP DOM', '(809) - 2333182', '(829) - 2230182')
GO

--INSERTAR A PARTIR DE UN SELECT
INSERT INTO Customers
SELECT CONCAT(SUBSTRING(REPLACE(CompanyName, ' ', ''), 1, 4),'9') AS codigo, CompanyName, ContactName, ContactTitle, [Address], City, Region, PostalCode, Country, Phone, Fax
FROM Suppliers;
GO

SELECT COUNT(*) FROM Customers
GO

--INSERTAR DATOS A PARTIR DE UN PROCEDIMIENTO
CREATE PROC DatosProveedor
AS
	SELECT CONCAT(SUBSTRING(REPLACE(CompanyName, ' ', ''), 1, 4),'9') AS codigo, CompanyName, ContactName, ContactTitle, [Address], City, Region, PostalCode, Country, Phone, Fax
	FROM Suppliers;
GO

INSERT INTO Customers
EXEC DatosProveedor
GO

--CREAR A PARTIR DE LOS DATOS DE UN SELECT OTRA TABLA
SELECT C.CustomerID, C.CompanyName, O.OrderID, O.OrderDate
INTO OrdenesNuevas --para crear un objeto/tabla temporal solamente le tengo que agregar # delante, tal que: #OrdenesNuevas
FROM Customers AS C 
INNER JOIN Orders AS O ON O.CustomerID = C.CustomerID
GO

SELECT * FROM OrdenesNuevas;
GO

--BORRAR EL OBJETO
DROP TABLE OrdenesNuevas;
GO

--OBJETOS TEMPORALES
#TablaTemporal --Tabla temporal local, solo se ve en mi sesion
##TablaTemporal --Tabla temporal se ve en todas las sesiones


---------------------------------------------------------UPDATE
USE Northwind;
GO

UPDATE Customers SET CompanyName = CompanyName + 'USA'
WHERE Country = 'USA';
GO

SELECT * FROM Customers
WHERE Country = 'USA';
GO

UPDATE Customers SET CompanyName = REPLACE(CompanyName, 'USA', '')
WHERE Country = 'USA';
GO


-----------------------Actualizar los precios de los productos que provengan de estados unidos
SELECT * FROM Products;
SELECT * FROM Suppliers;
GO

SELECT P.ProductName, S.Country, P.UnitPrice
FROM Products AS P
INNER JOIN Suppliers AS S ON S.SupplierID = P.SupplierID
WHERE S.Country = 'USA';
GO

--TODAS LAS ORDENES DE LOS CLIENTES DE BRAZIL ACTUALICEN SU FECHA AL DIA DE HOY
--PRIMERO SACAMOS EL SELECT Y LUEGO HACEMOS EL UPDATE
--SELECT C.CustomerID, C.CompanyName, C.Country, O.OrderID, O.OrderDate
--FROM Customers AS C 
--INNER JOIN Orders AS O ON O.CustomerID = C.CustomerID
--WHERE C.Country = 'Brazil';
--GO

UPDATE O SET O.OrderDate = GETDATE()
FROM Customers AS C 
INNER JOIN Orders AS O ON O.CustomerID = C.CustomerID
WHERE C.Country = 'Brazil';
GO

--Actualizar los datos de una tabla con la cuya condicion se evalua en otra tabla 
UPDATE P SET P.UnitPrice = (P.UnitPrice*1.10)
FROM Products AS P
INNER JOIN Suppliers AS S ON S.SupplierID = P.SupplierID
WHERE S.Country = 'USA';
GO

-----------------------DELETE
USE Northwind;
GO

SELECT * FROM Customers
GO

DELETE FROM Customers
WHERE CustomerID LIKE '%5';
GO

DELETE FROM Customers
WHERE CustomerID = 'ANTON';
GO

--Iniciando una transaccion de forma explicita
BEGIN TRANSACTION
	DELETE FROM [Order Details]
	
	SELECT * FROM [Order Details]

COMMIT TRANSACTION
ROLLBACK TRANSACTION

-----ELIMINAR DATOS DE UNA TABLA CON RESPECTO A OTRA TABLA
--Puede haber dos FROM
DELETE FROM C
FROM Customers AS C 
LEFT OUTER JOIN Orders AS O ON O.CustomerID = C.CustomerID
WHERE O.OrderID IS NULL;
GO

DELETE D
FROM Orders AS O 
INNER JOIN [Order Details] AS D ON D.OrderID = O.OrderID
WHERE O.OrderDate = GETDATE()

--ELIMINA TODOS LOS DATOS DE LA TABLA, SIN ESCRIBIR EN EL LOG DE TRANSACCIONES
TRUNCATE TABLE [Order Details]



---------------------------------------------------------INSTRUCCION MERGE----------------------------------------------------------------
/*
	LA INSTRUCCION MERGE COMPARA DOS TABLAS.
	MERGE modifica los datos segun una condicion
		- Cuando la fuente coincide con el objetivo
		- Cuando la fuente no tiene coincidencias en el objetivo
		- Cuando el objetivo no coincide en la fuente

		EJEMPLO:
			MERGE INTO schema_name.table_name AS TargetTbl
				USING (SELECT <SELECT_list>) AS SourceTbl
				ON (TargeTbl.col1 = SourceTbl.col1)
				WHEN MATCHED THEN
					UPDATE SET col2 = SourceTbl.col2
				WHEN NOT MATCHED THEN
					INSERT (<column_list>)
					VALUES (<value_list>);
*/


--CREANDO TABLAS A COMPARAR
--TABLA A
SELECT CustomerID, CompanyName, ContactName, ContactTitle
INTO ClientesA
FROM Customers 
WHERE Country IN ('Mexico', 'Argentina', 'Venezuela')
GO

--TABLA B
SELECT CustomerID, CompanyName, ContactName, ContactTitle
INTO ClientesB
FROM Customers 
WHERE Country IN ('Mexico', 'Argentina', 'Venezuela')
GO

--ELIMINAR Y ACTUALIZAR DATOS DE CLIENTE A PARA PROVOCAR DIFERENCIAS CON RESPECTO A 
DELETE FROM ClientesA
WHERE CustomerID LIKE '[A-C]%'
GO

UPDATE ClientesA SET CompanyName = '***No definido***', ContactName = '***No tiene***'
WHERE CustomerID LIKE '[G-H]%'
GO

DELETE FROM ClientesB WHERE CustomerID = 'TORTU'
GO

--CONSULTAR TABLAS
SELECT * FROM ClientesA
SELECT * FROM ClientesB
GO

---MERGE, La idea es que la tabla A quede igual que la tabla B
MERGE INTO [dbo].ClientesA AS A -->Tabla Objetivo
	USING [dbo].ClientesB AS B --> Tabla Fuente
	ON B.CustomerID = A.CustomerID
	WHEN MATCHED THEN --OR NOT MATCHED
		UPDATE SET A.CompanyName = B.CompanyName, A.ContactName = B.ContactName
	WHEN NOT MATCHED THEN
		INSERT (CustomerID, CompanyName, ContactName, ContactTitle)
		VALUES (B.CustomerID, B.CompanyName, B.ContactName, B.ContactTitle)
	WHEN NOT MATCHED BY SOURCE THEN
		DELETE;
GO

--CONSULTAR TABLAS MODIFICADAD
SELECT * FROM ClientesA
SELECT * FROM ClientesB
GO


----IDENTITY Y SEQUENCE
---TABLA CON IDENTITY PARA GENERAR UN NUMERO UNICO E IRREPETIBLE
CREATE TABLE Test1
(
	Codigo INT IDENTITY(5,5) PRIMARY KEY, --que inicie en 5 y vaya de 5 en 5
	Nombre VARCHAR(100)
)
GO

INSERT INTO Test1 (Nombre) VALUES ('Jose Miguel'), ('Monica Susett')
GO

---SE TRATA DE UAN FUNCION DEL SISTEMA QUE DEVUELVE EL ULTIMO VALOR DE IDENTIDAD INSERTADO DE FORMA GLOBAL
SELECT @@IDENTITY
GO

--ULTIMO VALOR GENERADO POR EL IDENTITY DE UNA TABLA CONCRETA
SELECT IDENT_CURRENT('Test1');
GO

----IDENTITY_INSERT
SET IDENTITY_INSERT Test1 ON
SET IDENTITY_INSERT Test1 OFF
GO

INSERT INTO Test1 (Codigo, Nombre) 
VALUES 
(3, 'Maria Concepcion'), 
(4, 'Victor Hugo')
GO

--SEQUENCE, --PUEDE SER LLAMADO POR MAS DE UNA TABLA, ES UN OBJETO Y NO QUEDA SUJETO A NINGUNA TABLA EN PARTICULAR
CREATE SEQUENCE Numerador
AS INT
START WITH 5
Increment BY 5
MinValue 5
MaxValue 15
NO Cycle 
GO

SELECT NEXT VALUE FOR Numerador
GO

-------CREANDO TABLA PARA PROBAR SEQUENCE
CREATE TABLE Test2
(
	Codigo INT,
	Nombre VARCHAR(100)
)
GO

--------------INSERTAR DATOS USANDO SEQUENCE
INSERT INTO Test2 (Codigo, Nombre)
VALUES
(NEXT VALUE FOR Numerador, 'Hugo'),
(NEXT VALUE FOR Numerador, 'Paco'),
(NEXT VALUE FOR Numerador, 'Luis')
GO

SELECT * FROM Test2
GO

CREATE TABLE Test3
(
	Codigo INT PRIMARY KEY DEFAULT(NEXT VALUE FOR Numerador),
	Nombre VARCHAR(100)
)
GO

INSERT INTO Test3 (Nombre) 
VALUES ('Juan'),
	   ('Miguel')
