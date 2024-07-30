-- Triggers
CREATE OR REPLACE TRIGGER trg_lenguajes_programacion_id
BEFORE INSERT ON Lenguajes_Programacion
FOR EACH ROW
BEGIN
    :NEW.ID := seq_lenguajes_programacion.NEXTVAL;
    :NEW.Fecha_Actualizacion := SYSDATE;
    :NEW.Usuario := USER;
END;
/

CREATE OR REPLACE TRIGGER trg_programadores_id
BEFORE INSERT ON Programadores
FOR EACH ROW
BEGIN
    :NEW.ID := seq_programadores.NEXTVAL;
    :NEW.Fecha_Actualizacion := SYSDATE;
    :NEW.Usuario := USER;
END;
/

CREATE OR REPLACE TRIGGER trg_proyectos_id
BEFORE INSERT ON Proyectos
FOR EACH ROW
BEGIN
    :NEW.ID := seq_proyectos.NEXTVAL;
    :NEW.Fecha_Actualizacion := SYSDATE;
    :NEW.Usuario := USER;
END;
/

CREATE OR REPLACE TRIGGER trg_programador_lenguaje_id
BEFORE INSERT ON Programador_Lenguaje
FOR EACH ROW
BEGIN
    :NEW.ID := seq_programador_lenguaje.NEXTVAL;
    :NEW.Fecha_Actualizacion := SYSDATE;
    :NEW.Usuario := USER;
END;
/

CREATE OR REPLACE TRIGGER trg_proyecto_programador_id
BEFORE INSERT ON Proyecto_Programador
FOR EACH ROW
BEGIN
    :NEW.ID := seq_proyecto_programador.NEXTVAL;
    :NEW.Fecha_Actualizacion := SYSDATE;
    :NEW.Usuario := USER;
END;
/