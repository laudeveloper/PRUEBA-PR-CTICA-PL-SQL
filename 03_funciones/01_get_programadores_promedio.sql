/*
 La funcion cumple con los criterios:

    Declara un cursor de tipo SYS_REFCURSOR.
    Abre el cursor con una consulta SQL que:
        Concatena los nombres y apellidos del programador, usando NVL para manejar los segundos nombres o apellidos que puedan ser NULL.
        Calcula el promedio de los puntos de experiencia para cada programador.
        Agrupa los resultados por programador.
        Ordena los resultados por el promedio de experiencia de forma descendente.
    Retorna el cursor.

    tenemos que cumple con los requisitos:
        Retorna un cursor con los campos Nombre del Programador y el promedio de puntos de experiencia.
        Concatena correctamente los nombres y apellidos de los programadores.
        Ordena los resultados por el promedio aritmético de forma descendente.

*/

CREATE OR REPLACE FUNCTION get_programadores_promedio
RETURN SYS_REFCURSOR
IS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
        SELECT 
            TRIM(p.Primer_Nombre || ' ' || 
                 NVL(p.Segundo_Nombre, '') || ' ' || 
                 p.Primer_Apellido || ' ' || 
                 NVL(p.Segundo_Apellido, '')) AS Nombre_Programador,
            ROUND(AVG(pl.Puntos_Experiencia), 2) AS Promedio_Experiencia
        FROM 
            Programadores p
            JOIN Programador_Lenguaje pl ON p.ID = pl.Programador_ID
        GROUP BY 
            p.ID,
            p.Primer_Nombre,
            p.Segundo_Nombre,
            p.Primer_Apellido,
            p.Segundo_Apellido
        ORDER BY 
            AVG(pl.Puntos_Experiencia) DESC;

    RETURN v_cursor;
END;
/

---- Para usar esta función y que se pueda ver los resultados se puede crear el siguiente procedimiento de prueba 

CREATE OR REPLACE PROCEDURE test_get_programadores_promedio
IS
    v_cursor SYS_REFCURSOR;
    v_nombre VARCHAR2(200);
    v_promedio NUMBER;
BEGIN
    v_cursor := get_programadores_promedio();
    
    DBMS_OUTPUT.PUT_LINE('Nombre del Programador | Promedio de Experiencia');
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------');
    
    LOOP
        FETCH v_cursor INTO v_nombre, v_promedio;
        EXIT WHEN v_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(RPAD(v_nombre, 30) || ' | ' || v_promedio);
    END LOOP;
    
    CLOSE v_cursor;
END;
/