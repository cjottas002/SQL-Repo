--TIPOS DE FUNCIONES INTEGRADAS DE SQL SERVER
/*
	FUNCTION CATEGORY							DESCRIPTION
		FUNCIONES ESCALARES							OPERAR EN UNA SOLA FILA, DEVUELVE UN SOLO VALOR
		FUNCIONES AGREGADAS							TOME UNO O MAS VALORES, PERO DEVUELVE UN SOLO VALOR
		FUNCIONES DE VENTANA						OPERA EN UNA VENTANA (CONJUNTO) DE FILAS
		FUNCIONES DE ROWSET							DEVOLVER UNA TABLA VIRTUAL QUE SE PUEDE UTILIZAR POSTEIORMENTE
													EN UNA INSTRUCCION T-SQL(EXTRAE EL CONJUNTO DE DATOS DE UNA FUENTE DE DATOS EXTERNA, NO ES MI INSTANCIA DE SQL LOCAL)
*/
USE Northwind;
GO

--FUNCIONES ESCALARES
--EXTRAER EL ANIO Y EL MES DE UNA FECHA

SELECT OrderID, OrderDate, YEAR(OrderDate) AS Anio, MONTH(OrderDate) AS Mes
FROM Orders
GO

--DIAS TRANSCURRIDOS DESDE LA FECHA DE PEDIDO HASTA HOY
SELECT OrderID, OrderDate, DATEDIFF(dd, [OrderDate], GETDATE()) AS DiasTranscurridos
FROM Orders;
GO

--EDAD
DECLARE @fechaNacimiento DATE = '01-25-76'
SELECT DATEDIFF(yy, @fechaNacimiento, GETDATE()) AS Edad
GO


--FUNCIONES DE AGREGADO
--CONTEO DE TODOS LOS CLIENTE
SELECT COUNT(*)
FROM Customers
GROUP BY Country
GO

--CONTEO DE LOS CLIENTES POR PAIS
SELECT Country, COUNT(*)
FROM Customers
GROUP BY Country
GO

--CONTEO DE LOS PRODUCTOS POR CATEGORIA
SELECT C.CategoryName, P.ProductName
FROM Products AS P
INNER JOIN Categories AS C ON C.CategoryID = P.CategoryID
GO

--CATEGORIA Y NUMERO DE PRODUCTOS POR CATEGORIA--PIERDO EL DETALLE
SELECT C.CategoryName, COUNT(P.ProductName)
FROM Products AS P
INNER JOIN Categories AS C ON C.CategoryID = P.CategoryID
GROUP BY C.CategoryName;
GO

--FUNCIONES DE VENTANA
SELECT C.CategoryName, P.ProductName, COUNT(P.ProductName) OVER (PARTITION BY C.CategoryName) AS Numero
FROM Products AS P
INNER JOIN Categories AS C
ON C.CategoryID = P.CategoryID;
GO

--FUNCIONES DE ROWSET, ESTAS SON MAS COMPLEJAS Y LOS DATOS ESTAN EN UN DOCUMENTO JSON, XML, ETC
--PARA ESTO HAY QUE IR AA SERVER OBJECTS > LINKED SERVER Y ANIADIR UN SERVIDOR REMOTO, LUEGO PODEMOS HACER LO SIGUIENTE
SELECT * FROM OPENQUERY([<NombreServidorRemoto>], 'SELECT * FROM Database.Schema.Table')


----------------------------FUNCIONES DE CONVERSION------------------------------------------------------------
--CONVERSION IMPLICITA
DECLARE @string VARCHAR(100);
SET @string = 1;
SELECT @string + ' es un texto';
GO

DECLARE @notString INT;
SET @notString = '1';
SELECT @notString + '1';
GO

--USO DE LA FUNCION CAST
SELECT 'El producto:' + productName + ', tiene el precio de: ' + CAST(UnitPrice AS VARCHAR(10)) AS Precio
FROM Products
GO

--OTRO EJEMPLO DE CAST
SELECT CAST(SYSDATETIME() AS DATE);
GO

