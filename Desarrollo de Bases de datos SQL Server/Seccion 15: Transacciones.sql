/*
	Una transaccion es una unidad unica de trabajo.
	Si una trancaccion tiene exito, todas las modificaciones de lso datos realizadas durante la transaccion se confirman
	y se convierten en una parte permanente de la base de datos. Si una transaccion encuentra errores y debe cancelarse 
	o revertirse, se borran todas las modificaciones de los datos.

	Tipos de transacciones:
				- Automaticas: Cualquier instruccion que se ejecute de forma individual (ej: un INSERT, DELETE)
				- Implicitas
				- Explicitas
*/
USE Northwind;
GO
/*Transacciones automaticas 1) La app envia una modificacion de datos
2) Las paginas de datos se cargan o leen en el cache del bufer y se modifican
3) Las modificaciones se graban en el registro de transacciones en el disco
4) El proceso Punto de comprobacion escribe las trancacciones en la base de datos
*/
--Insertar un dato en la tabla Customers
INSERT INTO Customers
(
	CustomerID,
	CompanyName,
	ComtactName,
	ContactTitle,
	Country
)
VALUES
(
	'VHCV1',
	'VHCARDENAS',
	'JOSE',
	'ING',
	'REP DOM'
)
GO

--Actualizar un dato
UPDATE Customers SET CompanyName = 'VISOAL'
WHERE CustomerID = 'VHCV1'
GO

--Ver los bloqueos existentes
EXECUTE SP_LOCK
GO

--Consultar el dato insertado
SELECT * FROM Customers WHERE CustomerID = 'VHCD1';

--Transacciones explicitas--
BEGIN TRANSACTION
	INSERT INTO ...
	UPDATE ...
	DELETE FROM Customers WHERE CustomerID = 'VHCD1'
--Se confirma la transaccion
COMMIT TRANSACTION
--Se desechan con ROLLBACK
ROLLBACK TRANSACTION

--Transacciones Implicitas (No necesitan del BEGIN TRANSACTION)
SET IMPLICIT_TRANSACTIONS ON
GO

--Insertar un dato a la tabla customers
INSERT INTO Customers
(
	CustomerID,
	CompanyName,
	ComtactName,
	ContactTitle,
	Country
)
VALUES
(
	'VHCV1',
	'VHCARDENAS',
	'JOSE',
	'ING',
	'REP DOM'
)
GO

COMMIT TRAN

ROLLBACK TRAN




-------------------------------------------------------------Niveles de Aislamiento--------------------------------------------
/*
	ACID: ATOMICIDAD, CONSISTENCIA, AISLAMIENTO Y DURABILIDAD.
	X = BLOQUEOS EXCLUSIVOS: TRANSACCION TIENE TOMADA LA TABLA, TRANSACCION COLGADA HASTA QUE NO SE LIBERAN LOS REGISTROS



*/
--NO SE PUEDEN LEER TRANSACCIONES NO CONFIRMADA
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

--SE PUEDEN LEER TRANSACCIONES NO CONFIRMADAS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--REPEATABLE READ, EVITA QUE ENTRE DOS LECTURAS DE UN MISMO REGISTRO EN UNA TRAN PUEDA MODIFICARSE DICHO REGISTRO

--SERIALIZABLE, LECTURAS EN SERIES. GARANTIZA QUE UNA TRAN RECUPERARA EXACTAMENTE LOS MISMOS DATOS CADA VEZ QUE SE REPITA UNA OPERACION DE LECTURA.

--SNAPSHOT. EVITA LOS PROBLEMAS DE LAS LECTURAS SUCIAS, DE LAS NO REPETIBLES, Y DE LAS LECTURAS FANTASMAS. EN VEZ DE USAR BLOQUEOS ALMACENA TABLAS VERSIONADAS EN TEMPDB

--READ COMMITERD SNAPSHOT. SE TRATA DE UNA MEZCLA ENTRE LOS MODOS DE AISLAMIENTO READ COMMITED Y SNAPSHOT.
