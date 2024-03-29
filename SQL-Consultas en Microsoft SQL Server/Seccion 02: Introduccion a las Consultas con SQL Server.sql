--EJEMPLOS DE USO DE LA INSTRUCCION SELECT

USE NORTHWIND;
GO

--Comentariar solo una linea con --
--Comenariar un bloque /*  */
/* Para estos ejerciciós se usa la base de datos de ejemplo Northwind */

--DISTINCT MUESTRA SOLO VALORES UNICOS
SELECT DISTINCT COUNTRY FROM CUSTOMERS
GO

--CLAUSULA DE RESTRICCION WHERE
SELECT * FROM CUSTOMERS
WHERE COUNTRY='GERMANY'
GO

--Comparadores > < >= <= BETWEEN Ó LIKE
SELECT * FROM ORDERS
WHERE
ORDERDATE BETWEEN '1998-01-01' AND '1998-31-12' AND EMPLOYEEID=7
GO

--Instrucción LIKE el simbolo _ sustituye una letra, % varias letras
SELECT * FROM CUSTOMERS
WHERE COMPANYNAME LIKE '_e%'
GO

--Instrucción LIKE todos los que comienzan con A ó con D
SELECT * FROM Customers
WHERE Companyname LIKE '[AD]%'
GO

--Instrucción LIKE todos los que comienzan con A, B, C, D
SELECT * FROM Customers
WHERE Companyname LIKE '[A-D]%'
GO

--Instrucción LIKE todos los que no comiencen con la letra A,  [^]no contiene
SELECT * FROM Customers
WHERE Companyname LIKE '[^A]%'
GO

--Instruccion IN: LOS QUE ESTEN CONTENIDOS DENTRO DE LA LISTA
SELECT * FROM CUSTOMERS
WHERE COUNTRY  NOT IN ( 'BRAZIL','GERMANY','SPAIN')
GO

--TODOS LOS QUE NO COMIENCEN CON B, CUIDADO CON LOS ***NOT***

SELECT * FROM CUSTOMERS
WHERE COUNTRY NOT LIKE 'B%'
GO

--USO DEL NULL Y IS NOT NULL
--DEVULVAME TODOS LOS REGISTROS DE FAX VACIOS

SELECT CUSTOMERID, COMPANYNAME, FAX FROM CUSTOMERS
WHERE FAX IS NULL
GO

--DEVULVAME TODOS LOS REGISTROS DE FAX LLENOS
SELECT CUSTOMERID, COMPANYNAME, FAX FROM CUSTOMERS
WHERE FAX IS NOT NULL
GO

--USO DEL COUNT, CUENTA SOLO LOS REGISTROS LLENOS, LOS VALORES VACIOS NO
SELECT COUNT(FAX) FROM CUSTOMERS
GO

--USO DEL COUNT, CUENTA TODAS LAS FILAS
SELECT COUNT(*) FROM CUSTOMERS
GO

-- ORDER BY PARA ORDENAR POR LA COLUMNA O COLUMNAS QUE SE INDIQUEN
USE NORTHWIND;
GO

SELECT COUNTRY,CUSTOMERID,CONTACTNAME, CONTACTTITLE FROM CUSTOMERS
ORDER BY COUNTRY ASC , CUSTOMERID DESC
GO


--Para comprobar una tabla
SP_HELP Customers;
GO

