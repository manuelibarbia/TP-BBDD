INSERT INTO Tareas (ID_Tipo_Tarea, ID_Cuadrilla, Fecha_Planificada, Comentario, Fecha_Realizada) VALUES 
(1, 1, '2025-10-28', 'Tarea completada 21', '2025-10-30'),
(2, 3, '2025-10-22', 'Tarea completada 22', '2025-10-27'),
(3, 1, '2025-10-02', 'Tarea completada 23', '2025-10-09'),
(5, 1, '2025-10-21', 'Tarea completada 24', '2025-10-23'),
(5, 2, '2025-10-12', 'Tarea completada 25', '2025-10-13'),
(1, 2, '2025-10-25', 'Tarea completada 26', '2025-10-26'),
(3, 1, '2025-10-01', 'Tarea completada 27', '2025-10-05'),
(4, 3, '2025-10-08', 'Tarea completada 28', '2025-10-12');

INSERT INTO Reclamos (ID_Arbol, ID_Motivo, ID_Tarea, Fecha_Reclamo, Fecha_Asignacion, Mail) VALUES
(5, 2, NULL, '2025-10-15', NULL, 'vecino11@gmail.com'),
(6, 3, NULL, '2025-10-20', NULL, 'vecino12@gmail.com'),
(10, 3, NULL, '2025-10-25', NULL, 'vecino13@gmail.com'),
(12, 3, NULL, '2025-10-28', NULL, 'vecino14@gmail.com'),
(14, 5, NULL, '2025-10-01', NULL, 'vecino15@gmail.com'),
(5, 5, NULL, '2025-11-05', NULL, 'vecino11@gmail.com'),
(6, 1, NULL, '2025-11-03', NULL, 'vecino12@gmail.com'),
(10, 3, NULL, '2025-11-05', NULL, 'vecino13@gmail.com'),
(12, 1, NULL, '2025-11-08', NULL, 'vecino14@gmail.com'),
(14, 5, NULL, '2025-10-11', NULL, 'vecino15@gmail.com');
