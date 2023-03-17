--El propocito de utilizar código administrado o CLR es ampliar las funcionalidades que no tiene el SQL Server a través de lenguajes de programación como C# o VB.

USE Northwind;
GO

--Habilitar las opciones avanzadas
EXEC SP_CONFIGURE 'show advanced option', '1'
GO
RECONFIGURE
GO

--Habilitar el CLR (Common Language Runtime, para poder usar DLLs)
EXEC SP_CONFIGURE 'CLR enabled', '1';
GO
RECONFIGURE
GO

--Crear el ensablado
CREATE ASSEMBLY StoredProceduresASM FROM '/Users/cjottas/Documents/SQL Command/Desarrollo de Bases de datos SQL Server/bin/DLL.dll' --deberia existir ese dll en la ruta indicada
WITH PERMISSION_SET = EXTERNAL_ACCESS --UNSAFE. Puede ser de este tipo tambien y vale para cuando nuestro dll no llama a recursos externos fuera del sql. Para eso se deberia crear una llave asimetrica.
GO

CREATE PROCEDURE GetVersion AS EXTERNAL NAME
StoredProceduresASM.StoredProcedures.StoreProcedures
GO

CREATE FUNCTION IVA(@monto FLOAT)
RETURNS FLOAT
EXTERNAL NAME StoredProceduresASM.StoredProcedures.MontoConIva
GO

EXEC GetVersion;
GO

SELECT ProductName, UnitPrice, dbo.IVA(UnirPrice) AS MontoConIva
FROM Products;
GO

--CREACION DE UNA LLAVE ASIMETRICA PARA UN ENSAMBLADO DE TIPO UNSAFE--
--Step 1 - Create an asymmetric key from '~/strong_name.snk'
USE Master;
GO

--Step 2 = Create an asymmetric key
CREATE ASYMMETRIC KEY ASSEMBLY_KEY FROM FILE = '<path>';
GO

--Step 3 - Create a Login from the asymmetric key
CREATE LOGIN SIGN_ASSEMBLIES FROM ASYMMETRIC KEY ASSEMBLY_KEY;
GO

--Step 4 - GRANT the UNSAFE ASSEMBLY permission to the new Login
GRANT UNSAFE ASSEMBLY TO SIGN_ASSEMBLIES;
GO

--La otra opcion seria colocar la propiedad TRSTWORTHY a ON ya que de manera predeterminada esta en OFF. Luego los pasos anteriores no seria necesario hacerlo. Esto indica que la instancia SQL confía en 
--su base de datos. En el siguiente caso sería Northwind. 
ALTER DATABASE Northwind SET TRUSTWORTHY ON;
GO
