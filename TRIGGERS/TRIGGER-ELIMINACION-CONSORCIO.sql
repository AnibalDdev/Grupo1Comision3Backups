USE base_consorcio;

 -- Seguimiento de las eliminaciones en la tabla consorcio

 -- Cuando se elimina un registro de la tabla consorcio, el trigger captura informaci�n sobre la eliminaci�n y la almacena en la 
 -- tabla Auditoria_Consorcio, 

-- Creaci�n de la Tabla de Auditor�a_consorcio

BEGIN
    CREATE TABLE Auditoria_Consorcio (
        idauditoria INT IDENTITY PRIMARY KEY, --el valor de la columna se genera autom�ticamente y de forma �nica para cada fila que se inserta en la tabla.
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
END


-- Crea un desencadenador (TRIGGER) llamado trg_auditoria_consorcio en la tabla consorcio.
-- Este trigger se ejecuta en lugar de la operaci�n DELETE en la tabla consorcio.
-- Declara una variable @usuario para almacenar el nombre del usuario del sistema.
-- Comprueba si hay registros en la tabla deleted (los registros que se est�n eliminando).
-- Si existen registros, inserta informaci�n relevante en la tabla Auditoria_Consorcio para auditor�a.

CREATE TRIGGER trg_auditoria_consorcio
ON consorcio
--FOR DELETE
INSTEAD OF DELETE
AS
BEGIN
    DECLARE @usuario VARCHAR(50) --variable @usuario para almacenar el nombre del usuario del sistema.
    SELECT @usuario = SYSTEM_USER

    IF EXISTS (SELECT 1 FROM deleted) -- Comprueba si hay registros en la tabla deleted (los registros que se est�n eliminando).
	                                  -- La tabla deleted contiene las filas que est�n siendo eliminadas como resultado de la operaci�n DELETE.
    BEGIN
	-- Si existen registros, inserta informaci�n relevante en la tabla Auditoria_Consorcio
	-- Si hay registros en deleted, realiza una inserci�n en la tabla de auditor�a Auditoria_Consorcio.
    -- Las columnas seleccionadas para la inserci�n provienen de la tabla deleted (las filas que est�n siendo eliminadas).
        INSERT INTO Auditoria_Consorcio (idprovincia, idlocalidad, idconsorcio, nombre, direccion, idzona, idconserje, idadmin, fechaAccion, UsuarioAccion)
        SELECT d.idprovincia, d.idlocalidad, d.idconsorcio, d.nombre, d.direccion, d.idzona, d.idconserje, d.idadmin, GETDATE(), @usuario
        FROM deleted AS d;
    END
END


-- Realiza una consulta para mostrar el contenido actual de la tabla consorcio antes de realizar la operaci�n DELETE.
SELECT * FROM consorcio;

-- Elimina un registro espec�fico de la tabla consorcio donde se cumplen ciertas condiciones

DELETE FROM consorcio WHERE idprovincia = 1 AND idlocalidad = 1 AND idconsorcio = 1;
DELETE FROM consorcio WHERE idprovincia = 1 AND idlocalidad = 2 AND idconsorcio = 2;

-- Mostrar el contenido de las tablas consorcio y Auditoria_Consorcio despu�s de la eliminaci�n
SELECT * FROM consorcio;
SELECT * FROM Auditoria_Consorcio;


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
        -- Si NO hay registros en deleted, realiza una inserci�n en la tabla de auditor�a Auditoria_Consorcio.
        -- Las columnas seleccionadas para la inserci�n provienen de la tabla deleted (las filas que est�n siendo eliminadas).
        INSERT INTO Auditoria_Consorcio (idprovincia, idlocalidad, idconsorcio, nombre, direccion, idzona, idconserje, idadmin, fechaAccion, UsuarioAccion)
        SELECT d.idprovincia, d.idlocalidad, d.idconsorcio, d.nombre, d.direccion, d.idzona, d.idconserje, d.idadmin, GETDATE(), @usuario
        FROM deleted AS d;

        -- Elimina los registros de la tabla original correspondientes a los registros eliminados.
        DELETE FROM consorcio WHERE idconsorcio IN (SELECT idconsorcio FROM deleted);
    END
END;

*/
