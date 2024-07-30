-- Crear tabla  Lenguajes de Programación
CREATE TABLE Lenguajes_Programacion (
  ID NUMBER PRIMARY KEY,
  Nombre VARCHAR2(100) NOT NULL,
  Estado CHAR(1) CHECK (Estado IN ('A', 'I')),
  Usuario VARCHAR2(50),
  Fecha_Actualizacion DATE
);
-- Crear tabla Programadores
CREATE TABLE Programadores (
  ID NUMBER PRIMARY KEY,
  Primer_Nombre VARCHAR2(50) NOT NULL,
  Segundo_Nombre VARCHAR2(50),
  Primer_Apellido VARCHAR2(50) NOT NULL,
  Segundo_Apellido VARCHAR2(50),
  Edad NUMBER CHECK (Edad > 0),
  Años_Experiencia NUMBER CHECK (Años_Experiencia > 0),
  Sexo CHAR(1) CHECK (Sexo IN ('M', 'F')),
  Usuario VARCHAR2(50),
  Fecha_Actualizacion DATE
);
-- Crear tabla Proyectos
CREATE TABLE Proyectos (
  ID NUMBER PRIMARY KEY,
  Nombre VARCHAR2(100) NOT NULL,
  Valor NUMBER(10,2),
  Fecha_Inicio DATE NOT NULL,
  Fecha_Finalizacion DATE NOT NULL CHECK (Fecha_Finalizacion >= Fecha_Inicio),
  Cant_Programadores NUMBER CHECK (Cant_Programadores > 0),
  Lenguaje_Programacion NUMBER,
  Estado CHAR(1) CHECK (Estado IN ('V', 'T')),
  Usuario VARCHAR2(50),
  Fecha_Actualizacion DATE,
  CONSTRAINT fk_Lenguaje_Programacion FOREIGN KEY (Lenguaje_Programacion) REFERENCES Lenguajes_Programacion(ID)
);
-- Crear tabla Programador_Lenguaje
CREATE TABLE Programador_Lenguaje (
  ID NUMBER PRIMARY KEY,
  Programador_ID NUMBER,
  Lenguaje_Programacion_ID NUMBER,
  Puntos_Experiencia NUMBER CHECK (Puntos_Experiencia BETWEEN 0 AND 100),
  Usuario VARCHAR2(50),
  Fecha_Actualizacion DATE,
  CONSTRAINT fk_Programador FOREIGN KEY (Programador_ID) REFERENCES Programadores(ID),
  CONSTRAINT fk_Lenguaje FOREIGN KEY (Lenguaje_Programacion_ID) REFERENCES Lenguajes_Programacion(ID)
);
-- Crear tabla Proyecto_Programador
CREATE TABLE Proyecto_Programador (
  ID NUMBER PRIMARY KEY,
  Proyecto_ID NUMBER,
  Programador_ID NUMBER,
  Usuario VARCHAR2(50),
  Fecha_Actualizacion DATE,
  CONSTRAINT fk_Proyecto FOREIGN KEY (Proyecto_ID) REFERENCES Proyectos(ID),
  CONSTRAINT fk_ProgramadorProyecto FOREIGN KEY (Programador_ID) REFERENCES Programadores(ID)
);