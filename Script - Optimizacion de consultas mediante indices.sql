/*

Tema 4: Optimización de consultas a través de índices

Tareas: 
•	Crear un documento de acuerdo al modelo existente en el aula virtual.
•	Realizar una carga masiva de por lo menos 1 millón de registro sobre la tabla gasto. 
  Se pueden repetir los registros ya existentes. Hacerlo con un script para poder compartirlo.
•	Realizar una búsqueda por periodo, seleccionando los campos: fecha de pago y tipo de gasto 
  (con la descripción correspondiente). Registrar el plan de ejecución utilizado por el motor y
  los tiempos de respuesta.
•	Definir un índice agrupado sobre la columna periodo y repetir la consulta anterior. 

*/

--Estas sentencias permiten ver en detalle los tiempos de ejecucion de las consultas
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
go;


-- Punto N° 1: Realizar una carga masiva de por lo menos 1 millón de registro sobre la tabla gasto. 
-- Se pueden repetir los registros ya existentes. Hacerlo con un script para poder compartirlo.

-- Se ejecuta la carga masiva de datos
INSERT INTO gasto (idprovincia, idlocalidad, idconsorcio, periodo,
fechapago, idtipogasto, importe)
SELECT TOP 100000
 24,4,1,8,'20170810',3,60321.49
FROM sys.objects a
CROSS JOIN sys.objects b;
SELECT count(*) FROM [dbo].[gasto];

-----------------------------------------------------------------------------------------------

-- Punto N° 2: Realizar una búsqueda por periodo, seleccionando los campos: fecha de pago y tipo de gasto 
-- (con la descripción correspondiente). Registrar el plan de ejecución utilizado por el motor y
-- los tiempos de respuesta.

--Consulta: Gastos del periodo 8
SELECT g.idgasto, g.periodo, g.fechapago, t.descripcion
FROM gasto g
INNER JOIN tipogasto t ON g.idtipogasto = t.idtipogasto
WHERE g.periodo = 8;
-- TIEMPO DE RESPUESTA: 

-----------------------------------------------------------------------------------------------

-- Punto N° 3: Definir un índice agrupado sobre la columna periodo y repetir la consulta anterior. 

-- Como el indice CLUSTERED tomado por defecto por SQLServer es la PRIMARY KEY de la tabla gasto, primero 
-- se debe debe eliminar dicha restriccion para asi poder crear el indice deseado

ALTER TABLE gasto
DROP CONSTRAINT PK_gasto;

-- Se crea un nuevo indice CLUSTERED en periodo bajo el nombre de IC_gasto_periodo
CREATE CLUSTERED INDEX IC_gasto_periodo
ON gasto (periodo);


-- Nuevamente, repetimos la consulta anterior para evaluar los resultados ahora que se creo el
-- nuevo indice agrupado

--Consulta: Gastos del periodo 8
SELECT g.idgasto, g.periodo, g.fechapago, t.descripcion
FROM gasto g
INNER JOIN tipogasto t ON g.idtipogasto = t.idtipogasto
WHERE g.periodo = 8;
-- TIEMPO DE RESPUESTA: 

-----------------------------------------------------------------------------------------------

-- Punto N° 4: Definir otro índice agrupado sobre la columna periodo pero que además incluya las columnas:
-- Fecha de pago y tipo de gasto y repetir la consulta anterior. 

-- Nuevamente, se elimina el índice agrupado anterior
DROP INDEX IC_gasto_periodo ON gasto;
go;

-- Se crea un nuevo índice agrupado con periodo, fechapago e idtipogasto

CREATE CLUSTERED INDEX IC_Gasto_Periodo_FechaPago_idTipoGasto
ON gasto (periodo, fechapago, idtipogasto);
go;

-- Se repite la consulta para poder ver los resultados obtenidos al ejecutar tras la creación del
-- nuevo indice agrupado.

SELECT g.idgasto, g.periodo, g.fechapago, t.descripcion
FROM gasto g
INNER JOIN tipogasto t ON g.idtipogasto = t.idtipogasto
WHERE g.periodo = 8;

-- TIEMPO DE RESPUESTA: 