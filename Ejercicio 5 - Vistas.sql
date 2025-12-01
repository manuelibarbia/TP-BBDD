-- Vista A --
CREATE VIEW informacion_reclamos AS

SELECT 
	r.Fecha_Reclamo,
    r.Fecha_Asignacion,
      a.Cod_Arbol,
      DATEDIFF(day, r.Fecha_Reclamo, ISNULL(r.Fecha_Asignacion, GETDATE())) AS dias_hasta_asignacion, -- Si no hay fecha de asignación, se calcula diferencia con fecha actual
      DATEDIFF(day, r.Fecha_Reclamo, ISNULL(t.Fecha_Realizada, GETDATE())) AS dias_hasta_solucion -- Si no hay fecha de tarea realizada, se calcula diferencia con fecha actual
     
FROM
    Reclamos r
JOIN
    Arboles a ON r."ID_Arbol" = a."ID_Arbol"
LEFT JOIN
    Tareas t ON r."ID_Tarea" = t."ID_Tarea";
GO

-- Ejemplo A.1: Obtener los 10 reclamos con mayor demora en la solución, ordenados de mayor a menor atraso.
SELECT TOP 10 
    Cod_Arbol, 
    Fecha_Reclamo, 
    dias_hasta_solucion,
    dias_hasta_asignacion
FROM 
    informacion_reclamos
ORDER BY 
    dias_hasta_solucion DESC;
GO

-- Ejemplo A.2: Buscar todos los reclamos asociados al árbol 'ARB-015' para ver si fueron atendidos rápidamente o siguen pendientes.
SELECT 
    Fecha_Reclamo,
    dias_hasta_asignacion,
    dias_hasta_solucion
FROM 
    informacion_reclamos
WHERE 
    Cod_Arbol = 'ARB-015';
GO

-- Vista B --
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
    tt.Descripcion;

-- Ejemplo B.1: Buscar y mostrar solo los tipos de tareas con más de 10 realizadas.
SELECT *
FROM resumen_tareas_realizadas_tipo
WHERE Cantidad_Tareas_Realizadas > 10;

-- Ejemplo B.2: Buscar y filtrar por un tipo de tarea especifico, 'Poda' en este caso.
SELECT *
FROM resumen_tareas_realizadas_tipo
WHERE Descripcion = 'Poda';
