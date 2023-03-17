
CREATE TABLE Clientes 
(
	CodigoCliente INT IDENTITY(1,1) NOT NULL,
	NombreCliente NVARCHAR(150) NOT NULL,
	FechaNacimiento NVARCHAR(150) NOT NULL,
	CONSTRAINT PK_Cliente_CodigoCliente PRIMARY KEY CLUSTERED (CodigoCliente)
)
GO

