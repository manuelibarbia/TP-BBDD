CREATE DATABASE Gestion_Arbolado_Publico;
GO

USE Gestion_Arbolado_Publico;
GO

CREATE TABLE Calles (
    ID_Calle INT PRIMARY KEY IDENTITY,
    Nombre_Calle VARCHAR(100)
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
    ID_Calle INT,
    ID_Espacio INT,
    Altura_Calle VARCHAR(20),
    
    FOREIGN KEY (ID_Calle) REFERENCES Calles(ID_Calle),
    FOREIGN KEY (ID_Espacio) REFERENCES Espacios_Verdes(ID_Espacio),
    
    -- Constraint: O es calle, o es espacio verde (XOR lógico)
    CHECK (
        (ID_Calle IS NOT NULL AND ID_Espacio IS NULL) OR 
        (ID_Calle IS NULL AND ID_Espacio IS NOT NULL)
    )
);

CREATE TABLE Especies (
    ID_Especie INT PRIMARY KEY IDENTITY,
    Nombre_Comun VARCHAR(100),
    Nombre_Cientifico VARCHAR(100)
);

CREATE TABLE Indicadores_Salud (
    ID_Indicador INT PRIMARY KEY IDENTITY,
    Descripcion VARCHAR(50)
);

CREATE TABLE Arboles (
    ID_Arbol INT PRIMARY KEY IDENTITY,
    ID_Especie INT,
    ID_Ubicacion INT,
    Cod_Arbol VARCHAR(20) UNIQUE,
    Coordenadas VARCHAR(50),
    Fecha_Plantacion DATE,
    FOREIGN KEY(ID_Especie)
        REFERENCES Especies(ID_Especie),
    FOREIGN KEY(ID_Ubicacion)
        REFERENCES Ubicacion(ID_Ubicacion)
);

CREATE TABLE Registros_Arboles (
    ID_Registro INT PRIMARY KEY IDENTITY,
    ID_Arbol INT,
    ID_Indicador INT,
    Altura FLOAT,
    Fecha DATE,
    FOREIGN KEY(ID_Arbol)
        REFERENCES Arboles(ID_Arbol),
    FOREIGN KEY(ID_Indicador)
        REFERENCES Indicadores_Salud(ID_Indicador)
);

CREATE TABLE Tipos_Tareas (
    ID_Tipo_Tarea INT PRIMARY KEY IDENTITY,
    Descripcion VARCHAR(50)
);

CREATE TABLE Cuadrillas (
    ID_Cuadrilla INT PRIMARY KEY IDENTITY,
    Cod_Cuadrilla VARCHAR(20) UNIQUE
);

CREATE TABLE Tareas (
    ID_Tarea INT PRIMARY KEY IDENTITY,
    ID_Tipo_Tarea INT,
    ID_Cuadrilla INT,
    Fecha_Planificada DATE,
    Comentario VARCHAR(200),
    Fecha_Realizada DATE,
    FOREIGN KEY(ID_Tipo_Tarea)
        REFERENCES Tipos_Tareas(ID_Tipo_Tarea),
    FOREIGN KEY(ID_Cuadrilla)
        REFERENCES Cuadrillas(ID_Cuadrilla)
);

CREATE TABLE Tareas_Arboles (
    ID_Tareas_Arboles INT PRIMARY KEY IDENTITY,
    ID_Tarea INT,
    ID_Arbol INT,
    FOREIGN KEY(ID_Tarea)
        REFERENCES Tareas(ID_Tarea),
    FOREIGN KEY(ID_Arbol)
        REFERENCES Arboles(ID_Arbol)
);

CREATE TABLE Motivos_Reclamos (
    ID_Motivo INT PRIMARY KEY IDENTITY,
    Descripcion VARCHAR(50)
);

CREATE TABLE Reclamos (
    ID_Reclamo INT PRIMARY KEY IDENTITY,
    ID_Arbol INT,
    ID_Motivo INT,
    ID_Tarea INT,
	Fecha_Reclamo DATE,
    Fecha_Asignacion DATE,
    Mail VARCHAR(100),
    FOREIGN KEY(ID_Arbol)
        REFERENCES Arboles(ID_Arbol),
    FOREIGN KEY(ID_Motivo)
        REFERENCES Motivos_Reclamos(ID_Motivo),
    FOREIGN KEY(ID_Tarea)
        REFERENCES Tareas(ID_Tarea)
);

CREATE TABLE Empleados (
    ID_Empleado INT PRIMARY KEY IDENTITY,
    ID_Cuadrilla INT,
    Nombre VARCHAR(50),
    Apellido VARCHAR(50),
    Cuil VARCHAR(15),
    Fecha_Ingreso DATE,
    Num_Tel VARCHAR(20),
    FOREIGN KEY(ID_Cuadrilla)
        REFERENCES Cuadrillas(ID_Cuadrilla)
);