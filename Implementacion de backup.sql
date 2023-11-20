

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

-- Agregamos 10 registros

select * from gasto;

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


-- 4 Realizamos backup del log de la base de datos

BACKUP LOG base_consorcio
TO DISK = 'C:\backup\LogBackup.trn'
WITH FORMAT, INIT;


-- Insertamos 10 registros mas

select * from gasto

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


--5 Realizamos backup del log en otra ubicacion

BACKUP LOG base_consorcio
TO DISK = 'C:\backup\logs\LogBackup2.trn'
WITH FORMAT, INIT;

--6 Restauramos el backup de la base de datos

use master

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

select * from gasto






