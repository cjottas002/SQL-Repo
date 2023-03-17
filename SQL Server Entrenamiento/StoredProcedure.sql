CREATE PROCEDURE PROC_PRUEBA
AS
	SET NOCOUNT ON;
	SELECT * FROM alumnos;
GO

EXEC PROC_PRUEBA;

----------------------------------
sp_helptext PROC_PRUEBA;

-----------------------------------
CREATE PROC usp_select_alumno_by_id
@codigo varchar(10)
AS
	SELECT * 
	FROM alumnos 
	WHERE codigo = @codigo;
GO

EXEC usp_select_alumno_by_id '3';
-----------------------------------------
CREATE PROC usp_new_alumno
	@xcodigo varchar(3),
	@xnombres varchar(100),
	@xapellido varchar(100),
	@xfecha_nac date,
	@xedad int,
	@xcodigo_gra varchar(3)
AS
	INSERT INTO alumnos(codigo, 
						nombres,
						apellidos,
						fecha_nac,
						edad,
						codigo_gra)
				VALUES(@xcodigo,
					   @xnombres,
					   @xapellido,
					   @xfecha_nac,
					   @xedad,
					   @xcodigo_gra);
GO

EXEC usp_new_alumno '5', 'JOSE', 'ARIAS', '2000-08-01', 22, '001';

---------------------------------------------------------------------------
CREATE PROC usp_update_alumno
(
	@xcodigo varchar(3),
	@xnombres varchar(100),
	@xapellido varchar(100),
	@xfecha_nac date,
	@xedad int,
	@xcodigo_gra varchar(3)
)
AS
	UPDATE alumnos SET nombres = @xnombres, 
					   apellidos = @xapellido, 
					   fecha_nac = @xfecha_nac,
					   edad = @xedad,
					   codigo_gra = @xcodigo_gra
					WHERE codigo = @xcodigo;
GO

EXEC usp_update_alumno '1', 'VICTOR CESAR', 'RAMOS SARAVIA', '1986-07-09', 38, '001'; 

---------------------------------------------
CREATE PROC usp_delete_alumno
(
	@codigo varchar(3)
)
AS
	DELETE FROM alumnos WHERE codigo = @codigo;
GO

EXEC usp_delete_alumno '5';

---------------------------------------------------
CREATE PROC usp_prueba_if
(
	@num int
)
AS
	IF @num = 1
		SELECT 'El valor es 1';
	ELSE
		SELECT 'El valor es diferente a 1'
GO

EXEC usp_prueba_if 67;


-------------------------------------------------------
CREATE PROC usp_mantenaince_alumno
(
	@xopcion int,
	@xcodigo varchar(3),
	@xnombres varchar(100),
	@xapellido varchar(100),
	@xfecha_nac date,
	@xedad int,
	@xcodigo_gra varchar(3)
)
AS
	IF @xopcion = 1 --nuevo registro
		INSERT INTO alumnos(codigo, 
						nombres,
						apellidos,
						fecha_nac,
						edad,
						codigo_gra)
				VALUES(@xcodigo,
					   @xnombres,
					   @xapellido,
					   @xfecha_nac,
					   @xedad,
					   @xcodigo_gra);

	ELSE --actualizar registro
		UPDATE alumnos SET nombres = @xnombres, 
					apellidos = @xapellido, 
					fecha_nac = @xfecha_nac,
					edad = @xedad,
					codigo_gra = @xcodigo_gra
				WHERE codigo = @xcodigo;
GO

EXEC usp_mantenaince_alumno '1', '2', 'MIGUEL', 'LOPEZ', '1999-10-19', 23, '005';