--CONVERT
SELECT 'El producto: ' + ProductName + ', tiene el precio de: ' + CONVERT(VARCHAR(10), UnitPrice) AS Precio
FROM Products
GO

--TRY_CONVERT
SELECT TRY_CONVERT(INT, ProductName) AS Precio
FROM Products;
GO

--OTRO EJEMPLO DE CONVERT
SELECT CURRENT_TIMESTAMP;
SELECT CONVERT(CHAR(8), CURRENT_TIMESTAMP, 101) AS ISO_USA;
SELECT CONVERT(CHAR(8), CURRENT_TIMESTAMP, 102) AS ISO_ANSI;
SELECT CONVERT(CHAR(8), CURRENT_TIMESTAMP, 103) AS ISO_UK_FR;
SELECT CONVERT(CHAR(8), CURRENT_TIMESTAMP, 104) AS ISO_GER;


--FUNCION PARSE
SELECT PARSE('Monday, 13 december 2010' AS DATETIME2 USING 'EN-us') AS Fecha;
GO

SELECT TRY_PARSE('Monda, 13 december 2010' AS DATETIME2 USING 'EN-us') AS Fecha;
GO

SET LANGUAGE 'English';
SELECT PARSE('12/16/2010' AS DATETIME2) AS Result;

----------------FUNCIONES LOGICAS-------------------------
--EVALUAR SI EL VALOR ES NUMERICO O NO
SELECT ISNUMERIC('SQL') AS ISNUMERIC_RESULT; --1 TRUE, 0 FALSE
GO

SELECT	ProductName, 
		ISNUMERIC(ProductName) AS validaProductName, 
		UnitPrice, ISNUMERIC(UnitPrice) AS ValidaUnitPrice,
		CategoryID
FROM Products
GO

--IIF
SELECT	ProductName, 
		UnitPrice, 
		IIF(UnitPrice > 50, 'high','low') AS PricePoint
FROM Products;
GO

SELECT	ProductName, UnitPrice, CategoryID, Discontinued,
		IIF(Discontinued=0, 'Vigente', 'Descontinuado') AS [Status]
FROM Products

--CHOOSE
SELECT ProductName, 
CHOOSE (CategoryID,'Beverages' ,'Condiments','Confections' ,'Dairy Products' ,'Grains/Cereals' ,'Meat/Poultry' ,'Produce' ,'Seafood')
from Products
GO

SELECT CHOOSE(3, 'Hugo', 'Paco', 'Luis') AS Patos
GO

SELECT	ProductName, 
		UnitPrice,
		CHOOSE(CategoryID, 'Beverages', 'Condiments', 'Confections',
						   'Dairy Products', 'Gains/Cereals', 'Meat/Poultry',
						   'Produce', 'Seafood') AS Category
FROM Products;
GO

--ISNULL
Select CustomerID, CompanyName, ISNULL(Fax,'n/a') 
from Customers
GO

SELECT CompanyName, ISNULL(Fax, '00000-00000')
FROM Customers
GO

---COALESCE
--Toma el primer valor no nulo de una lista

SELECT CustomerID, Country, Region, City,
                Country + ',' + COALESCE(Region, ' ') + ', ' + City as location
FROM Customers;
GO

SELECT CompanyName, COALESCE(Fax, Phone, '000-000')
FROM Customers;
GO

Select CustomerID, Fax, Phone, COALESCE(fax, phone) as Comunication 
from Customers;
GO

--NULLIF
--Si el precio es igual pone NULL si no pone el precio del primero
Select	P.ProductName, 
		P.UnitPrice, 
		D.UnitPrice, 
		NULLIF( p.unitprice,d.unitprice) as Comparacion
from products as P 
inner join [order details] as D ON P.productid=D.productid

SELECT	D.OrderID, 
		P.ProductName, 
		P.UnitPrice AS PrecioStock,
		D.UnitPrice AS PrecioVenta,
		NULLIF(D.UnitPrice, P.UnitPrice) AS Comparacion
FROM [Order Details] AS D
INNER JOIN Products AS P ON P.ProductID = D.ProductID
