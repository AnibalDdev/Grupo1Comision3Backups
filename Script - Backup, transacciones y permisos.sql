

-- 1 Verificar el modo de recuperacion de la base de datos
use base_consorcio

SELECT name, recovery_model_desc
FROM sys.databases
WHERE name = 'base_consorcio';


-- 2 cambiamos el modo de recuperacion

USE master; -- Asegúrate de estar en el contexto de la base de datos master
ALTER DATABASE base_consorcio
SET RECOVERY FULL;

-- 3 Realizamos backup de la base de datos

BACKUP DATABASE base_consorcio
TO DISK = 'C:\backup\consorcio_backup.bak'
WITH FORMAT, INIT;



-- Agregamos 10 registros Utilizando transacciones

select * from gasto;


BEGIN TRY -- Iniciamos con un try para el manejo de errores si existen
    BEGIN TRAN -- Inicio de la transaccion
    
		insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
		values (1,1,1,5,GETDATE(),5,1200);

		insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
		values (1,2,2,5,GETDATE(),2,1630);

		insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
		values (3,20,2,2,GETDATE(),4,500);

		insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
		values (5,3,1,3,GETDATE(),3,1520);

		insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
		values (5,12,3,4,GETDATE(),5,1120);

		insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
		values (6,45,2,4,GETDATE(),4,2000);

		insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
		values (14,36,2,2,GETDATE(),1,1740);

		insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
		values (18,3,1,2,GETDATE(),2,1520);

		insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
		values (2,48,1,5,GETDATE(),2,1500);

		insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
		values (13,10,2,1,GETDATE(),1,1420);
    
  
    COMMIT TRAN -- Si todo fue bien se insertan los datos
END TRY
BEGIN CATCH -- Si hay algun error entra al catch
    SELECT ERROR_MESSAGE() -- Se muestra el mesaje de error
    ROLLBACK TRAN -- Volvemos atras para mantener consistencia en los datos
END CATCH




-- 4 Realizamos backup del log de la base de datos

BACKUP LOG base_consorcio
TO DISK = 'C:\backup\LogBackup.trn'
WITH FORMAT, INIT;


-- Insertamos 10 registros mas


BEGIN TRY -- Iniciamos con un try para el manejo de errores si existen
    BEGIN TRAN -- Inicio de la transaccion
    
		insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
		values (1,1,1,5,GETDATE(),5,1200);

		insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
		values (2,48,1,5,GETDATE(),2,1500);

		insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
		values (3,16,1,2,GETDATE(),4,2300);

		insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
		values (4,21,1,3,GETDATE(),3,1000);

		insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
		values (5,3,1,2,GETDATE(),5,1500);

		insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
		values (6,45,2,4,GETDATE(),4,2000);

		insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
		values (8,17,2,2,GETDATE(),1,1300);

		insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
		values (9,14,1,3,GETDATE(),2,1700);

		insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
		values (12,7,4,2,GETDATE(),3,2100);

		insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
		values (13,10,2,1,GETDATE(),1,1100);

    COMMIT TRAN -- Si todo fue bien se insertan los datos
END TRY
BEGIN CATCH -- Si hay algun error entra al catch
    SELECT ERROR_MESSAGE() -- Se muestra el mesaje de error
    ROLLBACK TRAN -- Volvemos atras para mantener consistencia en los datos
END CATCH










select	[Begin Time],
		--[CURRENT LSN],
		[Operation],
		[Transaction Name],
		[Transaction ID],
		[Transaction SID],
		[SPID]
		FROM fn_dblog(null,null)
		--order by [Begin Time] desc
		
		EXEC xp_readerrorlog;
		
		SELECT * FROM fn_dblog(NULL, NULL);
		





BEGIN TRY -- Iniciamos con un try para el manejo de errores si existen
	BEGIN TRAN 
	INSERT INTO administrador(apeynom, viveahi, tel, sexo, fechnac) 
	VALUES ('Ramon Lopez', 'N', '3794312353', 'M', '02/08/1999');

	INSERT INTO consorcio(idprovincia, idlocalidad, idconsorcio, nombre, direccion, idzona, idconserje, idadmin)
	VALUES (1, 1, 4, 'EDIFICIO-114', 'PARAGUAY N 114', 5, 100, 1);

	-------------------------
	-- COMENZAMOS UNA TRANSACCION ANIDADA
	BEGIN TRAN 
		UPDATE consorcio SET nombre = 'EDIFICIO-222' where idprovincia = 1 and idlocalidad = 1 and idconsorcio = 4; -- ACTUALIZAMOS EL REGISTRO DE CONSORCIO QUE CARGAMOS ANTES
		INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe) 
			VALUES (1,1,4,6,'20130616',5,608.97) ;
	COMMIT TRAN 
	-- FINALIZAMOS UNA TRANSACCION ANIDADA
	------------------------

	INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
	VALUES (1,1,4,6,'20150612',5,423.12);
	INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
	VALUES (1,1,4,6,'20160411',2,608.24);
	INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
	VALUES (1,1,4,6,'20170223',3,410.27);

	COMMIT TRAN -- SI TODO FUE EXITOSO FINALIZAMOS LA TRANSACCION
END TRY
BEGIN CATCH -- Si hay algun error entra al catch
	SELECT ERROR_MESSAGE() -- Se muestra el mensaje de error
	ROLLBACK TRAN -- Volvemos atras para mantener consistencia en los datos
END CATCH




--5 Realizamos backup del log en otra ubicacion

BACKUP LOG base_consorcio
TO DISK = 'C:\backup\logs\LogBackup2.trn'
WITH FORMAT, INIT;

--6 Restauramos el backup de la base de datos

use master

alter database base_consorcio set offline with rollback immediate

alter database base_consorcio set online

RESTORE DATABASE base_consorcio
FROM DISK = 'C:\backup\consorcio_backup.bak'
WITH REPLACE, NORECOVERY;

RESTORE LOG base_consorcio
FROM DISK = 'C:\backup\LogBackup.trn'
WITH RECOVERY;


-- Segundo log

RESTORE LOG base_consorcio
FROM DISK = 'C:\backup\logs\LogBackup2.trn'
WITH RECOVERY;

select * from gasto;



----- Implementacion de Manejo de Permisos a nivel usuarios de bases de datos



create login manuel with password='Password123';
create login juan with password='Password123';

--Se crea los usuarios con los longin anteriores
create user manuel for login manuel
create user juan for login juan
	
--Se asignan los roles a los usuarios
alter role db_datareader add member manuel;
alter role db_ddladmin add juan;

exec sp_addrolemember 'db_datareader','manuel';
exec sp_addrolemember 'db_backupoperator','manuel';

exec sp_addrolemember 'db_ddladmin','juan';



-- Creamos el procedimiento insertarAdministrador
create procedure insertarAdministrador
@apeynom varchar(50),
@viveahi varchar(1),
@tel varchar(20),
@s varchar(1),
@nacimiento datetime
as
begin
	insert into administrador(apeynom,viveahi,tel,sexo,fechnac)
	values (@apeynom,@viveahi,@tel,@s,@nacimiento);
end

-- Probar con manuel antes del permiso 
--insert into administrador(apeynom,viveahi,tel,sexo,fechnac) values ('Oscar Alejandro','S','391281922','M','2001-08-14')
--exec  insertarAdministrador 'Oscar Alejandro','S','3912819222','M','2001-08-14'
grant execute on insertarAdministrador to manuel 
	
-- Probar despues de el permiso 
--exec  insertarAdministrador 'Oscar Alejandro','S','3912819222','M','2001-08-14'
select * from administrador







