--Emascaramiento de Datos Dinamicos: Ofuscacion a los usuarios con menos privilegios dentro de SQL Server
CREATE DATABASE TestDataMasking
GO

USE TestDataMasking
GO

--Creacion de tabla
CREATE TABLE Cliente
(
	ClienteCodigo INT,
	ClienteNombre VARCHAR(100),
	ClienteFechaInicio DATETIME,
	ClienteEmail VARCHAR(100),
	ClienteTarjetaCredito VARCHAR(100)
)
GO

 -- ingreso de datos de ejemplo
INSERT INTO dbo.Cliente 
VALUES(101,'Visoalgt','2016-08-11 00:34:51:090','YoshiTannamuri@visoalgt.com','9135-5555-8798') 
INSERT INTO dbo.Cliente 
VALUES(102,'Cardenas Corp','2016-01-08 19:44:51:090','DanielTonini@cardenas.com','1555-9857-8709')
INSERT INTO dbo.Cliente 
VALUES(103,'Alfreds Futterkiste','2015-08-19 19:44:51:090','PhilipCramer@futterkiste.com','7675-3425-3433')
INSERT INTO dbo.Cliente 
VALUES(104,'Antonio Moreno Taquería','2014-08-19 19:44:51:090','PatriciaMcKenna@tqueria.com','5535-0297-6523')
INSERT INTO dbo.Cliente 
VALUES(105,'Around the Horn','2014-08-04 19:44:51:090','YoshiLatimer@araound.com','1354-2534-4534')
INSERT INTO dbo.Cliente 
VALUES(106,'Berglunds snabbköp','2015-08-10 19:44:51:090','chbrancar@beglunds.com','5203-4560-5455')
INSERT INTO dbo.Cliente 
VALUES(107,'Bs Beverages','2015-04-17 19:44:51:090','SimonCrowther@beverages','555-9482-3587')
INSERT INTO dbo.Cliente 
VALUES(108,'Bólido Comidas preparadasCable VGA','2015-08-21 19:44:51:090','FelipeIzquierdo@bolido.com','555-7555-4545')
INSERT INTO dbo.Cliente 
VALUES(109,'X enterprice','2015-08-06 19:44:51:090','CarlosGonzalez@xenterprice.com','2833-2951-4544')
INSERT INTO dbo.Cliente 
VALUES(110,'Chop-suey Chinese','2015-08-26 19:44:51:090','JohnSteel@chop.com','5535-1340-3453')
GO

--Consultar la tabla
SELECT * FROM Cliente
GO

-- Se mostraran los dos primeros caracteres y el ultimo caracter del nombre
ALTER TABLE dbo.Cliente ALTER COLUMN ClienteNombre  
ADD MASKED WITH (FUNCTION = 'PARTIAL(2, "XXXXXXXX", 1)');

-- Todas las direcciones de correo se mostraran nXXX@XXXX.com
ALTER TABLE dbo.Cliente ALTER COLUMN ClienteEmail  
ADD MASKED WITH (FUNCTION = 'EMAIL()');

-- Se motrara el dato de la siguiente manera nXXX-XXXX-XXXXn
ALTER TABLE dbo.Cliente ALTER COLUMN ClienteTarjetaCredito       
ADD MASKED WITH (FUNCTION = 'PARTIAL(1,"XXXX-XXXX-XXXXX",1)');

-- Todas las fechas las mostrara como 1900-01-01 
ALTER TABLE dbo.Cliente ALTER COLUMN Cliente_FechaInicio 
ADD MASKED WITH (FUNCTION = 'DEFAULT()');


--creacion de usuarios para prueba
CREATE USER VICTOR WITHOUT LOGIN;

--asignacion de permisos a los usuarios de prueba
GRANT SELECT ON dbo.Cliente TO VICTOR;

--Ejecución de una consulta en nombre del usuario recien creado
EXECUTE ('SELECT * FROM DBO.Cliente') AS USER='VICTOR';
GO

--Modificar una mascara
ALTER TABLE dbo.Cliente ALTER COLUMN Cliente_TarjetaCredito       
ADD MASKED WITH (FUNCTION = 'PARTIAL(0,"XXXX-XXXX-XXXXX",4)');
GO

--Consultar
SELECT * FROM dbo.Cliente
GO

--Eliminar una Mascara
ALTER TABLE dbo.Cliente ALTER COLUMN Cliente_TarjetaCredito DROP MASKED;
GO

