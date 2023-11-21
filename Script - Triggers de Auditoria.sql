USE base_consorcio;

--TRIGGER ALTA-BAJA-MODIFICACION EN CONSERJE

-- trg_auditoria_conserje_insertar que se activa después de una operación INSERT en la tabla conserje.
-- trg_auditoria_conserje_modificar que se activa después de una operación UPDATE en la tabla conserje.
-- trg_auditoria_conserje_borrar que se activa después de una operación DELETE en la tabla conserje.


CREATE TABLE auditoria_conserje (
    idconserje INT,
    apeynom VARCHAR(50),
    tel VARCHAR(50),
    fechnac DATE,
    estciv VARCHAR(1),
    fechaModif DATETIME,
    usuario_accion VARCHAR(100),
);


CREATE TRIGGER trg_auditoria_conserje_insertar
ON conserje
FOR INSERT
AS 
BEGIN
    DECLARE @idconserje INT, @apeynom VARCHAR(50), @tel VARCHAR(50), @fechnac DATE, @estciv VARCHAR(1),
            @fechaModif DATETIME, @usuario VARCHAR(50);

    SELECT 
	@idconserje = idconserje, 
	@apeynom = ApeyNom, 
	@tel = tel, 
	@fechnac = fechnac, 
	@estciv = estciv,
    @fechaModif = GETDATE(), 
	@usuario = SYSTEM_USER
    FROM inserted;

    INSERT INTO auditoria_conserje VALUES (@idconserje, @apeynom, @tel, @fechnac, @estciv, @fechaModif, @usuario);
END;



CREATE TRIGGER trg_auditoria_conserje_modificar
ON conserje
FOR UPDATE
AS 
BEGIN
    DECLARE @idconserje INT, @apeynom VARCHAR(50), @tel VARCHAR(50), @fechnac DATE, @estciv VARCHAR(1),
            @fechaModif DATETIME, @usuario VARCHAR(50), @accion VARCHAR(20);
			-- -- Captura la información de la fila actualizada utilizando la tabla inserted.
    SELECT @idconserje = idconserje, 
	       @apeynom = ApeyNom, 
	       @tel = tel, 
	       @fechnac = fechnac, 
	       @estciv = estciv,
           @fechaModif = GETDATE(), 
		   @usuario = SYSTEM_USER
    FROM inserted;

    INSERT INTO auditoria_conserje VALUES (@idconserje, @apeynom, @tel, @fechnac, @estciv, @fechaModif, @usuario);
END;


CREATE TRIGGER trg_auditoria_conserje_borrar
ON conserje
FOR DELETE
AS 
BEGIN
    DECLARE @idconserje INT, @apeynom VARCHAR(50), @tel VARCHAR(50), @fechnac DATE, @estciv VARCHAR(1),
            @fechaModif DATETIME, @usuario VARCHAR(50);

    SELECT @idconserje = idconserje, 
	       @apeynom = ApeyNom, 
		   @tel = tel, 
		   @fechnac = fechnac, 
		   @estciv = estciv,
           @fechaModif = GETDATE(), 
		   @usuario = SYSTEM_USER
    FROM deleted;

    INSERT INTO auditoria_conserje VALUES (@idconserje, @apeynom, @tel, @fechnac, @estciv, @fechaModif, @usuario);

END;

-------------------------------------------------PRUEBAS-----------------------------------------------------------------------------------------

INSERT INTO conserje (ApeyNom, tel, fechnac, estciv) VALUES ('Guillermo Hugo ggA.', '000000001', '19870223', 'C');
SELECT * FROM conserje;
SELECT * FROM auditoria_conserje;

UPDATE conserje SET ApeyNom = 'Guillermo Hugo' WHERE tel = '000000001';
SELECT * FROM conserje;
SELECT * FROM auditoria_conserje;

DELETE FROM conserje WHERE tel = '000000001';
SELECT * FROM conserje;
SELECT * FROM auditoria_conserje;

--------------------------------------------------------------------------------------------------------------------------------------------------
--TRIGGER ELIMINACION EN CONSORCIO

CREATE TABLE Auditoria_Consorcio (
      idauditoria INT IDENTITY PRIMARY KEY, --el valor de la columna se genera automáticamente y de forma única para cada fila que se inserta en la tabla.
      idprovincia INT,
      idlocalidad INT,
      idconsorcio INT,
      nombre VARCHAR(50),
      direccion VARCHAR(250),
      idzona INT,
      idconserje INT,
      idadmin INT,
      fechaAccion DATETIME,
      UsuarioAccion VARCHAR(50)
    );


CREATE TRIGGER trg_auditoria_consorcio
ON consorcio
--FOR DELETE
INSTEAD OF DELETE
AS
BEGIN
    DECLARE @usuario VARCHAR(50) 
    SELECT @usuario = SYSTEM_USER

    IF EXISTS (SELECT 1 FROM deleted) 	                                  
    BEGIN
        INSERT INTO Auditoria_Consorcio (idprovincia, idlocalidad, idconsorcio, nombre, direccion, idzona, idconserje, idadmin, fechaAccion, UsuarioAccion)
        SELECT d.idprovincia, d.idlocalidad, d.idconsorcio, d.nombre, d.direccion, d.idzona, d.idconserje, d.idadmin, GETDATE(), @usuario
        FROM deleted AS d;
    END
