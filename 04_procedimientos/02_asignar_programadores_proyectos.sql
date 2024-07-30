/*
Este procedimiento cumple con las reglas:

    Limpia las asignaciones existentes en la tabla Proyecto_Programador.
    Itera sobre cada proyecto, ordenados por fecha de inicio.
    Para cada proyecto, selecciona programadores basándose en:

        El lenguaje de programación requerido por el proyecto.
        Los puntos de experiencia del programador en ese lenguaje (ordenados de mayor a menor).
        La disponibilidad del programador (no más de dos proyectos simultáneos).


    Usa la cláusula MERGE para insertar nuevas asignaciones.
    Limita la cantidad de programadores asignados según lo requerido por cada proyecto.

 */


CREATE OR REPLACE PROCEDURE asignar_programadores_proyectos IS
BEGIN
    -- Limpiar asignaciones existentes
    DELETE FROM Proyecto_Programador;

    FOR proy IN (
        SELECT ID, Cant_Programadores, Lenguaje_Programacion, Fecha_Inicio, Fecha_Finalizacion
        FROM Proyectos
        ORDER BY Fecha_Inicio -- Procesar proyectos en orden cronológico
    )
    LOOP
        MERGE INTO Proyecto_Programador pp
        USING (
            SELECT p.ID AS Programador_ID
            FROM Programadores p
            JOIN Programador_Lenguaje pl ON p.ID = pl.Programador_ID
            WHERE pl.Lenguaje_Programacion_ID = proy.Lenguaje_Programacion
              AND p.ID NOT IN (
                  -- Programadores ya asignados a este proyecto
                  SELECT Programador_ID
                  FROM Proyecto_Programador
                  WHERE Proyecto_ID = proy.ID
              )
              AND (
                  -- Programadores con menos de dos proyectos simultáneos
                  SELECT COUNT(*)
                  FROM Proyecto_Programador pp2
                  JOIN Proyectos p2 ON pp2.Proyecto_ID = p2.ID
                  WHERE pp2.Programador_ID = p.ID
                    AND p2.Fecha_Inicio <= proy.Fecha_Finalizacion
                    AND p2.Fecha_Finalizacion >= proy.Fecha_Inicio
              ) < 2
            ORDER BY pl.Puntos_Experiencia DESC
        ) datos
        ON (pp.Proyecto_ID = proy.ID AND pp.Programador_ID = datos.Programador_ID)
        WHEN NOT MATCHED THEN
            INSERT (Proyecto_ID, Programador_ID)
            VALUES (proy.ID, datos.Programador_ID)
        WHERE ROWNUM <= proy.Cant_Programadores - (
            SELECT COUNT(*) 
            FROM Proyecto_Programador 
            WHERE Proyecto_ID = proy.ID
        );
    END LOOP;

    COMMIT;
END;
/

----Para verificar los resultados
SELECT p.Nombre AS Proyecto, 
       pr.Primer_Nombre || ' ' || pr.Primer_Apellido AS Programador,
       lp.Nombre AS Lenguaje,
       pl.Puntos_Experiencia
FROM Proyectos p
JOIN Proyecto_Programador pp ON p.ID = pp.Proyecto_ID
JOIN Programadores pr ON pp.Programador_ID = pr.ID
JOIN Programador_Lenguaje pl ON pr.ID = pl.Programador_ID AND p.Lenguaje_Programacion = pl.Lenguaje_Programacion_ID
JOIN Lenguajes_Programacion lp ON p.Lenguaje_Programacion = lp.ID
ORDER BY p.ID, pl.Puntos_Experiencia DESC;