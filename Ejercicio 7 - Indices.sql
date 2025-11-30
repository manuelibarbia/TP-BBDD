-- EJERCICIO 7, Creacion de Indices

CREATE INDEX IX_Tareas_IDCuadrilla_FechaRealizada 
    ON Tareas(ID_Cuadrilla, Fecha_Realizada);
/* El beneficio de este índice es que reduce drásticamente el costo de consultas
 que combinan Cuadrilla y Fecha_Realizada, porque evita que el motor tenga que usar
 dos índices separados o escanear toda la tabla.
 Sin embargo, creemos que un indice simple de 'Fecha_Realizada'
 podria ser mas conveniente ya que es mas liviano y utiliza menos recursos,
 y seria muy util en otras consultas donde Fecha_Realizada este en combinacion
 con otras columnas que no sean Cuadrilla como en este caso.
*/

-- Índice simple para búsquedas por fecha realizada:
CREATE INDEX IX_Tareas_FechaRealizada 
    ON Tareas(Fecha_Realizada);

CREATE INDEX IX_Arboles_IDUbicacion ON Arboles(ID_Ubicacion);
/* Este indice acelera el join en la busqueda de cada uno de los arboles con ubicación.
 Seria de mucha utilidad en todas las consultas que se relacionen con cada arbol
 y su ubicacion.
*/

CREATE INDEX IX_Reclamos_IDMotivo_FechaAsignacion 
    ON Reclamos(ID_Motivo, Fecha_Asignacion);
/* Este indice reduce el costo de consultas combinadas por Motivo y Fecha_Asignacion
 del reclamo. Al igual que en el caso anterior, pensamos que un indice simple
 de 'Fecha_Asignacion' podria ser mas adecuedo para las busquedas en general
 que tengan relacion con la fecha de asignacion del reclamo.
*/

-- Índice simple para búsquedas por fecha de asignacion:
CREATE INDEX IX_Reclamos_FechaAsignacion 
    ON Reclamos(Fecha_Asignacion);

CREATE INDEX IX_RegistrosArboles_IDArbol_Altura 
    ON Registros_Arboles(ID_Arbol, Altura);
/* Con este índice, el motor puede ubicar rápidamente todos los registros asociados
 a un árbol específico sin escanear toda la tabla Registros_Arboles.
 En este caso hay doble beneficio porque la consulta tiene una sub-consulta
 asociada a la altura del arbol que tambien es utilizada en la consulta principal.
 */
