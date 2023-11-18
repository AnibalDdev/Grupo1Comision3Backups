

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



----- Implementacion de Transacciones y Transacciones Anidadas







----- Indices Columnares en SQL Server 



--- Creacion de la tabla.
Create table gastoNew	(
						idgastoNew int identity,
						idprovincia int,
                         idlocalidad int,
                         idconsorcio int, 
					     periodo int,
					     fechapago datetime,					     
						 idtipogasto int,
						 importe decimal (8,2),	
					     Constraint PK_gastoNew PRIMARY KEY (idgastoNew),
						 Constraint FK_gastoNew_consorcio FOREIGN KEY (idprovincia,idlocalidad,idconsorcio)  REFERENCES consorcio(idprovincia,idlocalidad,idconsorcio),
						 Constraint FK_gastoNew_tipo FOREIGN KEY (idtipogasto)  REFERENCES tipogasto(idtipogasto)					     					     						 					     					     
							)
go


--select * from gasto;


--CARGA DE UN MILLON DE REGISTROS
--INSERCION POR LOTES

-- select * from gastoNew;

declare @tamanioLote int = 1000; -- Tamaño del lote
declare @cont int = 1;     -- Contador de lotes

-- Inicia un bucle para la inserción por lotes
while @cont <= 1000000 -- Cambia 1000 por el número de lotes necesarios para un millón de registros
begin
    insert into gastoNew (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
    select top (@tamanioLote) idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe
    from gasto
    where idgasto not in (select idgastoNew from gastoNew); -- Evita duplicados

    set @cont = @cont + 1;
end;



-- Declarar el tamaño del lote y el contador
DECLARE @BatchSize INT = 1000; -- Tamaño del lote
DECLARE @Counter INT = 1;     -- Contador de lotes

-- Iniciar un bucle para la inserción por lotes
WHILE @Counter <= 1000000 -- Cambia 1000 al número de lotes necesarios para un millón de registros
BEGIN
    -- Insertar registros desde gasto a gastoNew en lotes
    INSERT INTO gastoNew (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
    SELECT TOP (@BatchSize) idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe
    FROM gasto
    WHERE idgasto NOT IN (SELECT idgasto FROM gastoNew); -- Evitar duplicados

    SET @Counter = @Counter + 1;
END;

insert into gastoNew (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
select idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe
from gasto
order by idgasto
offset 0 rows
fetch next 1000000 rows only; -- Ajusta el tamaño del lote según tus necesidades




INSERT INTO gastoNew (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
SELECT idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe
FROM (
    SELECT idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe,
           ROW_NUMBER() OVER (ORDER BY idgasto) AS RowNumber
    FROM gasto
) AS Subquery
WHERE RowNumber BETWEEN 1 AND 1000000;






