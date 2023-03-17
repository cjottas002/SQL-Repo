/*
	Factores que afectan el rendimiento de las consultas SQL
		- Escribir consultas con buen desempeño
		- La indexación en SQL Server
		- Fundamentos de índices de servidor SQL: índices agrupados
		- Fundamentos de índices de servidor SQL: índices no agrupados
		- Los índices de SQL Server: Concideraciones sobre el rendimiento
		- Estadísticas de distribución
		- Definición de cursores
		- Evitar cursores
		- Demostración: Los factores de rendimiento de la consulta

		- En el uso del predicado (despues de la clausula WHERE) evitar el uso de formulari
		- Evitar el uso de las tablas temporales frente a utilizar funciones de ventana, variables de tablas, consultas que guardamos a traves de vistas o de una funcion
		- Un indice CLUSTERED se ordena fisicamente en el disco
		- UN NONCLUSTERED INDEX crea una estructura adicional llamada nivel de hoja (parecido a los indices de los libros)
		
*/

--Compila un plan de ejecucion para las consultas(Ctrl+L o Ctrl+M)
SELECT	CustomerID,
	CompanyName,
	ContactName
FROM Customers
WHERE CustomerID = 'ALFKI'
GO

--El plan de ejecucion de la siguiente consulta realiza un table scan (e.i. va fila por fila localizando los datos), este es el peor escenario. Se debe buscar una solucion aplicando WHERE o alguna otra accion de optimizacion.
SELECT	CustomerID,
	CompanyName,
	ContactName
INTO Clientes
FROM Customers
GO

--Alguna de las soluciones propuestas puede ser la siguiente
CREATE CLUSTERED INDEX CI_Cliente ON Clientes(CustomerID)
GO

--mas eficiente es un CLUSTERED INDEX(tambien va buscando dato por dato, pero dentro de un conjunto de datos mas pequeños, e.i. el indice)
--Pero lo mas eficiente de todo es un CLUSTERED INDEX SEEK: Esto si es eficiente, este tipo de accion es como buscar en el diccionario que sabemos que esta ordenado alfabeticamente y el dato se busca directamente,
--por la letra que empieza la palabra y no hace un recurrido buscando dato por dato
--Otro icono que puede aparecer en el Plan de ejecucion es el STREAM AGGREGATE: Aparece cuando agrupamos los datos y mezclamos con funciones de agregado como MIN, SUM, AVG y tambien con la clausula HAVING
SELECT Country, COUNT(CustomerID)
FROM Customers
GROUP BY Country
GO

--SORT: Cuando el motor de bbdd necesita ordenar por un campo que no esta preordenado por un indice necesita hacer la operacion de ordenacion dque por lo general baja el rendimiento de la consulta.
--NESTED LOOPS(INNER JOIN): Dos conjuntos de datos donde uno esta pre-ordenado y con elementos unicos y el otro no, tomando como base el conjunto ordenado y de items
--unicos elegira el primer elemento y buscara su correspondiente match con cada elemento del segundo conjunto, recorriendo todos los elementos porque el segundo no esta ordenado,
--al terminar e iniciar con el segundo elemento es imposible que exista nuevamente el primer elemento y que quede algun match con el segundo elemento porque para esto estaba previamente ordenado.
--MERGE JOIN(INNER JOIN): Este operador es el mas eficiente de los JOINS y en este caso tanto el primer conjunto como el segundo estan ordenados.
--HASH MATCH(INNER JOIN): Este es el menos eficiente de todos los JOINS ya que no se encuentran ordenado ninguno de los conjuntos, debe crear una tabla temporal y ordenarla.

--Podemos influenciar en el comportamiento de las consultas a traves del query hint
--Consulta primigenia
SELECT 	C.CustomerID,
	C.CompanyName,
	O.OrderID,
	O.OrderDate
FROM Customers AS C 
INNER JOIN Orders AS O ON C.CustomerID = O.CustomerID
GO

--Query Hint
SELECT 	C.CustomerID,
	C.CompanyName,
	O.OrderID,
	O.OrderDate
FROM Customers AS C 
INNER JOIN Orders AS O ON C.CustomerID = O.CustomerID
OPTION (MERGE JOIN, TABLE HINT (C, INDEX(PK_Customers)))
GO
--Esto hace que cambie el plan de ejecucion inicial a uno sugerido por nosotros


---Más Query Hint
USE Northwind;
GO

--Consultando los indices de las tablas
SP_HELPINDEX Customers;
GO

SP_HELPINDEX Orders;
GO

--Realizando una consulta entre la tabla Customers y Orders
SELECT 	C.CustomerID,
	C.CompanyName,
	O.OrderID,
	O.OrderDate
FROM Customers AS C WITH (INDEX(PK_Customers))
INNER [MERGE] JOIN Orders AS O WITH (INDEX(EmployeeID)) --Realmente es ineficiente, simplemente se hace asi para a efectos de demostracion
ON C.CustomerID = O.CustomerID
OPTION (MERGE JOIN, TABLE HINT (C, INDEX(region))) -- Se puede colocar aqui las opciones. Esta es la nueva sintaxis. La 'C' en el argumento de TABLE HINT hace
--referencia a la tabla Customers (C es el alias)








