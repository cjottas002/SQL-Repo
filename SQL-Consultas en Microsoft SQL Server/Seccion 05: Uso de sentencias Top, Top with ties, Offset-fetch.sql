--ORDENAR Y FILTRAR DATOS
--PAGINACION CON OFFSET

USE Northwind;
GO

--Ordenar datos
SELECT [CompanyName] AS [Compañía], 
	   [ContactName] AS [Contacto], 
	   [ContactTitle] AS [Titulo], 
	   [Country] AS [Pais]
FROM [Suppliers]
ORDER BY [Pais]
GO

SELECT [C].[CustomerID], [C].[CompanyName], [C].[ContactName], [C].[Country], [O].[OrderID], [O].[OrderDate]
FROM [Customers] AS C 
INNER JOIN [Orders] AS O ON [C].[CustomerID] = [O].[CustomerID]
ORDER BY [C].[Country] DESC, [C].[CompanyName]
GO

--INSTRUCCION WHERE
SELECT [CompanyName], [ContactName], [ContactTitle], [Country]
FROM [Suppliers]
WHERE [CompanyName] LIKE '[A-C]%'
GO

SELECT [S].[CompanyName], [C].[CategoryName], [P].[ProductName], [P].[UnitPrice]
FROM [Products] AS P 
INNER JOIN [Suppliers] AS S ON [P].[SupplierID] = [S].[SupplierID]
INNER JOIN [Categories] AS C ON [P].[CategoryID] = [C].[CategoryID]
WHERE [C].[CategoryName] IN ('Condiments', 'Dairy Products', 'Grainms/Cereals');
GO

---TOP, WITH TIES, FETCH

--TOP
SELECT TOP 11 WITH TIES [ProductName], [UnitPrice] --WITH TIES SE UTILIZA PARA DEVOLVER LOS REGISTROS QUE COINCIDEN DE FORMA IDENTICA EN CAMPOS COMO POR EJEMPLO UnitPrice EN ESTE CASO
FROM [Products]
ORDER BY [UnitPrice] DESC
GO

--FETCH
SELECT [ProductName], [UnitPrice]
FROM [Products]
ORDER BY [UnitPrice] DESC OFFSET 20 ROWS --desplaza 20 registros
FETCH FIRST 10 ROWS ONLY --muestra los siguientes 10 registros
GO

--FETCH CON CICLO
DECLARE @i int = 0
WHILE @i < 10
BEGIN
	SELECT [LastName] + ' ' + [FirstName] FROM [Employees]
	ORDER BY [LastName] ASC OFFSET @i ROWS
	FETCH NEXT 2 ROWS ONLY
	SET @i = @i + 2
END
GO


---VALORES NULOS
SELECT [CustomerID], [CompanyName], [ContactName], [Phone], [Fax]
FROM [Customers]
GO

SELECT [CompanyName], [Phone], [Fax] =
	CASE 
		WHEN [Fax] IS NULL THEN 'No tiene'
		ELSE [Fax]
	END
FROM [Customers]
GO

SELECT [CompanyName], ISNULL([Fax], 0) 
FROM [Customers]
GO

SELECT [CompanyName], [Phone], [Fax], COALESCE([Fax], [Phone], 'No tiene') AS [MedioComunicacion] --COALESCE DEVUELVE EL VALOR DE LA PRIMERA COLUMNA, SI ES NULL, EL DE LA SEGUNDA Y SI ES NULL EL DE LA TERCERA
FROM [Customers]
WHERE [Fax] IS NULL
GO

