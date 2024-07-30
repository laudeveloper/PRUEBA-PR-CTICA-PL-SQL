
/*
    Funcion que devuelve programador_proyecto_table 
    junto con los ROWIDs correspondientes        

 */

CREATE OR REPLACE FUNCTION get_programador_proyecto_info
RETURN programador_proyecto_table PIPELINED
IS
BEGIN
    FOR r IN (
        SELECT 
            TRIM(p.Primer_Nombre || ' ' || 
                 NVL(p.Segundo_Nombre, '') || ' ' || 
                 p.Primer_Apellido || ' ' || 
                 NVL(p.Segundo_Apellido, '')) AS Nombre_Programador,
            p.Años_Experiencia,
            pl.Puntos_Experiencia,
            pr.Nombre AS Nombre_Proyecto,
            pr.Valor AS Valor_Proyecto,
            ROWIDTOCHAR(pr.ROWID) AS Proyecto_RowID
        FROM Programadores p
        JOIN Proyecto_Programador pp ON p.ID = pp.Programador_ID
        JOIN Proyectos pr ON pp.Proyecto_ID = pr.ID
        JOIN Programador_Lenguaje pl ON p.ID = pl.Programador_ID AND pr.Lenguaje_Programacion = pl.Lenguaje_Programacion_ID
    ) LOOP
        PIPE ROW(programador_proyecto_record(
            r.Nombre_Programador,
            r.Años_Experiencia,
            r.Puntos_Experiencia,
            r.Nombre_Proyecto,
            r.Valor_Proyecto,
            r.Proyecto_RowID
        ));
    END LOOP;
    RETURN;
END;
/