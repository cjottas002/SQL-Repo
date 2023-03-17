--OPTIMIZACION DE INDICES
USE Ciudadano;
GO

--Creamos una tabla para utilizar fragmentacion y optimizarla
CREATE TABLE Individuo
(
	Nom1 NVARCHAR(25) NULL,
	Nom2 NVARCHAR(25) NULL,
	Ape1 NVARCHAR(25) NULL,
	Ape2 NVARCHAR(25) NULL,
	Ape3 NVARCHAR(25) NULL,
	FechaNacimiento DATETIME2(7) NULL,
	Edad SMALLINT NULL,
	Genero SMALLINT NULL
	CodDep SMALLINT NULL,
	CodMun SMALLINT NULL,
	CodCom FLOAT NULL,
	Direccion NVARCHAR(80) NULL,
	Nro_Casa NVARCHAR(8) NULL,
	Nro_Zona SMALLINT NULL,
	Orden_Ced NVARCHAR(3) NULL,
	NumReg_Ced FLOAT NULL,
	DPI FLOAT NULL,
	NRoboleta FLOAT NULL,
	Status NVARCHAR(6) NULL,
	Cod_Geo NVARCHAR(20) NULL,
	Fech_Inscr DATETIME2(7) NULL,
	Fech_Modif DATETIME2(7) NULL,
	Muestra NVARCHAR(1) NULL,
	Filtro NVARCHAR(1) NULL

) ON PRIMARY
GO

CREATE CLUSTERED INDEX IDX_Cedula ON Individuo (Orden_Ced, NumReg_Ced)
GO

CREATE NONCLUSTERED INDEX NIDX_Apellidos ON Individuo (Ape1, Ape2) INCLUDE (Nom1)
GO

INSERT INTO Individuo
SELECT * FROM Ciudadano WHERE Ape1 LIKE '[A-C]%'
GO

INSERT INTO Individuo
SELECT * FROM Ciudadano WHERE Ape1 LIKE '[D-F]%'
GO

INSERT INTO Individuo
SELECT * FROM Ciudadano WHERE ape1 LIKE '[G-I]%'
GO

DELETE FROM Individuo WHERE Ape1 LIKE '[A]%'
GO

INSERT INTO Individuo
SELECT * FROM Ciudadano WHERE Ape1 LIKE '[A]%'
GO

INSERT INTO Individuo 
SELECT * FROM Ciudadano WHERE Ape1 LIKE '[J-Z]%'
GO

--Verificar la fagmentacion de los indices de una tabla dada
DBCC SHOWCONTIG(Individuo)
GO

--Verificar un indice concreto
DBCC SHOWCONTIG(Individuo, NIDX_Apellidos)
GO

----PODEMOS DEJAR MARGEN CUANDO CREAMOS INDICES PARA QUE ASI ENTRE BLOQUES DE PAGINAS QUEDEN UNOS ESPACIOS LIBRES PARA LA INSERCION, ACTUALIZACION O BORRADO DE DATOS Y LA FRAGMENTACION SEA MENOS AGRESIVA----
--Si la fragmentacion es de un 5-29% se deberia utilizar la instruccion ORGANIZE, si es mayor al 30% se deberia hacer un REBUILD
ALTER INDEX ISX_Cedula ON Individuo REORGANIZE;
GO

/*Con FILLFACTOR indicamos que las paginas del indice a nivel de hoja, es decir, bloques hoja que se llenen a un 80% dejando un 20% libre que permitan inserciones de datos antes de que se inicie la fragmentacion, PAD_INDEX reserva el espacio necesario para los bloque nodos, es decir, para el indice que contiene los datos y no se le puede especificar un valor diferente. Este ultimo toma el valor de FILLFACTOR*/
ALTER INDEX IDX_Cedula ON Individuo REBUILD WITH (FILLFACTOR=80, PAD_INDEX=ON)
GO


