--Grupo 1 TEMA: Backup y Restore.
--Para mas informacion sobre los parametros revise el readme.md en github

-- Instrucciones basicas para realizar un backup

-- Verificar el modo de backup de la base de datos

SELECT name, recovery_model_desc
FROM sys.databases
WHERE name = 'miBaseDeDatos';


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
WITH NORECOVERY; --Indica que la base de datos se dejará en un estado de recuperación no completa, esto te permite restaurar copias de seguridad adicionales. 

/*

Después de restaurar un archivo de registro de transacciones utiliza WITH NORECOVERY,
puedes continuar restaurando copias de seguridad adicionales,si es necesario.
Una vez que hayas restaurado todas las copias de seguridad necesarias, 
puedes ejecutar un comando RESTORE DATABASE al final con WITH RECOVERY para completar la restauración y poner la base de datos en línea.

*/

RESTORE LOG MiBaseDeDatos
FROM DISK = 'C:\Ruta\Para\El\Archivo\OtroArchivoLog.trn'
WITH RECOVERY; --Indica que la base de datos se dejará en un estado de recuperación completa  y permitirá que la base de datos esté disponible para su uso normal. 



