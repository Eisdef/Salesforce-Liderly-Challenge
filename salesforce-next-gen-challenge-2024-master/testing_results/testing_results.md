Casos de uso y de prueba

-Periodo y número de materias incompatibles
Comportamiento esperado: La plataforma es capaz de lanzar un error si el número de materias sobrepasa las permitidas
por el periodo

-Promedio incompatible
Comportamiento esperado: La plataforma lanza un error si el promedio es menor a 0 y mayor a 10

-Inserción de cotización semestral con pago por mensualidades
Comportamiento esperado: El PDF generado muestra los 6 días de pago distribuidos en 6 meses (Julio, Agosto,
Septiembre, Octubre, Noviembre, Diciembre)

-Inserción de cotización cuatrimestral con pago por mensualidades
Comportamiento esperado:El PDF generado muestra los 4 días de pago distribuidos en 6 meses (Julio, Agosto,
Septiembre y Octubre)

-Inserción de cotización semestral con pago al contado
Comportamiento esperado: El PDF generado muestra el único día de pago (10 de Julio)

-Inserción de cotización cuatrimestral con pago al contado
Comportamiento esperado: El PDF generado muestra el único día de pago (10 de Julio)

-Inserción de cotización para un alumno con promedio mayor a 9.5
Comportamiento esperado: La cotización automáticamente le asigna una beca por excelencia

-Inserción de cotización para un alumno con promedio menor a 9.5
Comportamiento esperado: La cotización no asigna la beca por excelencia

-Inserción de cotización para un alumno con una sola beca
Comportamiento esperado: El costo total de la cotización debe rebajarse en un porcentaje del subtotal

-Inserción de cotización para un alumno con una beca por excelencia y una beca de necesidad económica
Comportamiento esperado: El costo total de la cotización debe rebajarse en un 40% del subtotal

-Inserción de cotización para un alumno con todas las becas
Comportamiento esperado: El costo total de la cotización debe rebajarse en un 60% del subtotal
