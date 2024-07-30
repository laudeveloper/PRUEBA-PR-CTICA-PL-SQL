
/*

    El procedimiento cumple con todos los requisitos:
        Invoca la función creada en el requerimiento 6.
        Recorre el cursor retornado por la función.
        Imprime la información en consola (Salida DBMS) con el formato: Nombre del Programador -> Promedio.

*/

CREATE OR REPLACE PROCEDURE imprimir_programadores_promedio
IS
    v_cursor SYS_REFCURSOR;
    v_nombre VARCHAR2(200);
    v_promedio NUMBER;
BEGIN
    -- Invocar la función creada en el requerimiento 6
    v_cursor := get_programadores_promedio();
    
    DBMS_OUTPUT.PUT_LINE('Listado de Programadores y sus Promedios de Experiencia:');
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------');
    
    LOOP
        FETCH v_cursor INTO v_nombre, v_promedio;
        EXIT WHEN v_cursor%NOTFOUND;
        
        -- Imprimir en el formato requerido: Nombre del Programador -> Promedio
        DBMS_OUTPUT.PUT_LINE(v_nombre || ' -> ' || TO_CHAR(v_promedio, '999.99'));
    END LOOP;
    
    CLOSE v_cursor;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        IF v_cursor%ISOPEN THEN
            CLOSE v_cursor;
        END IF;
END;
/