SELECT * 
INTO Clientes2
FROM dbo.Cliente
GO

SELECT * FROM clientes2
GO


----ALWAYS ENCRYPTED----
--Permite encriptar los datos sensibles a los usuarios dentro de sus aplicaciones y nunca revelar las claves a SQL Server. Esto lo hace de forma automatica antes de pasar los datos a SQL Server
/*
	1) Los usuarios especifican columnas individuales de ciertas tablas a ser encriptados.
	2) Una vez cifrado, los datos aparecen con una marca de cifrado binario en todas las etapas al guardarse en el disco de BBDD, en memoria, durante los cálculos y en la red.
	3) Los usuarios utilizan un almacén de certificados para guardar la clave de cifrado.
	4) Tanto el cifrado como el descifrado se realizan por el conductor ADO.NET SqlClient para .NET 4.6. Este manejador requerirá el acceso a la clave de cifrado para que pueda comunicarse con el servidor SQL Server
	   directamente para efectuar el cifrado transparente.
*/


CREATE DATABASE Clinic;
GO

--Creacion de la Column Master Key
CREATE COLUMN MASTER KEY CMK1
WITH
(
	KEY_STORE_PROVIDER_NAME = N'MSSQL_CERTIFICATE_STORE',
	KEY_PATH = N'/var/opt/keys/My/B1257E84C5DA7432D4F3A7EA749DD1E83C1'
) 
GO

--Creacion de Column Encryption Key
CREATE COLUMN ENCRYPTION KEY CEK1
WITH VALUES
(
	COLUMN_MASTER_KEY = CMK1,
	ALGORITHM = 'RSA_OAEP',
	ENCRYPTED_VALUE = 0x016E000001630075007200720065006E00740075007300650072002F006D0079002F006200310032003500370065003800340063003500640061003700650061003500330037003400330032006400340066003300610037006500610037003400390064006400310065003800330063003100B5367B3584D3461FB20AA14C42544A94A419880CE2FDC63B9CB660AE09EFCE46B2DBF169782DDFA32DE53082B78FF9496CD9BCF01EC18FA797E5677C65997717B740E7BC13C23B86680B2972E59DA424E335FA2AEDAA120EF0DE6F931D05EC7481E6530E779D57036CB9000C55D32A2DB6C21E4C3BDC41DFC2847D5F5A5A951C78CF1C6E0C11814F3517341C8B97433668789D791E6196C275FF627FCB7114BA9F4080281D2E669495C0468A051B74E0E1E3ABD38BB39E0FE8D9919F9A459AF2E7561290349A12C38C876F5EF18C8477E1D298F90ADC75B9ABADE10E6E597167DB00D7A709D5F4B9506C37CC3555936A443D1691EC80900EA19687E1B1820CC6D2859E68697186A6B7873B3E3D67A116C74AB278F9D83B1195762BC6B98D3BAE2ABE465A8D81BF63BB193894DE1C736A5C87258F7F9E9FF38A72B15075E2F73E00F060500E1877ACBC8732E21300DF7B3CCD340B9C4C257F9280BAC080CFC805FAB0DFC7DDF927A6C35167296072BD77B8C25F1EC1FA86E8D63E960868BED60AF49EE71AE7327DD671E8E509E123DEF7CE28FC5F7C3D7EFA8E11782AC6BB8631968C85F5135228D6A6C190508A4941256D8FECDF85AF13A21710F4240C68DC7650D1CB58A1254C1C9F825892A0850520E2C3707A73926F4D9DA2BDF478EE102C436BBC9745BA345D42416A3A85F9CF4680F2F531F4F2CDC7A98DBE8BEFB3AF9E
)
GO

--Creacion de una tabla con columna encriptada. Tanto el tipo de algoritmo DETERMINISTIC como el RANDOMIZED tienen sus ventajas y restricciones
CREATE TABLE dbo.Patients
(
	PatientID INT IDENTITY(1,1),
	SSN NVARCHAR(11) COLLATE Latin1_General_BIN2 ENCRYPTED WITH (ENCRYPTION_TYPE = DETERMINISTIC, ALGORITHM = 'AEAD_AES_256_CBC_HMC_SHA_256', COLUM_ENCRYPTION_KEY = CEK1) NOT NULL,
	FirstName NVARCHAR(50) NULL,
	LastName NVARCHAR(50) NULL,
	MiddleName NVARCHAR(50) NULL,
	StreetAddress NVARCHAR(50) NULL,
	City NVARCHAR(50) NULL,
	ZipCode INT NULL,
	State NVARCHAR(50) NULL,
	BirthDate DATETIME2 ENCRYPTED WITH (ENCRYPTION_TYPE = RANDOMIZED, ALGORITHM = 'AEAD_AES_256_CBC_HMC_SHA_256', COLUM_ENCRYPTION_KEY = CEK1) NOT NULL
	PRIMARY KEY CLUSTERED (PatientID ASC) ON PRIMARY
)
GO

