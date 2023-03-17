SET STATISTICS IO, TIME ON;

SELECT * FROM dbo.TB_GRADO_ESTUDIO;
SELECT * FROM dbo.alumnos;

--INNER JOIN
SELECT A.CODIGO,
	   A.NOMBRES,
	   A.APELLIDOS,
	   A.FECHA_NAC,
	   A.EDAD,
	   B.DESCRIPCION_GRA
FROM dbo.alumnos A
INNER JOIN dbo.tb_grado_estudio B
ON A.CODIGO_GRA = B.CODIGO_GRA;

--LEFT JOIN
SELECT A.CODIGO,
	   A.NOMBRES,
	   A.APELLIDOS,
	   B.DESCRIPCION_GRA
FROM dbo.alumnos A
LEFT JOIN dbo.tb_grado_estudio B
ON A.CODIGO_GRA = B.CODIGO_GRA;

--RIGH JOIN
SELECT A.CODIGO,
	   A.NOMBRES,
	   A.APELLIDOS,
	   B.DESCRIPCION_GRA
FROM dbo.alumnos A
RIGHT JOIN dbo.tb_grado_estudio B
ON A.CODIGO_GRA = B.CODIGO_GRA;

--FULL OUTER JOIN
SELECT *
FROM dbo.alumnos A
FULL OUTER JOIN dbo.tb_grado_estudio B
ON A.CODIGO_GRA = B.CODIGO_GRA;