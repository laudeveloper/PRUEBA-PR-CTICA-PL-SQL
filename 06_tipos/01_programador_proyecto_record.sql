CREATE OR REPLACE TYPE programador_proyecto_record FORCE AS OBJECT (
    Nombre_Programador VARCHAR2(200),
    Anios_Experiencia NUMBER,
    Puntos_Experiencia NUMBER,
    Nombre_Proyecto VARCHAR2(100),
    Valor_Proyecto NUMBER(10,2),
    Proyecto_RowID VARCHAR2(18)
);
/