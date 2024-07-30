
---Tabla PL/SQL basada en el tipo programador_proyecto_record

CREATE OR REPLACE PACKAGE pkg_programador_proyecto AS
    -- Definición de la tabla PL/SQL
    TYPE programador_proyecto_table IS TABLE OF programador_proyecto_record
    INDEX BY PLS_INTEGER;
    
    -- Declaración de una variable de este tipo de tabla
    v_programador_proyecto_tab programador_proyecto_table;
    
    -- Procedimiento para llenar la tabla
    PROCEDURE llenar_tabla;
    
    -- Procedimiento para mostrar el contenido de la tabla
    PROCEDURE mostrar_tabla;
END pkg_programador_proyecto;
/

---Implementamos el cuerpo del paquete
CREATE OR REPLACE PACKAGE BODY pkg_programador_proyecto AS
    PROCEDURE llenar_tabla IS
    BEGIN
        -- Limpiamos la tabla antes de llenarla
        v_programador_proyecto_tab.DELETE;
        
        -- Llenamos la tabla con los datos
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
            v_programador_proyecto_tab(v_programador_proyecto_tab.COUNT + 1) := 
                programador_proyecto_record(
                    r.Nombre_Programador,
                    r.Años_Experiencia,
                    r.Puntos_Experiencia,
                    r.Nombre_Proyecto,
                    r.Valor_Proyecto,
                    r.Proyecto_RowID
                );
        END LOOP;
    END llenar_tabla;

    PROCEDURE mostrar_tabla IS
    BEGIN
        FOR i IN 1..v_programador_proyecto_tab.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE('Registro #' || i);
            DBMS_OUTPUT.PUT_LINE('Programador: ' || v_programador_proyecto_tab(i).Nombre_Programador);
            DBMS_OUTPUT.PUT_LINE('Años de Experiencia: ' || v_programador_proyecto_tab(i).Anios_Experiencia);
            DBMS_OUTPUT.PUT_LINE('Puntos de Experiencia: ' || v_programador_proyecto_tab(i).Puntos_Experiencia);
            DBMS_OUTPUT.PUT_LINE('Proyecto: ' || v_programador_proyecto_tab(i).Nombre_Proyecto);
            DBMS_OUTPUT.PUT_LINE('Valor del Proyecto: ' || v_programador_proyecto_tab(i).Valor_Proyecto);
            DBMS_OUTPUT.PUT_LINE('ROWID del Proyecto: ' || v_programador_proyecto_tab(i).Proyecto_RowID);
            DBMS_OUTPUT.PUT_LINE('-------------------');
        END LOOP;
    END mostrar_tabla;
END pkg_programador_proyecto;
/
