-- Consigna 4: Consultas
--a
SELECT TOP 1 C.Cod_Cuadrilla, COUNT(T.ID_Tarea) AS Cantidad_Tareas
FROM Tareas T
JOIN Cuadrillas C
    ON T.ID_Cuadrilla = C.ID_Cuadrilla
WHERE T.Fecha_Realizada >= '2025-10-01' 
    AND T.Fecha_Realizada < '2025-11-01'
GROUP BY C.Cod_Cuadrilla
ORDER BY Cantidad_Tareas DESC

--b
SELECT M.Descripcion, COUNT(R.ID_Reclamo) AS Cantidad_Reclamos
FROM Reclamos R
JOIN Motivos_Reclamos M
    ON R.ID_Motivo = M.ID_Motivo
WHERE R.Fecha_Asignacion IS NULL
GROUP BY M.Descripcion
HAVING COUNT(R.ID_Reclamo) > 3
ORDER BY Cantidad_Reclamos DESC;

--c
SELECT A.Cod_Arbol, E.Nombre_Comun AS Especie, C.Nombre_Calle,
    U.Altura_Calle, EV.Nombre_Espacio
FROM Arboles A
JOIN Especies E 
    ON A.ID_Especie = E.ID_Especie
JOIN Ubicacion U 
    ON A.ID_Ubicacion = U.ID_Ubicacion
LEFT JOIN Calles C 
    ON U.ID_Calle = C.ID_Calle
LEFT JOIN Espacios_Verdes EV 
    ON U.ID_Espacio = EV.ID_Espacio
LEFT JOIN Reclamos R 
    ON A.ID_Arbol = R.ID_Arbol
WHERE R.ID_Reclamo IS NULL;

--d
SELECT E.Nombre_Comun AS Especie, A.Cod_Arbol, R.Altura
FROM Arboles A
JOIN Especies E 
    ON A.ID_Especie = E.ID_Especie
JOIN Registros_Arboles R 
    ON A.ID_Arbol = R.ID_Arbol
WHERE R.Altura IS NOT NULL
  AND (
        SELECT COUNT(*)
        FROM Registros_Arboles R2
        JOIN Arboles A2 
            ON R2.ID_Arbol = A2.ID_Arbol
        WHERE A2.ID_Especie = A.ID_Especie
          AND R2.Altura > R.Altura
      ) < 3
ORDER BY Especie, R.Altura DESC;

-- Consigna 5: Prueba de Vistas

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

-- Ejemplo B.1: Buscar y mostrar solo los tipos de tareas con más de 4 realizadas.
SELECT *
FROM resumen_tareas_realizadas_tipo
WHERE Cantidad_Tareas_Realizadas > 4;

-- Ejemplo B.2: Buscar y filtrar por un tipo de tarea especifico, 'Poda' en este caso.
SELECT *
FROM resumen_tareas_realizadas_tipo
WHERE Descripcion = 'Poda';



-- Consigna 6: Prueba de Procedimiento Almacenado

-- Ejemplo Encontrado


DECLARE @Fecha_Salida DATE;
DECLARE @Total_Pendientes INT;


EXEC @Total_Pendientes = Verificar_Tareas_Pendientes 
    @Cod_Arbol = 'ARB-015', 
    @Desc_Tarea = 'Plantación', 
    @Fecha_Proxima_Tarea = @Fecha_Salida OUTPUT;

SELECT 
    @Fecha_Salida AS Proxima_Fecha, 
    @Total_Pendientes AS Cantidad;

GO


--Ejemplo No Encontrado

DECLARE @Fecha_Salida DATE;
DECLARE @Total_Pendientes_B INT;

EXEC @Total_Pendientes_B = Verificar_Tareas_Pendientes 
    @Cod_Arbol = 'ARB-009', 
    @Desc_Tarea = 'Poda', 
    @Fecha_Proxima_Tarea = @Fecha_Salida OUTPUT;

SELECT 
    @Fecha_Salida AS Proxima_Fecha, 
    @Total_Pendientes_B AS Cantidad;
GO
    