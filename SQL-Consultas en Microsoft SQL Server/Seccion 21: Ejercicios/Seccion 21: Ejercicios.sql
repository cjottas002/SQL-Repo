/*
	EJERCICIO 1
		1. Cree una consulta que muestre las películas del director “Alfred Hitchcock”

		2. Cree una consulta que muestre cuantos ejemplares se tienen de la película “Titanic”

		3. Muestre todos los alquileres que ha realizado el cliente “Claudia Hernández”

		4. Muestre el reparto de la película “Casa Blanca”

		5. Muestre las películas con las que cuenta en su tienda de videos del actor “Will Smith”

		6. Muestre las películas de diciembre del 2019

		7. Muestre las películas que se alquilaron en marzo del 2020

		8. Realice una consulta que devuelva las cinco películas más vistas de acuerdo al numero de ejemplares que se ha alquilado


	EJERCICIO 2
		1.    La organización necesita saber quién es su mejor cliente (El que más dinero ha generado en ventas), cree un script que devuelva esta información.  

		2.    Cree script al que se le ingrese el número de orden y la elimine, tenga en cuenta que existe una relación entre el detalle de órdenes y la orden.  

		3.     Cree un script que elimine todas las ordenes donde se compró el producto 23  

		4.    Cree un script que muestre todos los clientes que no han realizado una orden.  

		5.    En estados Unidos se ha agregado un nuevo impuesto a partir de 1998, por lo que se necesita aumentar el precio de todos los productos en las ventas a partir de ese año, por lo que debe actualizar estas ventas en un 5%  

		6.    Cree un script que devuelva la cantidad de unidades vendidas del producto 23.  

		7.    Cree un script que devuelva todos los clientes que han comprado productos de Estados Unidos, teniendo en cuenta que la procedencia del producto es en base al proveedor.  

		8.    Cree un script al que se le ingrese el código del producto a través de asignar el valor a una variable y devuelva los clientes que han solicitado este producto.  

		9.   Escriba un script que permita obtener el total de ventas de los clientes de México.  

		10. Cree una consulta que muestre la unión de las tablas “Customers” y “Suppliers” (unión horizontal) uso solo los campos “Companyname” y “Country”.  

		11. Muestre los 10 productos mas caros de la tabla “Products”.  

		12. Escriba una consulta usando la tabla “Employees” que devuelva nombre y apellido del empleado junto con el nombre y apellido del jefe.  


*/

--EJERCICIO 1
--1. Cree una consulta que muestre las películas del director “Alfred Hitchcock”
	SELECT	P.PeliculaTitulo,
			P.PeliculaNacional,
			P.PeliculaProductora,
			P.PelicullFecha,
			D.DirectorNombre AS DirectorPelicula 
	FROM PELICULA AS P
	INNER JOIN DIRECTOR AS D ON D.DirectorCodigo = P.PeliculaDirector
	WHERE D.DirectorNombre = 'Alfred Hitchcock'

--2. Cree una consulta que muestre cuantos ejemplares se tienen de la película “Titanic”
	SELECT COUNT(E.PeliculaCodigo) 
	FROM EJEMPLAR AS E 
	INNER JOIN PELICULA AS P ON P.PeliculaCodigo = E.PeliculaCodigo
	WHERE P.NombrePelicula = 'Titanic';
	GO

--3. Muestre todos los alquileres que ha realizado el cliente “Claudia Hernández”
	SELECT A.Total
	FROM CLIENTE AS C
	INNER JOIN ALQUILER AS A ON A.ClienteCodigo = C.ClienteCodigo
	WHERE C.ClienteNombre = 'Claudia Hernandez';
	GO

--4. Muestre el reparto de la película “Casa Blanca”
	SELECT A.ActorNombre
	FROM ACTOR AS A
	INNER JOIN REPARTO AS R ON R.PeliculaActor = A.ActorCodigo
	INNER JOIN PELICULA AS P ON P.PeliculaCodigo = R.PeliculaCodigo
	WHERE P.PeliculaTitulo = 'Casa Blanca';
	GO

--5. Muestre las películas con las que cuenta en su tienda de videos del actor “Will Smith”
	SELECT P.PeliculaTitulo
	FROM PELICULA AS P 
	INNER JOIN REPARTO AS R ON R.PeliculaCodigo = P.PeliculaCodigo
	INNER JOIN ACTOR AS A ON A.ActorCodigo = R.PeliculaActor
	WHERE A.ActorNombre = 'Will Smith';
	GO
--6. Muestre las películas de diciembre del 2019
	SELECT  PeliculaTitulo
	FROM PELICULA
	WHERE DATEPART(yy, PeliculaFecha) = 2019 AND DATEPART(mm, PeliculaFecha) = 12-- Yo hice

	--SOLUCION
		SELECT PeliculaTitulo FROM PELICULA
		WHERE PeliculaFecha BETWEEN '12-01-2019' AND '12-31-2019';
	GO

--7. Muestre las películas que se alquilaron en marzo del 2020
	SELECT DISTINCT	P.PeliculaTitulo
	FROM PELICULA AS P
	INNER JOIN EJEMPLAR AS E ON E.PeliculaCodigo = P.PeliculaCodigo
	INNER JOIN [DETALLE ALQUILER] AS DT ON DT.EjemplarCodigo = E.EjemplarCodigo
	INNER JOIN ALQUILER AS A ON A.NumeroAlquiler = DT. NumeroAlquiler
	WHERE E.EjemplarEstado = 'Alquilado'
	AND A.AlquilerFecha BETWEEN '03-01-2020' AND '03-31-2020'
	GO

--8. Realice una consulta que devuelva las cinco películas más vistas de acuerdo al numero de ejemplares que se ha alquilado
	SELECT TOP(5)  P.PeliculaTitulo, COUNT(E.PeliculaCodigo) 
	FROM PELICULA AS P
	INNER JOIN EJEMPLAR AS E ON E.PeliculaCodigo = P.PeliculaCodigo
	GROUP BY P.PliculaTitulo
	ORDER BY COUNT(E.PeliculaCodigo) DESC
	GO 

--EJERCICIOS 2
--1.    La organización necesita saber quién es su mejor cliente (El que más dinero ha generado en ventas), cree un script que devuelva esta información.  
