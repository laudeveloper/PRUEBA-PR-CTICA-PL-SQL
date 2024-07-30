/*Este procedimiento cumple con todos los requisitos:

-Asigna 3 lenguajes aleatorios a cada programador.
-No repite lenguajes para el mismo programador.
-Genera puntos de experiencia aleatorios entre 0 y 100.
-Utiliza la cláusula MERGE para el control de las sentencias DML.
-Genera datos semilla al ejecutarse

*/

CREATE OR REPLACE PROCEDURE asignar_lenguajes_programadores IS
BEGIN
    FOR prog IN (SELECT ID FROM Programadores)
    LOOP
        MERGE INTO Programador_Lenguaje pl
        USING (
            SELECT prog.ID AS Programador_ID, l.ID AS Lenguaje_ID, 
                   FLOOR(DBMS_RANDOM.VALUE(0, 101)) AS Puntos_Exp
            FROM (
                SELECT ID
                FROM Lenguajes_Programacion
                ORDER BY DBMS_RANDOM.VALUE
            ) l
            WHERE ROWNUM <= 3
        ) datos
        ON (pl.Programador_ID = datos.Programador_ID AND pl.Lenguaje_Programacion_ID = datos.Lenguaje_ID)
        WHEN MATCHED THEN
            UPDATE SET pl.Puntos_Experiencia = datos.Puntos_Exp
        WHEN NOT MATCHED THEN
            INSERT (Programador_ID, Lenguaje_Programacion_ID, Puntos_Experiencia)
            VALUES (datos.Programador_ID, datos.Lenguaje_ID, datos.Puntos_Exp);
    END LOOP;
    
    COMMIT;
END;
/

-----Para verificar los resultados

SELECT p.Primer_Nombre, p.Primer_Apellido, 
       lp.Nombre AS Lenguaje, 
       pl.Puntos_Experiencia
FROM Programadores p
JOIN Programador_Lenguaje pl ON p.ID = pl.Programador_ID
JOIN Lenguajes_Programacion lp ON pl.Lenguaje_Programacion_ID = lp.ID
ORDER BY p.ID, pl.Puntos_Experiencia DESC;