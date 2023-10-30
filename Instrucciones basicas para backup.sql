--Grupo 1 TEMA: Backup y Restore.
--Para mas informacion sobre los parametros revise el readme.md en github

-- Instrucciones basicas para realizar un backup

-- Verificar el modo de backup de la base de datos

SELECT name, recovery_model_desc
FROM sys.databases
WHERE name = 'master';


--Cambiar modo de almacenamieto

USE master; -- Asegúrate de estar en el contexto de la base de datos master
ALTER DATABASE miBaseDeDatos
SET RECOVERY Modo-de-recuperacion

-- Posibles modos de backup: "SIMPLE", "BULK_LOGGED", "FULL"


-- Para realizar una copia de seguridad completa de la base de datos "MiBaseDeDatos"
BACKUP DATABASE MiBaseDeDatos
TO DISK = 'C:\Ruta\Para\El\Archivo\De\Backup.bak'
WITH FORMAT, INIT; 

-- Realizar una copia de seguridad de los registros de transacciones

BACKUP LOG MiBaseDeDatos
TO DISK = 'C:\Ruta\Para\El\Archivo\LogBackup.trn';


-- Para restaurar una base de datos desde un archivo de respaldo

RESTORE DATABASE MiBaseDeDatos
FROM DISK = 'C:\Ruta\Para\El\Archivo\De\Backup.bak'
WITH REPLACE, RECOVERY;

-- Restaurar un archivo de registro de transacciones
RESTORE LOG MiBaseDeDatos
FROM DISK = 'C:\Ruta\Para\El\Archivo\LogBackup.trn'
WITH RECOVERY;

