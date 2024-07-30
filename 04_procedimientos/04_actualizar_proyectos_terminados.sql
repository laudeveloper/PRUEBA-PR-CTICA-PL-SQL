
/* La estructura de este procedimiento es la siguiente:

    Define el tipo de registro programador_proyecto_record y la tabla PL/SQL programador_proyecto_table.
    Declara un cursor explícito c_proyectos_menor_valor que selecciona los 5 proyectos distintos con menor 
        valor que aún están vigentes (Estado = 'V').
    Abre el cursor y llena la tabla PL/SQL con los registros obtenidos.
    Recorre la tabla PL/SQL y actualiza el estado de los proyectos a 'T' (Terminado) utilizando el ROWID.
    Muestra información sobre los proyectos actualizados y confirma las actualizaciones.

    el procedimiento cumple con todas las reglas:
        Utiliza un cursor explícito para alimentar la tabla PL/SQL.
        El cursor contiene 5 registros correspondientes a los proyectos con menor valor.
        Asegura que los 5 proyectos retornados sean distintos (usando DISTINCT y FETCH FIRST 5 ROWS ONLY).
        Actualiza el estado de los proyectos a 'T' utilizando el ROWID en la cláusula WHERE.

*/

CREATE OR REPLACE PROCEDURE actualizar_proyectos_terminados IS
    -- Declaración del tipo de registro
    TYPE programador_proyecto_record IS RECORD (
        Nombre_Programador VARCHAR2(200),
        Anios_Experiencia NUMBER,
        Puntos_Experiencia NUMBER,
        Nombre_Proyecto VARCHAR2(100),
        Valor_Proyecto NUMBER(10,2),
        Proyecto_RowID ROWID
    );
    
    -- Declaración de la tabla PL/SQL
    TYPE programador_proyecto_table IS TABLE OF programador_proyecto_record
    INDEX BY PLS_INTEGER;
    
    -- Variable de la tabla PL/SQL
    v_programador_proyecto_tab programador_proyecto_table;
    
    -- Cursor explícito
    CURSOR c_proyectos_menor_valor IS
        SELECT DISTINCT
            TRIM(p.Primer_Nombre || ' ' || 
                 NVL(p.Segundo_Nombre, '') || ' ' || 
                 p.Primer_Apellido || ' ' || 
                 NVL(p.Segundo_Apellido, '')) AS Nombre_Programador,
            p.Años_Experiencia AS Anios_Experiencia,
            pl.Puntos_Experiencia,
            pr.Nombre AS Nombre_Proyecto,
            pr.Valor AS Valor_Proyecto,
            pr.ROWID AS Proyecto_RowID
        FROM Proyectos pr
        JOIN Proyecto_Programador pp ON pr.ID = pp.Proyecto_ID
        JOIN Programadores p ON pp.Programador_ID = p.ID
        JOIN Programador_Lenguaje pl ON p.ID = pl.Programador_ID AND pr.Lenguaje_Programacion = pl.Lenguaje_Programacion_ID
        WHERE pr.Estado = 'V' -- Asumiendo que 'V' es el estado para proyectos vigentes
        ORDER BY pr.Valor ASC
        FETCH FIRST 5 ROWS ONLY;
    
    -- Variable para almacenar un registro del cursor
    v_registro programador_proyecto_record;
    
BEGIN
    -- Abrir el cursor y llenar la tabla PL/SQL
    OPEN c_proyectos_menor_valor;
    
    LOOP
        FETCH c_proyectos_menor_valor INTO v_registro;
        EXIT WHEN c_proyectos_menor_valor%NOTFOUND OR c_proyectos_menor_valor%ROWCOUNT > 5;
        
        v_programador_proyecto_tab(c_proyectos_menor_valor%ROWCOUNT) := v_registro;
    END LOOP;
    
    CLOSE c_proyectos_menor_valor;
    
    -- Recorrer la tabla PL/SQL y actualizar los proyectos
    FOR i IN 1..v_programador_proyecto_tab.COUNT LOOP
        UPDATE Proyectos
        SET Estado = 'T'
        WHERE ROWID = v_programador_proyecto_tab(i).Proyecto_RowID;
        
        DBMS_OUTPUT.PUT_LINE('Proyecto actualizado: ' || v_programador_proyecto_tab(i).Nombre_Proyecto);
    END LOOP;
    
    -- Confirmar las actualizaciones
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Total de proyectos actualizados: ' || v_programador_proyecto_tab.COUNT);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        ROLLBACK;
END actualizar_proyectos_terminados;
/