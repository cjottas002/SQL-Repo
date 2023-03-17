--INDICES DE FILA (CLUSTERED, NONCLUSTERED, HEAP, UNIQUE, NONUNIQUE)
USE Cidadano
GO

--Verificar la cantidad de registros en una tabla
SELECT COUNT(*)
FROM Ciudadano
GO

--Verificar los indices rows de una tabla
SP_HELPINDEX Ciudadano
GO

--Borrado de planes de ejecucion de la cache
DBCC FREEPROCCACHE WITH NO_INFOMSGS
DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS
GO

--Comprobar el tiempo que tarda una consulta extensa
SELECT Nom1, Nom2, Ape1, Ape2
FROM Ciudanado 
WHERE Nom1 = 'Victor' AND ape1 = 'Cardenas'

----LOS INDICES CLUSTERED ORDENA LOS DATOS ALFABETICAMENTE EN EL DISCO DE FORMA FISICA----

CREATE CLUSTERED INDEX CL_Nombre_Ciudadano ON Ciudadano(Nom1)
GO

--Solo se puede crear un indice clustered por tabla, luego los demás han de ser nonclustered (estos se crean mediante una struct de datos y no se ordenan físicamente en el disco)
--INDEX NONCLUSTERED
CREATE NONCLUSTERED INDEX CL_Apellido_Ciudadano ON Ciudadano(Ape1, Ape2)
GO

SELECT Nom1, Nom2, Ape1, Ape2
FROM Ciudadano 
WHERE Ape1 = 'Cardenas' AND Ape2 = 'Valenzuela';
GO

--Los indices se fragmentan segun introducimos datos ya que se ordenan fisicamente en disco, pero los nuevo se van agregando haciendo que se fragmente los datos sucesivos.
--Para conocer la fragmentacion de los indices de una tabla existe la instruccion siguiente:
DBCC SHOWCONTIG ('dbo.Ciudadano');
GO

--Un indice se puede crear con la instruccion UNIQUE lo que obligará a que el índice sólo contenta datos únicos
CREATE UNIQUE [CLUSTERED | NONCLUSTERED] INDEX NCLU_Apellido_Ciudadano ON Ciudadano(Ape1, Ape2)
GO


