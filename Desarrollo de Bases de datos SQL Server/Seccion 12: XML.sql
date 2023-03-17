USE Northwind
GO

SELECT S.COMPANYNAME, P.PRODUCTNAME, P.UNITPRICE
FROM Suppliers AS S 
INNER JOIN Products AS P ON S.SupplierID = P.SupplierID
FOR XML PATH -- RAW,  PATH, AUTO, EXPLICIT
GO

--XML EXPLICIT (Usa un formato determinado)
SELECT 1 AS Tag, null AS parent, customerId AS [cliente!1!customerid],
contactName AS [cliente!1], null AS [orden!2!ordenid], null AS [orden!2]
FROM Customers WHERE CustomerID = 'ALFKI'
UNION ALL
SELECT 2 AS Tag, 1 AS parent, c.customerid, c.contactname, o.orderid, o.shipaddress
FROM customers AS c
INNER JOIN orders AS o ON c.CustomerID = o.CustomerID
WHERE c.CustomerID = 'ALFKI'
FOR XML EXPLICIT

--ANIADIR UNA COLUMNA DE TIPO XML
SELECT * FROM Orders
SELECT * FROM [Order Details]
GO

ALTER TABLE Orders
ADD Details XML
GO

SELECT o.orderid, o.orderdate, d.productid, d.unitprice, d.quantity
FROM Orders o 
INNER JOIN [Order Details] d ON o.OrderID = d.OrderID
GO

UPDATE o SET o.Details = (SELECT d.ORDERID, d.PRODUCTID, d.UNITPRICE, d.QUANTITY, d.DISCOUNT
						  FROM [Order Details] AS D WHERE o.ORDERID = d.OrderID FOR XML AUTO)
FROM Orders AS o
INNER JOIN [Order Details] AS d ON d.OrderID = o.OrderID

SELECT * FROM Orders

----------------------------------------------------------LECTURA DE XML------------------------------------------------------
USE NORTHWIND
GO

DECLARE @mydoc XML
SET @mydoc = '<root>
	<productdescription productid="1" productname="rood bike">
		<Features>
			<warranty>1 anio de garantia para partes</warranty>
			<maintenance>3 anios de mantenimiento</maintenance>
		</Features>
	</productdescription>
	<productdescription productid="2" productname="Mountain Bike">
		<Features>
			<warranty>5 anio de garantia para partes</warranty>
			<maintenance>2 anios de mantenimiento</maintenance>
		</Features>
	</productdescription>
</root>'

SELECT @mydoc.query('(/root/productdescription/Features/maintenance)[2]')

--XML.value

DECLARE @mydoc XML
SET @mydoc = '<root>
	<productdescription productid="1" productname="rood bike">
		<Features>
			<warranty>1 anio de garantia para partes</warranty>
			<maintenance>3 anios de mantenimiento</maintenance>
		</Features>
	</productdescription>
	<productdescription productid="2" productname="Mountain Bike">
		<Features>
			<warranty>5 anio de garantia para partes</warranty>
			<maintenance>2 anios de mantenimiento</maintenance>
		</Features>
	</productdescription>
</root>'

DECLARE @bike varchar(100)
SET @bike = @mydoc.value('(/root/productdescription/Features/maintenance)[2]', 'varchar(100)')

SELECT @bike
GO

USE Northwind
GO

ALTER TABLE Orders
ADD Details XML

UPDATE o set o.details = (SELECT d1.OrderId, d1.ProductID, d1.UnitPrice, d1.Quantity, d1.Discount
					   FROM [Order Details] AS d1 
					   WHERE o.orderid=d1.OrderID FOR XML AUTO
					   ) FROM orders AS o INNER JOIN [Order Details] AS d
						 ON o.orderid = d.orderid

SELECT *  FROM Orders

---TRANSFORMAR DATOS XML A TABLA
--XML.Node
DECLARE @mydoc XML
SET @mydoc = (SELECT Details FROM Orders WHERE OrderID = 10248)
SELECT 
OrderID = T.Item.value('@OrderID','BIGINT'),
ProductID = T.Item.value('@ProductID','BIGINT'),
UnitPrice = T.Item.value('@UnitPrice','MONEY'),
Quantity = T.Item.value('@Quantity','BIGINT'),
Discount = T.Item.value('@Discount','REAL')
FROM @mydoc.nodes('d1') AS T(Item)
GO

--CONVERTIR NUESTROS DATOS QUE ESTAN EN UN LENGUAJE XML A UN ARREGLO DE FILAS Y COLUMNAS (OPENXML)
DECLARE @mydoc XML, @i int
SET @mydoc = '<root>
<person LastName="White" FirstName="Johnson"/>
<person LastName="Green" FirstName="Marjorie"/>
<person LastName="Carson" FirstName="Cheryl"/>
</root>'

EXEC SP_XML_PREPAREDOCUMENT @i OUTPUT, @mydoc
SELECT * FROM OPENXML(@i, '/root/person') WITH (LastName NVARCHAR(50), FirstName NVARCHAR(50))





