
-----Para poder usar la tabla PL/SQL, se crea este procedimiento de prueba:

CREATE OR REPLACE PROCEDURE test_programador_proyecto_table IS
BEGIN
    -- Llenar la tabla
    pkg_programador_proyecto.llenar_tabla;
    
    -- Mostrar el contenido de la tabla
    pkg_programador_proyecto.mostrar_tabla;
END;
/