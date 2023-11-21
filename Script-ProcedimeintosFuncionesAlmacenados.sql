USE base_consorcio;
GO

--------------------------- IMPLEMENTACION PROCEDIMIENTOS Y FUNCIONES -----------------------------------------------

/*

1. Procedimientos de Administrador 

*/

--Agregar un administrador--

CREATE PROCEDURE InsertarAdministrador
(
    @apeynom varchar(50),
    @viveahi varchar(1),
    @tel varchar(20),
    @sexo varchar(1),
    @fechnac datetime
)
AS
BEGIN
    INSERT INTO administrador (apeynom, viveahi, tel, sexo, fechnac)
    VALUES (@apeynom, @viveahi, @tel, @sexo, @fechnac);
END

--Modificar un administrador existente--
GO

CREATE PROCEDURE ModificarAdministrador
(
    @idadmin int,
    @apeynom varchar(50),
    @viveahi varchar(1),
    @tel varchar(20),
    @sexo varchar(1),
    @fechnac datetime
)
AS
BEGIN
    UPDATE administrador
    SET apeynom = @apeynom,
        viveahi = @viveahi,
        tel = @tel,
        sexo = @sexo,
        fechnac = @fechnac
    WHERE idadmin = @idadmin;
END

--Eliminar un administrador--
GO

CREATE PROCEDURE BorrarAdministrador
(
    @idadmin int
)
AS
BEGIN
    DELETE FROM administrador WHERE idadmin = @idadmin;
END
----------Lote de pruebas 1-----------------------------------------------------------

-- Insertar datos utilizando el procedimiento almacenado correspondiente:
EXEC InsertarAdministrador 'Tina Rodriguez', 'S', '40565369', 'F', '09-08-1997';

-- Modificar datos de un administrador utilizando el procedimiento almacenado correspondiente:
EXEC ModificarAdministrador 175, 'Maria Tina Rodriguez', 'N', '40565369', 'F', '09-08-1997';

-- Eliminacion de datos de un administrador utilizando el procedimiento almacenado correspondiente:
/*EXEC BorrarAdministrador 175;

select * from gasto
where idconsorcio =
	(select idconsorcio from consorcio
	where idadmin = 1)*/

SELECT * FROM administrador;
---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
/*

2. Procedimientos de Consorcio

*/

--Agregar un nuevo registro de consorcio--
GO

CREATE PROCEDURE agregarConsorcio
@Provincia INT,
@Localidad INT,
@Consorcio INT, 
@Nombre VARCHAR(50),
@Direccion VARCHAR(255),
@Zona INT,
@Conserje INT,
@Admin INT

      AS
BEGIN
		INSERT INTO consorcio(idprovincia,idlocalidad,idconsorcio,nombre,direccion, idzona,idconserje,idadmin) 
			VALUES (@Provincia,@Localidad,@Consorcio,@Nombre,@Direccion, @Zona, @Conserje, @Admin)
					
END  

--Modificar un registro existente de consorcio--
GO

CREATE PROCEDURE modificarConsorcio
@Provincia INT,
@Localidad INT,
@Consorcio INT, 
@Nombre VARCHAR(50),
@Direccion VARCHAR(255),
@Zona INT,
@Conserje INT,
@Admin INT

AS
BEGIN
	IF EXISTS (
		SELECT 1 FROM consorcio WHERE idprovincia = @Provincia AND idlocalidad = @Localidad AND idconsorcio = @Consorcio
	)
	BEGIN
		UPDATE consorcio 
		SET nombre = @Nombre,
			direccion = @Direccion,
			idzona = @Zona,
			idconserje = @Conserje,
			idadmin = @Admin
		WHERE
			idprovincia = @Provincia 
			AND idlocalidad = @Localidad 
			AND idconsorcio = @Consorcio;
	END
	ELSE
	BEGIN
		-- Si no existe la combinación de claves primarias, puedes manejarlo según tus necesidades.
		-- Puedes optar por no hacer nada, insertar un nuevo registro o lanzar un mensaje de error.
		-- En este ejemplo, no se hace nada en caso de que no exista la combinación de claves primarias.
		PRINT 'No se encontró el consorcio con las claves primarias proporcionadas.';
	END
	
