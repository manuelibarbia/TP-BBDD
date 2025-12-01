--Consigna 2: Creacion de BDD y Tablas
CREATE DATABASE Gestion_Arbolado_Publico;
GO

USE Gestion_Arbolado_Publico;
GO

CREATE TABLE Calles (
    ID_Calle INT PRIMARY KEY IDENTITY,
    Nombre_Calle VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Tipos_Espacios (
    ID_Tipo_Espacio INT PRIMARY KEY IDENTITY(1,1),
    Descripcion VARCHAR(50) NOT NULL
);

CREATE TABLE Espacios_Verdes (
    ID_Espacio INT PRIMARY KEY IDENTITY(1,1),
    Nombre_Espacio VARCHAR(100) NOT NULL,
    ID_Tipo_Espacio INT NOT NULL,

    FOREIGN KEY (ID_Tipo_Espacio) REFERENCES Tipos_Espacios(ID_Tipo_Espacio)
);

CREATE TABLE Ubicacion (
    ID_Ubicacion INT PRIMARY KEY IDENTITY(1,1),
    ID_Calle INT NULL,
    ID_Espacio INT NULL,
    Altura_Calle VARCHAR(20) NULL,
    
    FOREIGN KEY (ID_Calle) REFERENCES Calles(ID_Calle),
    FOREIGN KEY (ID_Espacio) REFERENCES Espacios_Verdes(ID_Espacio),
    
    -- Constraint: O es calle, o es espacio verde (XOR l�gico)
    CHECK (
        (ID_Calle IS NOT NULL AND ID_Espacio IS NULL) OR 
        (ID_Calle IS NULL AND ID_Espacio IS NOT NULL)
    )
);

CREATE TABLE Especies (
    ID_Especie INT PRIMARY KEY IDENTITY,
    Nombre_Comun VARCHAR(100) NOT NULL,
    Nombre_Cientifico VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Indicadores_Salud (
    ID_Indicador INT PRIMARY KEY IDENTITY,
    Descripcion VARCHAR(50) NOT NULL
);

CREATE TABLE Arboles (
    ID_Arbol INT PRIMARY KEY IDENTITY,
    ID_Especie INT NOT NULL,
    ID_Ubicacion INT NOT NULL,
    Cod_Arbol VARCHAR(20) UNIQUE NOT NULL,
    Coordenadas VARCHAR(100) NULL,
    Fecha_Plantacion DATE NULL,
    FOREIGN KEY(ID_Especie) REFERENCES Especies(ID_Especie),
    FOREIGN KEY(ID_Ubicacion) REFERENCES Ubicacion(ID_Ubicacion)
);

CREATE TABLE Registros_Arboles (
    ID_Registro INT PRIMARY KEY IDENTITY,
    ID_Arbol INT NOT NULL,
    ID_Indicador INT NOT NULL,
    Altura FLOAT NULL,
    Fecha DATE NOT NULL,
    FOREIGN KEY(ID_Arbol) REFERENCES Arboles(ID_Arbol),
    FOREIGN KEY(ID_Indicador) REFERENCES Indicadores_Salud(ID_Indicador)
);

CREATE TABLE Tipos_Tareas (
    ID_Tipo_Tarea INT PRIMARY KEY IDENTITY,
    Descripcion VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Cuadrillas (
    ID_Cuadrilla INT PRIMARY KEY IDENTITY,
    Cod_Cuadrilla VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE Tareas (
    ID_Tarea INT PRIMARY KEY IDENTITY,
    ID_Tipo_Tarea INT NOT NULL,
    ID_Cuadrilla INT NOT NULL,
    Fecha_Planificada DATE NOT NULL,
    Comentario VARCHAR(200) NULL,
    Fecha_Realizada DATE NULL,
    FOREIGN KEY(ID_Tipo_Tarea) REFERENCES Tipos_Tareas(ID_Tipo_Tarea),
    FOREIGN KEY(ID_Cuadrilla) REFERENCES Cuadrillas(ID_Cuadrilla)
);

CREATE TABLE Tareas_Arboles (
    ID_Tareas_Arboles INT PRIMARY KEY IDENTITY,
    ID_Tarea INT NOT NULL,
    ID_Arbol INT NOT NULL,
    FOREIGN KEY(ID_Tarea) REFERENCES Tareas(ID_Tarea),
    FOREIGN KEY(ID_Arbol) REFERENCES Arboles(ID_Arbol),
	UNIQUE (ID_Tarea, ID_Arbol)
);

CREATE TABLE Motivos_Reclamos (
    ID_Motivo INT PRIMARY KEY IDENTITY,
    Descripcion VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Reclamos (
    ID_Reclamo INT PRIMARY KEY IDENTITY,
    ID_Arbol INT NOT NULL,
    ID_Motivo INT NOT NULL,
    ID_Tarea INT NULL,
	Fecha_Reclamo DATE NOT NULL,
    Fecha_Asignacion DATE NULL,
    Mail VARCHAR(100) NOT NULL,
    FOREIGN KEY(ID_Arbol) REFERENCES Arboles(ID_Arbol),
    FOREIGN KEY(ID_Motivo) REFERENCES Motivos_Reclamos(ID_Motivo),
    FOREIGN KEY(ID_Tarea) REFERENCES Tareas(ID_Tarea)
);

CREATE TABLE Empleados (
    ID_Empleado INT PRIMARY KEY IDENTITY,
    ID_Cuadrilla INT NOT NULL,
    Nombre VARCHAR(50) NOT NULL,
    Apellido VARCHAR(50) NOT NULL,
    CUIL VARCHAR(15) UNIQUE NOT NULL,
    Fecha_Ingreso DATE NOT NULL,
    Num_Tel VARCHAR(20) NOT NULL,
    FOREIGN KEY(ID_Cuadrilla) REFERENCES Cuadrillas(ID_Cuadrilla)
);

GO

-- Consigna 5: Creacion de Vistas
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



CREATE VIEW resumen_tareas_realizadas_tipo AS
SELECT
    tt.Descripcion AS Descripcion,
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
GO

-- Consigna 6: Procedimiento almacenado

USE [Gestion_Arbolado_Publico]

GO

CREATE PROCEDURE Verificar_Tareas_Pendientes
    @Cod_Arbol VARCHAR(20),
    @Desc_Tarea VARCHAR(50),
    @Fecha_Proxima_Tarea DATE OUTPUT
AS
BEGIN
    DECLARE @Cantidad_Pendientes INT;
    SET @Fecha_Proxima_Tarea = NULL;

   SELECT 
        @Cantidad_Pendientes = COUNT(*),
        @Fecha_Proxima_Tarea = MIN(T.Fecha_Planificada)
    FROM Tareas t
    INNER JOIN Tareas_Arboles ta ON t.ID_Tarea = TA.ID_Tarea
    INNER JOIN Arboles a ON ta.ID_Arbol = a.ID_Arbol
    INNER JOIN Tipos_Tareas tt ON t.ID_Tipo_Tarea = tt.ID_Tipo_Tarea
    WHERE a.Cod_Arbol = @Cod_Arbol
      AND tt.Descripcion = @Desc_Tarea
      AND t.Fecha_Realizada IS NULL;  
   
    RETURN @Cantidad_Pendientes;
END;
GO
