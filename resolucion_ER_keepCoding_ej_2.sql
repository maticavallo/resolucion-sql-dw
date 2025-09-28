CREATE TABLE profesor (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    remuneracion_pagada BOOLEAN DEFAULT FALSE
);

CREATE TABLE bootcamp (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL
);

CREATE TABLE proyecto_final (
    id SERIAL PRIMARY KEY,
    bootcamp_id INTEGER NOT NULL,
    nombre_proyecto VARCHAR(200) NOT NULL,
    fecha_entrega DATE,
    aprobado BOOLEAN DEFAULT FALSE,
    profesor_id INTEGER,
    FOREIGN KEY (bootcamp_id) REFERENCES bootcamp(id),
    FOREIGN KEY (profesor_id) REFERENCES profesor(id)
);

CREATE TABLE alumno (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    proyecto_final_id INTEGER,
    FOREIGN KEY (proyecto_final_id) REFERENCES proyecto_final(id)
);

CREATE TABLE matricula (
    id SERIAL PRIMARY KEY,
    alumno_id INTEGER NOT NULL,
    bootcamp_id INTEGER NOT NULL,
    fecha_matricula DATE NOT NULL,
    matricula_pagada BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (alumno_id) REFERENCES alumno(id),
    FOREIGN KEY (bootcamp_id) REFERENCES bootcamp(id),
    UNIQUE(alumno_id, bootcamp_id)
);

CREATE TABLE modulo (
    id SERIAL PRIMARY KEY,
    bootcamp_id INTEGER NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    FOREIGN KEY (bootcamp_id) REFERENCES bootcamp(id)
);

CREATE TABLE clase (
    id SERIAL PRIMARY KEY,
    modulo_id INTEGER NOT NULL,
    profesor_id INTEGER NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    FOREIGN KEY (modulo_id) REFERENCES modulo(id),
    FOREIGN KEY (profesor_id) REFERENCES profesor(id)
);

CREATE TABLE cursado_modulo (
    id SERIAL PRIMARY KEY,
    alumno_id INTEGER NOT NULL,
    modulo_id INTEGER NOT NULL,
    aprobado BOOLEAN DEFAULT FALSE,
    profesor_id INTEGER,
    fecha_evaluacion DATE,
    FOREIGN KEY (alumno_id) REFERENCES alumno(id),
    FOREIGN KEY (modulo_id) REFERENCES modulo(id),
    FOREIGN KEY (profesor_id) REFERENCES profesor(id),
    UNIQUE(alumno_id, modulo_id)
);