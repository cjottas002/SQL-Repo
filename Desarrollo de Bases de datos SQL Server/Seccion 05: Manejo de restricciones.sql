--La integridad se realiza mediante un buen diseño
/*
	Tres niveles de integridad de datos:
		Integridad de dominio
		Integridad de entidad
		Integridad referencial
	
*/

--Integridad de dominio
CREATE TABLE Student
(
	StudentID BIGINT NOT NULL PRIMARY KEY,
	SocialSecurityNumber BIGINT,
	FirstName VARCHAR(150) NOT NULL,
	LastName VARCHAR(150),
	[Address] VARCHAR(150) DEFAULT('Ciudad'),
	BirhDate DATE
)
GO

INSERT INTO Student 
(
	StudentID,
	SocialSecutityNumber,
	FirstName,
	LastName,
	BirthDate	
)
VALUES
	(20180101, 3454355, 'Carlos', 'Hernandez', '01-01-1999', DEFAULT)
 GO

SELECT * FROM Student;
GO

--Restriccion CHECK
ALTER TABLE Student
ADD CONSTRAINT CK_BirthDate CHECK (DATEDIFF(YEAR, BirthDate, GETDATE())>=18)
GO

--Restriccion UNIQUE (No permite que una valor se repita en la columna)
ALTER RABLE Student
ADD CONSTRAINT U_SocialSecurity UNIQUE (SocialSecurityNumber)
GO

--Restriccion DEFAULT (Valor por defecto de una columna cuando el usuario no ingresa datos para dicha columna)
ALTER TABLE Student
ADD CONSTRAINT DF_Address DEFAULT ('Ciudad') FOR [Address]
GO

--Borrar datos en Estudiante
DELETE FROM Student
GO

CREATE TABLE ClassAssign
(
	ClassID BIGINT NOT NULL PRIMARY KEY,
	StudentID BIGINT,
	ClassName VARCHAR(150)
)
GO

--Restriccion DEFAULT
ALTER TABLE ClassAssign
ADD CONSTRAINT FK_Student_Class FOREIGN KEY (StudentID) REFERENCES Student (StudentID) ON UPDATE CASCADE ON DELETE NO ACTION
GO

SELECT * FROM Student
GO

INSERT INTO ClassAssign (ClassID, StudentID, ClassName)
VALUES
	(24, 20180108, 'Matematicas Avanzada')
GO



----SE PUEDEN DESHABILITAR LAS RESTRICCIONES DE FORMA TEMPORAL----

--Se hace para insertar datos de forma masiva (restriccion CHECK)
ALTER TABLE Student
NOCHECK
CONSTRAINT CK_BirthDate
GO

--Para habilitarlo nuevamente
ALTER TABLE Student
CHECK
CONSTRAINT CK_BirthDate
GO

--Borrar algun CONSTRAINT
ALTER TABLE Student
DROP CONSTRAINT CK_BirthDate;
GO

--Revisar CONSTRAINT de la tabla
SP_HELPCONSTRAINT Student;
GO

--Al momento de crear una restriccion si ya existen datos en la tabla podemos hacer que no los revise y pase la restriccion de acontinuacion por alto
ALTER TABLE Student
WITH NOCHECK
ADD CONSTRAINT CK_BirthDate CHECK (DATEDIFF(YEAR, BirthDate, GETDATE()) >= 18)
GO

--Para la restriccion de llave foranea
ALTER TABLE ClassAssign
NOCHECK CONSTRAINT FK_Student_Class

--Para el objeto IDENTITY funciona de la misma forma, se desactiva temporalmente para inserciones masivas
CREATE TABLE Class
(
	ClassID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Name] VARCHAR(100)
)
GO

INSERT INTO Class (ClassID, [Name])
VALUES
	(1, 'Matematicas Avanzadas')
GO

---Desactivar el identity
SET IDENTITY_INSERT dbo.Class ON
GO

--Activar IDENTITY
SET IDENTITY_INSERT dbo.Class OFF

