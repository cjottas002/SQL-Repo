
SELECT COUNT(E.PeliculaCodigo) 
FROM EJEMPLAR AS E 
INNER JOIN PELICULA AS P ON P.PeliculaCodigo = E.PeliculaCodigo
WHERE P.NombrePelicula = 'Titanic';
GO

SELECT A.Total
FROM CLIENTE AS C
INNER JOIN ALQUILER AS A ON A.ClienteCodigo = C.ClienteCodigo
WHERE C.ClienteNombre = 'Claudia Hernandez';
GO

SELECT A.ActorNombre
FROM ACTOR AS A
INNER JOIN REPARTO AS R ON R.PeliculaActor = A.ActorCodigo
INNER JOIN PELICULA AS P ON P.PeliculaCodigo = R.PeliculaCodigo
WHERE P.PeliculaTitulo = 'Casa Blanca';
GO

SELECT P.PeliculaTitulo
FROM PELICULA AS P 
INNER JOIN REPARTO AS R ON R.PeliculaCodigo = P.PeliculaCodigo
INNER JOIN ACTOR AS A ON A.ActorCodigo = R.PeliculaActor
WHERE A.ActorNombre = 'Will Smith';
GO

SELECT  PeliculaTitulo
FROM PELICULA
WHERE DATEPART(yy, PeliculaFecha) = 2019 AND DATEPART(mm, PeliculaFecha) = 12-- Yo hice

--SOLUCION
    SELECT PeliculaTitulo FROM PELICULA
    WHERE PeliculaFecha BETWEEN '12-01-2019' AND '12-31-2019';
GO

SELECT DISTINCT	P.PeliculaTitulo
FROM PELICULA AS P
INNER JOIN EJEMPLAR AS E ON E.PeliculaCodigo = P.PeliculaCodigo
INNER JOIN [DETALLE ALQUILER] AS DT ON DT.EjemplarCodigo = E.EjemplarCodigo
INNER JOIN ALQUILER AS A ON A.NumeroAlquiler = DT. NumeroAlquiler
WHERE E.EjemplarEstado = 'Alquilado'
AND A.AlquilerFecha BETWEEN '03-01-2020' AND '03-31-2020'
GO

SELECT TOP(5)  P.PeliculaTitulo, COUNT(E.PeliculaCodigo) 
FROM PELICULA AS P
INNER JOIN EJEMPLAR AS E ON E.PeliculaCodigo = P.PeliculaCodigo
GROUP BY P.PliculaTitulo
ORDER BY COUNT(E.PeliculaCodigo) DESC
GO 
