USE base_consorcio;

-- Evitar la eliminaci�n no autorizada de registros en la tabla administrador y realiza un seguimiento de las inserciones en 
-- la tabla conserje mediante el registro de auditor�a en la tabla auditoria_conserje. 
-- Estas acciones est�n dise�adas para garantizar la integridad de los datos y 
-- registrar informaci�n relevante para el seguimiento de cambios.

-- Crear la tabla de auditor�a para registrar la eliminaci�n de registros de la tabla administrador.
CREATE TABLE Auditoria_Administrador_Eliminacion (
    idadmin INT,
    apeynom VARCHAR(50),
    fechaEliminacion DATETIME,
    usuario_accion VARCHAR(100)
);

-- Trigger para no permitir la eliminaci�n de registros en la tabla administrador:
-- Trigger (trg_administrador_no_borrar) en la tabla administrador. En lugar de operacion Delete

-- Crear un trigger INSTEAD OF DELETE en la tabla administrador

-- El objetivo principal del trigger es controlar y personalizar el comportamiento de 
-- las operaciones de eliminaci�n en la tabla.

CREATE TRIGGER trg_administrador_no_borrar
ON administrador
INSTEAD OF DELETE
AS
BEGIN

   -- El trigger verifica si hay registros en la tabla deleted, que contiene los registros que est�n siendo eliminados
   IF (SELECT COUNT(*) FROM deleted) > 0
   BEGIN
      -- Si hay registros en deleted, el trigger realiza una inserci�n en la tabla 
      -- Inserta informaci�n relevante en la tabla de auditor�a Auditoria_Administrador_Eliminacion.
      INSERT INTO Auditoria_Administrador_Eliminacion (idadmin, nombre, fechaEliminacion, usuario_accion)
      SELECT d.idadmin, 
	  d.apeynom, GETDATE(), 
	  SYSTEM_USER
      FROM deleted AS d;

	  -- Despu�s de la inserci�n en la tabla de auditor�a, el trigger lanza un error (THROW) con el mensaje 
	  -- 'No se puede eliminar ning�n registro de la tabla administrador' y realiza un rollback de la transacci�n. 
	  -- Esto significa que la operaci�n de eliminaci�n en la tabla administrador se revierte y no se completar�.

      THROW 50000, 'No se puede eliminar ning�n registro de la tabla administrador', 1;
      ROLLBACK TRANSACTION;
   END
   ELSE
   BEGIN
      -- Si no hay registros en deleted, se realiza un commit de la transacci�n. 
	  -- Esto confirma la eliminaci�n de registros en la tabla administrador.
      COMMIT TRANSACTION;
   END
END;


-- Elimina el registro con idadmin = 1 de la tabla administrador.
DELETE FROM administrador WHERE idadmin = 1;

SELECT * FROM Auditoria_Administrador_Eliminacion


--Creaci�n de la Tabla Auxiliar auditoria_conserje:

/* Trigger de auditor�a para la tabla conserje que registra informaci�n adicional en una tabla auxiliar, */

-- y realiza una prueba de inserci�n para verificar la funcionalidad del trigger de auditor�a.

CREATE TABLE auditoria_conserje (
    idconserje INT,
    apeynom VARCHAR(50),
    tel VARCHAR(50),
    fechnac DATE,
    estciv VARCHAR(1),
    fechaModif DATETIME,
    usuario_accion VARCHAR(100)
);

-- Trigger de Auditor�a para la Tabla conserje:

CREATE TRIGGER trg_auditoria_conserje 
ON conserje
AFTER INSERT -- Este trigger se activa autom�ticamente despu�s de una operaci�n INSERT.
AS 
BEGIN
    DECLARE @usuario VARCHAR(50); -- Declara una variable @usuario para almacenar el nombre del usuario del sistema actual.
    SELECT @usuario = SYSTEM_USER;

   -- Si hay registros en la tabla inserted (registros que se est�n insertando), inserta informaci�n adicional en 
   -- la tabla auditoria_conserje. 
   -- Esta informaci�n adicional incluye fechaModif (fecha actual) y usuario_accion (usuario del sistema que realiz� la operaci�n).

    IF EXISTS (SELECT 1 FROM inserted)
    BEGIN
        INSERT INTO auditoria_conserje (idconserje, apeynom, tel, fechnac, estciv, fechaModif, usuario_accion)
        SELECT i.idconserje, i.apeynom, i.tel, i.fechnac, i.estciv, GETDATE(), @usuario
        FROM inserted AS i;
    END
END;



-- Inserci�n de un Registro en la Tabla `conserje` y Verificaci�n
INSERT INTO conserje (ApeyNom, tel, fechnac, estciv) VALUES ('Guillermo Hugo A.', '374445972', '19870223', 'C');

-- Muestra el contenido de la tabla auditoria_conserje para verificar que se haya registrado la auditor�a.

SELECT * FROM conserje
SELECT * FROM auditoria_conserje

