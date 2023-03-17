USE Northwind
GO

EXEC SP_ADDMESSAGE 50001, 16, 'Atencion! La division dentro de 0 no esta definida';
GO
RAISERROR(50001, 16, 1)
GO
THROW 50001, 'Ha ocurrido un error', 16
GO

SELECT 80/0
SELECT @@ERROR
GO

---INSTRUCCION TRY..CATCH

BEGIN TRY
	SELECT 80/0
END TRY
BEGIN CATCH
	SELECT ERROR_NUMBER() AS NumeroError,
		ERROR_SEVERITY() AS NumeroSeveridad,
		ERROR_STATE() AS NumeroEstado,
		ERROR_PROCEDURE() AS ProcedimientoDelError,
		ERROR_MESSAGE() AS MensajeError
END CATCH