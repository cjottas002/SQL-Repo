/*
	Los cursores suelen ser mas lentos que usar DataSet en C#
	No todos los lenguajes de programacion manejan apropiedamente los Set de datos, por lo que deben usar cursores

	Sintaxis del CURSOR
		DECLARE <Nombre_Cursor> CURSOR [LOCAL | GLOBAL]
		[FORWARD_ONLY | SCROLL]
		[STATIC | KEYSET | DYNAMIC | FAST_FORWARD]
		[READ_ONLY | SCROLL_LOCKS | OPTIMISTIC]
		[TYPE_WARNING]
		FOR <SENTENCIA_SELECT>
		[FOR UPDATE[OF <Column_Name>[,...n]]][;]
*/

USE Nortwind;
GO

--Declarando el cursor
DECLARE Cursor1 CURSOR SCROLL
	FOR SELECT * FROM dbo.Customers
--Abrir el cursor
OPEN Cursor1
--Navegar
FETCH [FIRST | NEXT | LAST] FROM Cursor1
--Cerar cursor
CLOSE Cursor1
--Liberar memoria
DEALLOCATE Cursor1


--EJEMPLO 2--
--CURSORES
DECLARE @codigo VARCHAR(5), @compani VARCHAR(200),
	@contacto VARCHAR(150), @pais VARCHAR(100)
DECLARE ccustomers CURSOR GLOBAL STATIC
	FOR SELECT CustomerID, CompanyName, ContactName,
		   Country FROM Customers
OPEN ccustomers
FETCH ccustomers INTO @codigo, @compani, @contacto, @pais
WHILE(@@FETCH_STATUS=0)
	BEGIN
		PRINT @codigo + ' ' + @compani + ' ' + @contacto + ' ' + @pais
		FETCH ccustomers INTO @codigo, @compani, @contacto, @pais
	END
CLOSE ccustomers
DEALLOCATE ccustomers
GO

--Ejemplo 3--
--CURSORES ACTUALIZAR DATOS
DECLARE @codigo VARCHAR(5), @compania VARCHAR(200), @contacto VARCHAR(150), @pais VARCHAR(100)
DECLARE ccustomers CURSOR GLOBAL
	FOR SELECT CustomerID, CompanyName, ContactName, Country
	FROM Customers FOR UPDATE
OPEN ccustomers
FETCH ccustomers
INTO @codigo, @compania, @contacto, @pais
WHILE(@@FETCH_STATUS = 0)
BEGIN
	UPDATE Customers SET CompanyName = @compania + '(Modificado)'
	WHERE CURRENT OF ccustomers
	FETCH ccurstomers
	INTO @codigo, @compania, @contacto, @pais
END
CLOSE ccustomers
DEALLOCATE ccustomers
GO