END

-------------------------------------------------PRUEBA------------------------------------------------------------------------------------------------------
-- Elimina un registro específico de la tabla consorcio donde se cumplen ciertas condiciones

DELETE FROM consorcio WHERE idprovincia = 1 AND idlocalidad = 1 AND idconsorcio = 1;
DELETE FROM consorcio WHERE idprovincia = 1 AND idlocalidad = 2 AND idconsorcio = 2;

-- Mostrar el contenido de las tablas consorcio y Auditoria_Consorcio después de la eliminación
SELECT * FROM consorcio;
SELECT * FROM Auditoria_Consorcio;

-------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
CREATE TRIGGER trg_auditoria_consorcio
ON consorcio
INSTEAD OF DELETE
AS
BEGIN
   DECLARE @usuario VARCHAR(50) -- Variable @usuario para almacenar el nombre del usuario del sistema.
   SELECT @usuario = SYSTEM_USER;

    -- Comprueba si NO hay registros en la tabla deleted
    IF NOT EXISTS (SELECT 1 FROM deleted)
    BEGIN
        -- Si NO hay registros en deleted, realiza una inserción en la tabla de auditoría Auditoria_Consorcio.
        -- Las columnas seleccionadas para la inserción provienen de la tabla deleted (las filas que están siendo eliminadas).
        INSERT INTO Auditoria_Consorcio (idprovincia, idlocalidad, idconsorcio, nombre, direccion, idzona, idconserje, idadmin, fechaAccion, UsuarioAccion)
        SELECT d.idprovincia, d.idlocalidad, d.idconsorcio, d.nombre, d.direccion, d.idzona, d.idconserje, d.idadmin, GETDATE(), @usuario
        FROM deleted AS d;

        -- Elimina los registros de la tabla original correspondientes a los registros eliminados.
        DELETE FROM consorcio WHERE idconsorcio IN (SELECT idconsorcio FROM deleted);
    END
END;

*/

--------------------------------------------------------------------------------------------------------------------------------------------------

-- Evitar la eliminación no autorizada de registros en la tabla administrador y realiza un seguimiento de las inserciones en 
-- la tabla conserje mediante el registro de auditoría en la tabla auditoria_conserje. 

CREATE TABLE Auditoria_Administrador_Eliminacion (
    idadmin INT,
    apeynom VARCHAR(50),
    fechaEliminacion DATETIME,
    usuario_accion VARCHAR(100)
);


CREATE TRIGGER trg_administrador_no_borrar
ON administrador
INSTEAD OF DELETE
AS
BEGIN
   IF (SELECT COUNT(*) FROM deleted) > 0
   BEGIN
      INSERT INTO Auditoria_Administrador_Eliminacion (idadmin, nombre, fechaEliminacion, usuario_accion)
      SELECT d.idadmin, 
	  d.apeynom, GETDATE(), 
	  SYSTEM_USER
      FROM deleted AS d;

      THROW 50000, 'No se puede eliminar ningún registro de la tabla administrador', 1;
      ROLLBACK TRANSACTION;
   END
   ELSE
   BEGIN
      COMMIT TRANSACTION;
   END
END;

----------------------------------------------------------PRUEBA----------------------------------------------------------------------------------

-- Elimina el registro con idadmin = 1 de la tabla administrador.
DELETE FROM administrador WHERE idadmin = 1;

SELECT * FROM Auditoria_Administrador_Eliminacion

--------------------------------------------------------------------------------------------------------------------------------------------------

--Creación de la Tabla Auxiliar auditoria_conserje:

/* Trigger de auditoría para la tabla conserje que registra información adicional en una tabla auxiliar, */


CREATE TABLE auditoria_conserje (
    idconserje INT,
    apeynom VARCHAR(50),
    tel VARCHAR(50),
    fechnac DATE,
    estciv VARCHAR(1),
    fechaModif DATETIME,
    usuario_accion VARCHAR(100)
);


CREATE TRIGGER trg_auditoria_conserje 
ON conserje
AFTER INSERT -- Este trigger se activa automáticamente después de una operación INSERT.
AS 
BEGIN
    DECLARE @usuario VARCHAR(50); -- Declara una variable @usuario para almacenar el nombre del usuario del sistema actual.
    SELECT @usuario = SYSTEM_USER;

    IF EXISTS (SELECT 1 FROM inserted)
    BEGIN
        INSERT INTO auditoria_conserje (idconserje, apeynom, tel, fechnac, estciv, fechaModif, usuario_accion)
        SELECT i.idconserje, i.apeynom, i.tel, i.fechnac, i.estciv, GETDATE(), @usuario
        FROM inserted AS i;
    END
END;

----------------------------------------------------PRUEBA---------------------------------------------------------------------------------------

-- Inserción de un Registro en la Tabla `conserje` y Verificación
INSERT INTO conserje (ApeyNom, tel, fechnac, estciv) VALUES ('Guillermo Hugo A.', '374445972', '19870223', 'C');

-- Muestra el contenido de la tabla auditoria_conserje para verificar que se haya registrado la auditoría.

SELECT * FROM conserje
SELECT * FROM auditoria_conserje