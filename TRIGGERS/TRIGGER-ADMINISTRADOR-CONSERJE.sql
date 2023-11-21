USE base_consorcio;

-- Evitar la eliminación no autorizada de registros en la tabla administrador y realiza un seguimiento de las inserciones en 
-- la tabla conserje mediante el registro de auditoría en la tabla auditoria_conserje. 
-- Estas acciones están diseñadas para garantizar la integridad de los datos y 
-- registrar información relevante para el seguimiento de cambios.

-- Crear la tabla de auditoría para registrar la eliminación de registros de la tabla administrador.
CREATE TABLE Auditoria_Administrador_Eliminacion (
    idadmin INT,
    apeynom VARCHAR(50),
    fechaEliminacion DATETIME,
    usuario_accion VARCHAR(100)
);

-- Trigger para no permitir la eliminación de registros en la tabla administrador:
-- Trigger (trg_administrador_no_borrar) en la tabla administrador. En lugar de operacion Delete

-- Crear un trigger INSTEAD OF DELETE en la tabla administrador

-- El objetivo principal del trigger es controlar y personalizar el comportamiento de 
-- las operaciones de eliminación en la tabla.

CREATE TRIGGER trg_administrador_no_borrar
ON administrador
INSTEAD OF DELETE
AS
BEGIN

   -- El trigger verifica si hay registros en la tabla deleted, que contiene los registros que están siendo eliminados
   IF (SELECT COUNT(*) FROM deleted) > 0
   BEGIN
      -- Si hay registros en deleted, el trigger realiza una inserción en la tabla 
      -- Inserta información relevante en la tabla de auditoría Auditoria_Administrador_Eliminacion.
      INSERT INTO Auditoria_Administrador_Eliminacion (idadmin, nombre, fechaEliminacion, usuario_accion)
      SELECT d.idadmin, 
	  d.apeynom, GETDATE(), 
	  SYSTEM_USER
      FROM deleted AS d;

	  -- Después de la inserción en la tabla de auditoría, el trigger lanza un error (THROW) con el mensaje 
	  -- 'No se puede eliminar ningún registro de la tabla administrador' y realiza un rollback de la transacción. 
	  -- Esto significa que la operación de eliminación en la tabla administrador se revierte y no se completará.

      THROW 50000, 'No se puede eliminar ningún registro de la tabla administrador', 1;
      ROLLBACK TRANSACTION;
   END
   ELSE
   BEGIN
      -- Si no hay registros en deleted, se realiza un commit de la transacción. 
	  -- Esto confirma la eliminación de registros en la tabla administrador.
      COMMIT TRANSACTION;
   END
END;


-- Elimina el registro con idadmin = 1 de la tabla administrador.
DELETE FROM administrador WHERE idadmin = 1;

SELECT * FROM Auditoria_Administrador_Eliminacion


--Creación de la Tabla Auxiliar auditoria_conserje:

/* Trigger de auditoría para la tabla conserje que registra información adicional en una tabla auxiliar, */

-- y realiza una prueba de inserción para verificar la funcionalidad del trigger de auditoría.

CREATE TABLE auditoria_conserje (
    idconserje INT,
    apeynom VARCHAR(50),
    tel VARCHAR(50),
    fechnac DATE,
    estciv VARCHAR(1),
    fechaModif DATETIME,
    usuario_accion VARCHAR(100)
);

-- Trigger de Auditoría para la Tabla conserje:

CREATE TRIGGER trg_auditoria_conserje 
ON conserje
AFTER INSERT -- Este trigger se activa automáticamente después de una operación INSERT.
AS 
BEGIN
    DECLARE @usuario VARCHAR(50); -- Declara una variable @usuario para almacenar el nombre del usuario del sistema actual.
    SELECT @usuario = SYSTEM_USER;

   -- Si hay registros en la tabla inserted (registros que se están insertando), inserta información adicional en 
   -- la tabla auditoria_conserje. 
   -- Esta información adicional incluye fechaModif (fecha actual) y usuario_accion (usuario del sistema que realizó la operación).

    IF EXISTS (SELECT 1 FROM inserted)
    BEGIN
        INSERT INTO auditoria_conserje (idconserje, apeynom, tel, fechnac, estciv, fechaModif, usuario_accion)
        SELECT i.idconserje, i.apeynom, i.tel, i.fechnac, i.estciv, GETDATE(), @usuario
        FROM inserted AS i;
    END
END;



-- Inserción de un Registro en la Tabla `conserje` y Verificación
INSERT INTO conserje (ApeyNom, tel, fechnac, estciv) VALUES ('Guillermo Hugo A.', '374445972', '19870223', 'C');

-- Muestra el contenido de la tabla auditoria_conserje para verificar que se haya registrado la auditoría.

SELECT * FROM conserje
SELECT * FROM auditoria_conserje

