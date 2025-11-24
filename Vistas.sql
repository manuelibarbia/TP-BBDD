-- Vista a) Información de los reclamos

CREATE VIEW informacion_reclamos AS

SELECT 
    r.Fecha_Asignacion,
      a.Cod_Arbol,
      DATEDIFF(day, ISNULL(t.Fecha_Planificada, GETDATE()), r.Fecha_Asignacion) AS dias_asignacion, -- Si no hay fecha de tarea planificada, se calcula diferencia con fecha actual
      DATEDIFF(day, ISNULL(t.Fecha_Realizada, GETDATE()), ISNULL(t.Fecha_Planificada, r.Fecha_Asignacion)) AS dias_solucion -- Si no hay fecha de tarea realizada, se calcula diferencia con fecha actual (de Planificacion o de Asignacion si Planificacion tampoco esta)
      -- Si No hay fecha planificada, se espera el mismo valor en dias_asignacion y dias_solucion, los dias transcurridos desde el reclamo
     
FROM
    Reclamos r
LEFT JOIN
    Tareas t ON r."ID_Tarea" = t."ID_Tarea"
JOIN
    Tareas_Arboles ta ON r."ID_Tarea" = ta."ID_Tarea"
JOIN
    Arboles a ON ta."ID_Arbol" = a."ID_Arbol"
;

GO

-- Vista b) Resumen de tareas ya realizadas según su tipo

CREATE VIEW resumen_tareas_realizadas_tipo AS
SELECT
    tt.Descripcion,
    MIN(t.Fecha_Realizada) AS Fecha_Primer_Tarea,
    MAX(t.Fecha_Realizada) AS Fecha_Ultima_Tarea,
    COUNT(t.ID_Tarea) AS Cantidad_Tareas_Realizadas
FROM
    Tareas t
JOIN
    Tipos_Tareas tt ON t.ID_Tipo_Tarea = tt.ID_Tipo_Tarea
WHERE
    t.Fecha_Realizada IS NOT NULL  -- No incluir tareas no realizadas
GROUP BY
    tt.Descripcion
;



