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


-- Ejemplo Funcionando


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


--Ejemplo No Funcionando

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
