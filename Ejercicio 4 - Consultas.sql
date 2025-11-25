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
WHERE R.Fecha_Asignacion = NULL
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
