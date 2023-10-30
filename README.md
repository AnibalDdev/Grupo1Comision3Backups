# Grupo1 Comision3 Tema: Backup en linea y restore

Alumnos:  Tomas Emanuel Almada
          Anibal Benjamin Dominguez
          Maria Agustina Rodriguez
          Marcos Lautaro Romero
          Maria Cecilia Romero




# Introduccion

El componente Copia de seguridad y restauración de SQL Server proporciona una protección fundamental para proteger los datos críticos almacenados en las bases de datos de SQL Server. Para minimizar el riesgo de una pérdida de datos catastrófica, debe realizar de forma periódica copias de seguridad de las bases de datos para conservar las modificaciones realizadas en los datos. Una estrategia bien diseñada de copia de seguridad y restauración le ayuda a proteger las bases de datos frente a la pérdida de datos provocada por diversos errores. Pruebe su estrategia con la restauración de un conjunto de copias de seguridad y, después, recupere la base de datos para prepararse para dar una respuesta eficaz en caso de desastre.


# Modos de recuperacion de las bases de datos 

Existen tres modos de recuperación en SQL Server, "Simple" (Simple), "Full" (Completa) y "Bulk-Logged" (Registros extensos)

1. **Recuperación Simple (Simple Recovery Model):**
   - En este modo, SQL Server mantiene registros de transacciones mínimos. Una vez que una transacción se completa con éxito, los registros se liberan y no se mantienen para la recuperación.
   - Las copias de seguridad de registros de transacciones no son posibles en este modo. Solo se pueden realizar copias de seguridad completas de la base de datos.
   - Este modo es adecuado para bases de datos que no requieren la capacidad de recuperación a un punto en el tiempo y donde la pérdida de datos desde la última copia de seguridad completa es aceptable.

2. **Recuperación Completa (Full Recovery Model):**
   - En este modo, SQL Server mantiene un registro completo de todas las transacciones realizadas en la base de datos.
   - Permite la recuperación a un punto en el tiempo, lo que significa que puedes restaurar la base de datos a un estado específico en el pasado, utilizando copias de seguridad de registros de transacciones.
   - Las copias de seguridad de registros de transacciones son esenciales y deben programarse y gestionarse adecuadamente para evitar que los archivos de registro crezcan descontroladamente.
   - Adecuado para bases de datos críticas con requisitos de recuperación avanzados.

3. **Recuperación de Registros Extensos (Bulk-Logged Recovery Model):**
   - Este modo es una especie de híbrido entre "Simple" y "Full." Al igual que "Full," se registran todas las transacciones, pero hay excepciones.
   - Algunas operaciones de carga masiva (como la carga de datos con índices agrupados) pueden minimizar el registro de transacciones, lo que puede mejorar el rendimiento en comparación con "Full."
   - No permite la recuperación a un punto en el tiempo después de ciertas operaciones masivas. Por lo tanto, después de realizar operaciones a granel, debes realizar una copia de seguridad completa de la base       de datos para restaurar a un punto específico en el tiempo.

# Parametros disponibles para crear copias de seguridad

SQL Server ofrece una variedad de parámetros que puedes utilizar al crear una copia de seguridad de una base de datos. A continuación, te muestro una lista de los parámetros más comunes que puedes usar en un comando T-SQL BACKUP DATABASE. Ten en cuenta que no todos estos parámetros son necesarios en cada copia de seguridad, y algunos son opcionales:

*TO DISK: Especifica la ubicación y el nombre del archivo de respaldo. Este es un parámetro obligatorio. Ejemplo: TO DISK = 'C:\Ruta\Para\El\Archivo\De\Backup.bak'

*WITH FORMAT: Este parámetro indica que se sobrescribirá cualquier copia de seguridad existente. Puede ser útil si estás creando una nueva serie de copias de seguridad.

*WITH INIT: Borra el conjunto de copias de seguridad existentes antes de crear una nueva copia de seguridad.

*WITH NOFORMAT: Suprime el formato de los medios, lo que significa que no se puede sobrescribir una copia de seguridad existente.

*WITH COPY_ONLY: Realiza una copia de seguridad independiente que no afecta a la secuencia de copias de seguridad regulares. Esto es útil cuando necesitas tomar una copia de seguridad adicional sin interrumpir la secuencia de copias de seguridad programadas.

*WITH DIFFERENTIAL: Realiza una copia de seguridad diferencial en lugar de una copia de seguridad completa. Esto solo copiará los cambios realizados desde la última copia de seguridad completa.

*WITH COMPRESSION: Habilita la compresión de datos en la copia de seguridad para reducir el tamaño del archivo de respaldo.

*WITH PASSWORD: Protege la copia de seguridad con una contraseña.

*WITH STATS: Muestra información sobre el progreso de la copia de seguridad, como el porcentaje completado y el tiempo transcurrido.

*MIRROR TO: Especifica una ubicación espejo para copiar simultáneamente la copia de seguridad en otra ubicación.

*MEDIADESCRIPTION: Proporciona una descripción de los medios de respaldo.

*MEDIANAME: Asigna un nombre a los medios de respaldo.

*NAME: Especifica un nombre para la copia de seguridad.

*DESCRIPTION: Proporciona una descripción de la copia de seguridad.

*NO_CHECKSUM: Deshabilita la comprobación de suma de comprobación para la copia de seguridad.

*NOREWIND: Impide que la cinta se rebobine después de la copia de seguridad.