--Para hacer inserciones no se puede hacer de la forma tradicional, sino que se debe usar ADO.NET a traves de la aplicacion cliente para que puedan usarse las claves y encriptacion adecuada
INSERT INTO Patients (SSN, FirstName, LastName, MiddleName, BirthDate
VALUES
	(2345423524, 'Victor', 'Cardenas', 'H', '1979-01-25');
GO

--La sentencia anterior debe de provocar un fallo. Para ver la insercion de datos de forma correcta, verificar el fichero /Users/cjottas/Documents/SQL Command/Desarrollo de Bases de datos SQL Server/bin/AlwaysEncryptedDemo.cs
--Una vez que insertemos datos a traves del cliente, se pueden verificar los datos y las dos columnas encriptadas
SELECT * FROM Patients;
GO


--Un 'hack' para verificar los datos encriptados es el siguiente: Conectarse a la instancia sql, pestaña Additional Connection Parameters e introducimos lo siguiente - Column Encryption Settings = Enabled - y pulsamos en connect.



---Seguridad a nivel de fila---
CREATE DATABASE TestRowLevel;
GO

USE TestRowLevel;
GO

CREATE TABLE Ordenes
(
	Codigo_Cliente INT,
	Nombre_Producto VARCHAR(100),
	Fecha DATETIME,
	Cantidad INT,
	ProcesadoPor VARCHAR(100)
)
GO


INSERT INTO dbo.Ordenes 
VALUES 
	(101,'Monitores','2016-08-11 00:34:51:090',100,'SOFIA'),
	(102,'Teclados CORP','2016-01-08 19:44:51:090',700,'SOFIA'),
	(103,'Memoria RAM','2015-08-19 19:44:51:090',1500,'SOFIA'),
	(102,'Disco Duro','2014-08-19 19:44:51:090',1099,'CLAUDIA'),
	(101,'Web Cam','2014-08-04 19:44:51:090',5600,'CLAUDIA'),
	(103,'Ratones','2015-08-10 19:44:51:090',498,'HUGO'),
	(102,'Cable HDMI','2015-04-17 19:44:51:090',999,'HUGO'),
	(101,'Cable VGA','2015-08-21 19:44:51:090',543,'VICTOR'),
	(103,'Conectores RJ45','2015-08-06 19:44:51:090',876,'VICTOR'),
	(102,'Memory Stick','2015-08-26 19:44:51:090',665,'VICTOR')
GO


SELECT * FROM Ordenes;
GO

CREATE FUNCTION dbo.fn_seguridadOrdenes (@procesadoPor sysname)
RETURNS TABLE WITH SCHEMABINDING
AS
RETURN
	SELECT 1 AS [fn_seguridadordenes_resultado]
	FROM dbo.Ordenes
	WHERE @procesadoPor = USER_NAME()
GO

CREATE SECURITY POLICY fn_seguridad
ADD FILTER PREDICATE
dbo.fn_seguridadOrdenes(ProcesadoPor) ON dbo.Ordenes
GO

--Creacion de usuarios para prueba
CREATE USER VICTOR WOTHOUT LOGIN;
CREATE USER HUGO WITHOUT LOGIN;
CREATE USER CLAUDIA WITHOUT LOGIN;
CREATE USER SOFIA WITHOUT LOGIN;

--Asingnacion de permisos a los usuarios de prueba
GRANT SELECT ON dbo.Ordenes TO CLAUDIA;
GRANT SELECT ON dbo.Ordenes TO SOFIA;
GRANT SELECT ON dbo.Ordenes TO HUGO;
GRANT SELECT ON dbo.Ordenes TO VICTOR;

--Aqui se va a ejecutar una query en nombre del Usuario HUGO
EXECUTE ('SELECT * FROM dbo.Ordenes') AS USER = 'HUGO';

