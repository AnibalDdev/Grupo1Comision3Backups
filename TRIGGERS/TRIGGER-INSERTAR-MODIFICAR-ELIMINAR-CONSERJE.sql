USE base_consorcio;

-- Define tres triggers:

-- trg_auditoria_conserje_insertar que se activa después de una operación INSERT en la tabla conserje.
-- trg_auditoria_conserje_modificar que se activa después de una operación UPDATE en la tabla conserje.
-- trg_auditoria_conserje_borrar que se activa después de una operación DELETE en la tabla conserje.

-- Crear la tabla de auditoría_conserje para registrar 
-- información de auditoría relacionada con la tabla conserje. 

CREATE TABLE auditoria_conserje (
    idconserje INT,
    apeynom VARCHAR(50),
    tel VARCHAR(50),
    fechnac DATE,
    estciv VARCHAR(1),
    fechaModif DATETIME,
    usuario_accion VARCHAR(100),
);


-- Se crea un trigger que se activa automáticamente después de una operación INSERT en la tabla conserje.
CREATE TRIGGER trg_auditoria_conserje_insertar
ON conserje
FOR INSERT
AS 
BEGIN
    DECLARE @idconserje INT, @apeynom VARCHAR(50), @tel VARCHAR(50), @fechnac DATE, @estciv VARCHAR(1),
            @fechaModif DATETIME, @usuario VARCHAR(50);

			-- Captura la información de la fila insertada utilizando la tabla inserted.
    SELECT 
	@idconserje = idconserje, 
	@apeynom = ApeyNom, 
	@tel = tel, 
	@fechnac = fechnac, 
	@estciv = estciv,
    @fechaModif = GETDATE(), 
	@usuario = SYSTEM_USER
    FROM inserted;

-- Inserta esta información en la tabla auditoria_conserje junto con la fecha actual (fechaModif), 
-- el usuario del sistema actual (usuario_accion), y la acción realizada (accion).

    INSERT INTO auditoria_conserje VALUES (@idconserje, @apeynom, @tel, @fechnac, @estciv, @fechaModif, @usuario);
END;



-- Trigger para UPDATE en la Tabla conserje (trg_auditoria_conserje_modificar):
-- Se crea un trigger que se activa automáticamente después de una operación UPDATE en la tabla conserje.

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

	-- Inserta esta información en la tabla auditoria_conserje junto con la fecha actual (fechaModif), 
    -- el usuario del sistema actual (usuario_accion), y la acción realizada (accion).

    INSERT INTO auditoria_conserje VALUES (@idconserje, @apeynom, @tel, @fechnac, @estciv, @fechaModif, @usuario);
END;


-- Trigger para DELETE en la Tabla conserje (trg_auditoria_conserje_borrar):
-- Se crea un trigger que se activa automáticamente después de una operación DELETE en la tabla conserje.

CREATE TRIGGER trg_auditoria_conserje_borrar
ON conserje
FOR DELETE
AS 
BEGIN
    DECLARE @idconserje INT, @apeynom VARCHAR(50), @tel VARCHAR(50), @fechnac DATE, @estciv VARCHAR(1),
            @fechaModif DATETIME, @usuario VARCHAR(50);

    -- -- Captura la información de la fila eliminada utilizando la tabla deleted.
    SELECT @idconserje = idconserje, 
	       @apeynom = ApeyNom, 
		   @tel = tel, 
		   @fechnac = fechnac, 
		   @estciv = estciv,
           @fechaModif = GETDATE(), 
		   @usuario = SYSTEM_USER

    FROM deleted;

	-- Inserta esta información en la tabla auditoria_conserje junto con la fecha actual (fechaModif), 
	-- el usuario del sistema actual (usuario_accion), y la acción realizada (accion).
    INSERT INTO auditoria_conserje VALUES (@idconserje, @apeynom, @tel, @fechnac, @estciv, @fechaModif, @usuario);

END;


-- Insertar un registro en la tabla conserje
INSERT INTO conserje (ApeyNom, tel, fechnac, estciv) VALUES ('Guillermo Hugo ggA.', '000000001', '19870223', 'C');

-- Verificar el contenido de la tabla auditoria_conserje después de la inserción
SELECT * FROM auditoria_conserje;
SELECT * FROM conserje;

-- Modificar un registro en la tabla conserje
UPDATE conserje SET ApeyNom = 'Guillermo Hugo' WHERE tel = '000000001';

-- Verificar el contenido de la tabla auditoria_conserje después de la modificación
SELECT * FROM auditoria_conserje;

-- La acción DELETE se realiza en la tabla conserje 
-- antes de que se inserte la auditoría en la tabla auditoria_conserje. 
-- Esta acción debería ocurrir después de la inserción en la tabla de auditoría para garantizar la integridad de la auditoría.
DELETE FROM conserje WHERE tel = '000000001';
SELECT * FROM conserje;

-- Verificar el contenido de la tabla auditoria_conserje después de la eliminación
SELECT * FROM auditoria_conserje;