END

--Eliminar un registro de consorcio--
GO

CREATE PROCEDURE eliminarConsorcio
@Provincia INT,
@Localidad INT,
@Consorcio INT

AS
BEGIN

	DELETE FROM consorcio WHERE idprovincia = @Provincia AND idLocalidad = @Localidad AND idconsorcio = @Consorcio
END

----------Lote de pruebas 2-----------------------------------------------------------

--Agregar un nuevo consorcio
EXEC agregarConsorcio @Provincia = 1, @Localidad = 3, @Consorcio = 1, @Nombre = "EDIFICIO-1000", 
@Direccion = "Av. Corrientes 1257", @Zona = 1, @Conserje = 29, @Admin = 3;

--Modificar un consorcio ya existente
EXEC modificarConsorcio @Consorcio = 4, @Provincia = 10, @Localidad = 18, @Nombre = "ERNESTO III",
@Direccion = "Av. Cordoba 2054", @Zona = 2, @Conserje = 33,  @Admin = 13;

--Eliminar un consorcio existente
EXEC eliminarConsorcio @Provincia = 10, @Localidad = 18, @Consorcio = 4;

Select * from consorcio WHERE idconsorcio = 4;
---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

/*

3. Procedimientos de Gastos.

*/

--Insertar registro de la tabla de gastos--
GO

CREATE PROCEDURE InsertarGasto(
    @idprovincia INT,
    @idlocalidad INT,
    @idconsorcio INT,
    @periodo INT,
    @fechapago DATETIME,
    @idtipogasto INT,
    @importe DECIMAL(8, 2)
)
AS
BEGIN
    INSERT INTO gasto (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
    VALUES (@idprovincia, @idlocalidad, @idconsorcio, @periodo, @fechapago, @idtipogasto, @importe);
END;

--Modificar registro de la tabla de gastos--
GO

CREATE PROCEDURE ModificarGasto
(
    @idgasto INT,
    @idprovincia INT,
    @idlocalidad INT,
    @idconsorcio INT,
    @periodo INT,
    @fechapago DATETIME,
    @idtipogasto INT,
    @importe DECIMAL(8, 2)
)
AS
BEGIN
	IF EXISTS (
		SELECT 1 FROM consorcio WHERE idprovincia = @idprovincia AND idlocalidad = @idlocalidad AND idconsorcio = @idconsorcio
    )
	BEGIN
		UPDATE gasto
		SET
			periodo = @periodo,
			fechapago = @fechapago,
			idtipogasto = @idtipogasto,
			importe = @importe			
		WHERE
			idgasto = @idgasto
	END		
END;

--Eliminar registro en la tabla de gastos--
GO

CREATE PROCEDURE BorrarGasto
(
    @idgasto INT
)
AS
BEGIN
    DELETE FROM gasto
    WHERE idgasto = @idgasto;
END;

----------Lote de pruebas3-----------------------------------------------------------

--Insertar registro en la tabla Gasto
EXEC InsertarGasto @idprovincia = 1, @idlocalidad = 3, @idconsorcio = 1, 
@periodo = 12, @fechapago = '20231205', @idtipogasto = 3, @importe = 45256.10;

--Modificar un registro existente de la tabla Gasto
EXEC ModificarGasto @idgasto = 8003, @idprovincia = 1, @idlocalidad = 3, @idconsorcio = 1, 
@periodo = 1, @fechapago = '20240105', @idtipogasto = 5, @importe = 20256.10

--Eliminar un registro de ta la tabla Gasto
EXEC BorrarGasto @idgasto = 8003;

SELECT * FROM gasto;
---------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------- 
