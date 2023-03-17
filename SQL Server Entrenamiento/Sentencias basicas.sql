CREATE DATABASE BD_TAREA02;
DROP DATABASE DB_TAREA02;
GO
USE BD_TAREA02;
GO
ALTER TABLE dbo.tb_usuarios2
ADD apellidos varchar(100) NOT NULL,
	fecha_nac date NOT NULL,
	edad int NOT NULL;
GO

--INSERT
INSERT dbo.tb_usuarios2(codigo, nombres, apellidos, fecha_nac, edad) VALUES (001, 'VICTOR', 'RAMOS', '1983-01-08', 37);
INSERT dbo.tb_usuarios2 VALUES (002, 'KEVIN', 'RAMOS', '01/01/2005', 15);

--UPDATE
UPDATE dbo.tb_usuarios2 SET fecha_nac = '01/01/2000', edad = 20 WHERE codigo = '2';

--DELETE, DROP, TRUNCATE
DELETE FROM dbo.tb_usuarios2 WHERE codigo = '2'
TRUNCATE TABLE dbo.tb_Usuarios2;
DROP TABLE dbo.tb_usuarios2;

--SELECT
SELECT [codigo], 
	   [nombres], 
	   [apellidos],
	   [fecha_nac]
FROM dbo.tb_usuarios2;

SELECT * FROM dbo.tb_usuarios2;
SELECT DISTINCT * FROM dbo.tb_usuarios2;
SELECT * FROM dbo.tb_usuarios2 WHERE codigo = '1';
SELECT * FROM dbo.tb_usuarios2 WHERE EDAD >= 20;
SELECT * FROM dbo.tb_usuarios2 WHERE EDAD <= 20;
SELECT * FROM dbo.tb_usuarios2 WHERE EDAD <> 20;
SELECT * FROM dbo.tb_usuarios2 WHERE EDAD BETWEEN 15 AND 38;
SELECT * FROM dbo.tb_usuarios2 WHERE NOMBRES LIKE 'C%'; --EMPIECE POR C Y LUEGO TENGA CUALQUIER LETRA
SELECT * FROM dbo.tb_usuarios2 WHERE NOMBRES LIKE '%S'; --EMPIECE POR CUALQUIER LETRA Y ACABE CON S
SELECT * FROM dbo.tb_usuarios2 WHERE NOMBRES LIKE '%A%'; --QUE POSEA UNA LETRA A EN CUALQUIER POSICION DEL STRING
SELECT * FROM dbo.tb_usuarios2 WHERE NOMBRES IN ('VICTOR', 'CARLOS');--COLOCAR CUALQUIER VALOR PARA VERIFICAR SI EXISTE EN LA TABLA INTERESADA
SELECT * FROM dbo.tb_usuarios2 WHERE NOMBRES = 'VICTOR' AND EDAD = 37;
SELECT * FROM dbo.tb_usuarios2 WHERE NOMBRES = 'CARLOS' OR EDAD IN(18, 20);
SELECT * FROM dbo.tb_usuarios2 WHERE CODIGO = 1 OR APELLIDOS = 'ARIAS';
SELECT * FROM dbo.tb_usuarios2 WHERE NOT APELLIDOS = 'RAMOS';
SELECT * FROM dbo.tb_usuarios2 WHERE APELLIDOS = 'RAMOS' AND (NOT NOMBRES = 'VICTOR');
SELECT * FROM dbo.tb_usuarios2 ORDER BY NOMBRES ASC, EDAD DESC;
GO