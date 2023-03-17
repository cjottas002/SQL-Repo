SELECT * from VIEW_ALUMNOS;

SELECT * FROM dbo.alumnos;

CREATE VIEW view_example
AS
SELECT codigo, apellidos, nombres, fecha_nac, edad
FROM dbo.alumnos;

SELECT * FROM view_example;

CREATE VIEW view_otherExample
AS
SELECT TOP (100) PERCENT apellidos, COUNT(*) AS Total
FROM dbo.alumnos
GROUP BY apellidos;

SELECT * FROM view_otherExample;

ALTER VIEW view_example
AS
SELECT codigo, nombres, apellidos 
FROM alumnos
WHERE codigo IN ('1', '4');

SELECT * 
FROM view_example 
WHERE codigo = '1';


CREATE VIEW view_alumnosGrados
AS
SELECT TOP (100) PERCENT a.codigo, 
						a.apellidos, 
						a.nombres, 
						a.edad, 
						g.descripcion_gra
FROM dbo.alumnos a
INNER JOIN dbo.tb_grado_estudio g
ON g.codigo_gra = a.codigo_gra

select * from view_alumnosGrados;