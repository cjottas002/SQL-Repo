/*
	TABLAS OPTIMIZADAS PARA LA MEMORIA:
					Permiten cargar a memoria RAM todos los conjuntos de datos con el objetivo de hacer las consultas mas rapidas. Estos son definidos como estructuras C,
					compilado en DLL y cargado en memoria
					Pueden persistir como datos FILESTREAM o no duraderos	
					Las tablas en memoria no poseen CLUSTERED INDEX, sino que llevan asociado un NONCLUSTERED HASH INDEX y se le debe incluir una cantidad de BUCKET que sirve 
					para reservar espacio en memoria para la metada de esa tabla optimizada.
*/

USE Ciudadano
GO

ALTER DATABASE Ciudadano
ADD FILEGROUP CiudadanoInMemory_MOD
CONTAINS MEMORY_OPTIMIZED_DATA
GO

ALTER DATABASE Ciudadano
ADD FILE
(
	NAME = 'CiudadanoInMemory',
	FILENAME = '/var/data/mssql/CiudadanoInMemory',
)
TO FILEGROUP CiudadanoInMemory_MOD
GO

SELECT TOP 100 * FROM Ciudadano

SELECT COUNT(*) FROM Ciudadano

CREATE TABLE [DiskBasedCiudadanoTable]
(
	Codigo INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Nom1 NCHAR(150) NULL,
	Nom2 NCHAR(150) NULL,
	Ape1 NCHAR(200) NULL,
	Ape2 NCHAR(200) NULL
)
GO

CREATE TABLE [MemoryOptimizedCiudadanoTable]
(
	Codigo INT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED HASH WITH (BUCKET_COUNT = 50000),
	Nom1 NCHAR(150) NULL,
	Nom2 NCHAR(150) NULL,
	Ape1 NCHAR(200) NULL,
	Ape2 NCHAR(200) NULL
) WITH (MEMORY_OPTIMIZED = ON, DURABILITY = SCHEMA_AND_DATA) --Se establece una durabilidad de SCHEMA_AND_DATA con el objetivo tener la tabla en memoria incluido los datos, pero el archivo vinculado al FILEGROUP optimizado para memoria, esta sirviendo
	-- de auxiliar para contener los datos que tiene nuestra tabla en memoria, de tal manera que si se reinicia el servidor los datos de manera auxiliar se almacenan en ese archivo 
	--'/var/data/mssql/CiudadanoInMemory' vinculado al FILEGROUP y cuando el servidor vuelva a estar levantado, este cargara los datos a memoria nuevamente para tenerlos disponibles.
	--Si se estableciera la DURABILITY en SCHEMA_ONLY, la tabla se volveria a crear, pero los datos almacenados previamente se perderian
GO

--Hacemos la prueba de meter una cantidad de datos masiva
INSERT INTO DiskBasedCiudadanoTable
(
	Nom1, 
	Nom2,
	Ape1,
	Ape2
)
SELECT	TOP 1000000
	Nom1,
	Nom2,
	Ape1,
	Ape2
FROM Ciudadano
GO

INSERT INTO MemoryOptimizedCiudadanoTable 
(
	Nom1, 
	Nom2,
	Ape1,
	Ape2
)
SELECT	TOP 1000000
	Nom1,
	Nom2,
	Ape1,
	Ape2
FROM Ciudadano
GO

--Verificamos el plan de ejecucion para comprobar cual es
SELECT Nom1, Nom2, Ape1, Ape2
FROM MemoryOptimizedCiudadanoTable
WHERE Nom1 = 'Victor'

--Le creamos un indice para la tabla en memoria
ALTER TABLE MemoryOptimizedCiudadanoTable
ADD INDEX IDX_Nombre (Nom1, Nom2)
GO

--Crear un INDEX HASH
ALTER TABLE MemoryOptimizedCiudadanoTable
ADD INDEX IDX_APELLIDOS HASH (Ape1) WITH (BUCKET_COUNT = 50000) --Espacio apartado para los datos del indice (en la memoria)
GO

--Se busca comprobar cuantos espacios de memoria ocupa para esta tabla en memoria y así ajustar el BUCKET_COUNT a un numero de espacios en memoria mas adecuado.
SELECT DISTINCT Ape1 FROM MemoryOptimizedCiudadanoTable
GO

--CREAR UN STORED PROCEDURE DE FORMA NATIVA: Estos sirven para las tablas optimizadas de memoria y se ejecutan de forma mas eficaz que los Stored Procedures normales, ya que este tipo de SP se compilan cuando se esta creando.
	--El bloque atomico ha de tener siempre un nivel de aislamiento asociado, asi como un LANGUAGE que se debe establecer en uno de los lenguajes existentes o ALIAS obligatorio

CREATE PROCEDURE INSERT_TABLAMEMORIA
(
	@Nom1 VARCHAR(150),
	@Nom2 VARCHAR(150),
	@Ape1 VARCHAR(150),
	@Ape2 VARCHAR(150)
)
WITH NATIVE_COMPILATION, SCHEMABINDING --Esto es para que no podamos anular tablas a las que hace referencia el Stored Procedure. 
AS
BEGIN ATOMIC WITH (TRANSACTION ISOLATION LEVE = SNAPSHOT, LANGUAGE = 'ENGLISH') --Se especifica un nivel de aislamiento de transaccion
	INSERT INTO dbo.MemoryOptimizedCiudadano (Nom1, Nom2, Ape1, Ape2)
	VALUES
		(@Nom1, @Nom2, @Ape1, @Ape2)
END
GO

--Ejecutamos el Stored Procedure para insertarle datos a la tabla en memoria
EXEC INSERT_TABLAMEMORIA 'JOSE', 'ARMANDO', 'DE LEON', 'PALACIOS'
GO

