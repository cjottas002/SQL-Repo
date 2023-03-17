--INDICES EN COLUMNAS (SE PIVOTEAN LAS COLUMNAS POR FILAS, TRASPONER COLUMNAS EN FILAS)--
--COLUMNSTORE INDEX--
USE Ciudadano;
GO

--Numero de registros
SELECT COUNT(*) FROM Ciudadano
GO

--Hacer una consulta a ciudadano
SELECT Nom1, Nom2, Ape1, Ape2 FROM Ciudadano
WHERE Ape1 = 'Cardenas' AND Ape2 = 'Valenzuela'
GO

--Creacion de ColumStore Index, el indice almacena todas las columnas de la tabla, por eso no se indica una columna concreta como el indice por fila
CREATE CLUSTERED CLOUMNSTORE INDEX CSI_Ciudadano ON Ciudadano
WITH (DROP_EXISTING=ON, MAXDOP=2) --La creacion del indice columnar puede tener parametros para indicar que borre un indice que ya existiera (DROP_EXISTING) o el numero maximo de procesadores que queremos que utilice mientra dure la opracion de indice (MAXDOP)
GO

--borar el indice columstore
DROP INDEX CSI_Ciudadano

--Liberamos cache
DBCC FREEPROCCACHE WITH NO_INFOMSGS;
DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS;
GO

--Comprobamos los indices asociados
SP_HELPINDEX Ciudadanos;
GO



