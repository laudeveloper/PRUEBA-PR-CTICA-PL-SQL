/*
Mostrara la info requerida  para cada programador y proyecto, incluyendo:

    Nombre del Programador
    Años de Experiencia
    Puntos de Experiencia en el lenguaje del proyecto
    Nombre del Proyecto
    Valor del Proyecto
    ROWID del Proyecto

*/


CREATE OR REPLACE PROCEDURE mostrar_programador_proyecto_info
IS
BEGIN
    FOR r IN (SELECT * FROM TABLE(get_programador_proyecto_info())) LOOP
        DBMS_OUTPUT.PUT_LINE('Programador: ' || r.Nombre_Programador);
        DBMS_OUTPUT.PUT_LINE('Años de Experiencia: ' || r.Anios_Experiencia);
        DBMS_OUTPUT.PUT_LINE('Puntos de Experiencia: ' || r.Puntos_Experiencia);
        DBMS_OUTPUT.PUT_LINE('Proyecto: ' || r.Nombre_Proyecto);
        DBMS_OUTPUT.PUT_LINE('Valor del Proyecto: ' || r.Valor_Proyecto);
        DBMS_OUTPUT.PUT_LINE('ROWID del Proyecto: ' || r.Proyecto_RowID);
        DBMS_OUTPUT.PUT_LINE('-------------------');
    END LOOP;
END;
/