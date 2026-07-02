/* Poner en uso BD Master */
USE master
GO

/* Crear base de datos EduFuturo */
IF DB_ID(N'EduFuturo') IS NOT NULL
    DROP DATABASE EduFuturo
GO

CREATE DATABASE EduFuturo
GO

/* Poner en uso base de datos EduFuturo */
USE EduFuturo
GO

----<> TABLAS

/* 01 Tabla student (estudiante) */
CREATE TABLE student (
    id            INT IDENTITY(1,1),
    names         VARCHAR(60)  NOT NULL,
    last_names    VARCHAR(90)  NOT NULL,
    email         VARCHAR(100) NOT NULL,
    register_date DATE         DEFAULT GETDATE(),
    birthday      DATE,
    status        CHAR(1)      DEFAULT 'A',
    CONSTRAINT student_pk  PRIMARY KEY (id),
    CONSTRAINT email_unique UNIQUE (email)
)
GO

/* 02 Crear tabla teachers */
CREATE TABLE teachers (
    id            INT IDENTITY(1,1),
    register_date DATE         DEFAULT GETDATE(),
    names         VARCHAR(70)  NOT NULL,
    last_names    VARCHAR(150) NOT NULL,
    specialty     VARCHAR(120),
    phone         CHAR(9),
    email         VARCHAR(120),
    status        CHAR(1)      DEFAULT 'A',
    CONSTRAINT teachers_pk PRIMARY KEY (id)
)
GO

/* 03 Crear tabla promotor (vendedor) */
CREATE TABLE promotor (
    code       CHAR(4)        NOT NULL,
    names      VARCHAR(70)    NOT NULL,
    last_names VARCHAR(120)   NOT NULL,
    email      VARCHAR(90),
    birthday   DATE,
    place      VARCHAR(150),
    salary     DECIMAL(8,2)   DEFAULT 0,
    status     CHAR(1)        DEFAULT 'A',
    CONSTRAINT promotor_pk PRIMARY KEY (code)
)
GO

/* 04 Crear tabla campus (sede) */
CREATE TABLE campus (
    code          CHAR(4)      NOT NULL,
    register_date DATE         DEFAULT GETDATE(),
    name          VARCHAR(100) NOT NULL,
    direction     VARCHAR(150),
    place         VARCHAR(150),
    status        CHAR(1)      DEFAULT 'A',
    CONSTRAINT campus_pk PRIMARY KEY (code)
)
GO

/* 05 Crear tabla course (curso) */
CREATE TABLE course (
    code    CHAR(4)      NOT NULL,
    names   VARCHAR(100) NOT NULL,
    credits INT,
    status  CHAR(1)      DEFAULT 'A',
    CONSTRAINT course_pk PRIMARY KEY (code)
)
GO

/* 06 Tabla careers (carreras) */
CREATE TABLE careers (
    id            INT IDENTITY(1,1),
    names         VARCHAR(90)   NOT NULL,
    descriptions  VARCHAR(2500),
    durations     INT,
    register_date DATE          DEFAULT GETDATE(),
    status        CHAR(1)       DEFAULT 'A',
    CONSTRAINT careers_pk PRIMARY KEY (id)
)
GO

/* 07 Crear tabla careers_detail */
CREATE TABLE careers_detail (
    id          INT IDENTITY(1,1),
    careers_id  INT,
    course_code CHAR(4),
    teachers_id INT,
    CONSTRAINT careers_detail_pk PRIMARY KEY (id)
)
GO

/* 08 Crear tabla enrollment */
CREATE TABLE enrollment (
    id            INT IDENTITY(1,1),
    register_date DATE          DEFAULT GETDATE(),
    student_id    INT,
    promotor_code CHAR(4),
    careers_id    INT,
    campus_code   CHAR(4),
    price         DECIMAL(8,2),
    start_date    DATE,
    status        CHAR(1)       DEFAULT 'A',
    CONSTRAINT enrollment_pk PRIMARY KEY (id)
)
GO

----<> RELACIONES

--- 1. Un curso puede llevarse o dictarse en una o varias carreras
ALTER TABLE careers_detail
    ADD CONSTRAINT careers_detail_course FOREIGN KEY (course_code) REFERENCES course(code)
GO

--- 2. Un profesor puede dictar uno o muchos cursos en una carrera
ALTER TABLE careers_detail
    ADD CONSTRAINT careers_detail_teacher FOREIGN KEY (teachers_id) REFERENCES teachers(id)
GO

--- 3. Una carrera puede tener uno o muchos detalles
ALTER TABLE careers_detail
    ADD CONSTRAINT careers_careers_detail FOREIGN KEY (careers_id) REFERENCES careers(id)
GO

--- 4. Un estudiante puede matricularse en una o muchas carreras
ALTER TABLE enrollment
    ADD CONSTRAINT enrollment_student FOREIGN KEY (student_id) REFERENCES student(id)
GO

--- 5. Un promotor puede registrar una o muchas matrículas
ALTER TABLE enrollment
    ADD CONSTRAINT enrollment_promotor FOREIGN KEY (promotor_code) REFERENCES promotor(code)
GO

--- 6. Una carrera se puede registrar en una o muchas matrículas
ALTER TABLE enrollment
    ADD CONSTRAINT enrollment_careers FOREIGN KEY (careers_id) REFERENCES careers(id)
GO

--- 7. Una sede puede ser considerada en una o muchas matrículas
ALTER TABLE enrollment
    ADD CONSTRAINT enrollment_campus FOREIGN KEY (campus_code) REFERENCES campus(code)
GO

/* =========================================
   TABLA DE USUARIOS DEL SISTEMA (login)
   Se mantiene para el acceso al sistema
   ========================================= */
CREATE TABLE USUARIOS (
    id_usuario  INT IDENTITY(1,1) PRIMARY KEY,
    nombre      VARCHAR(100) NOT NULL,
    usuario     VARCHAR(50)  NOT NULL UNIQUE,
    password    VARCHAR(100) NOT NULL,
    rol         VARCHAR(20)  NOT NULL CHECK (rol IN ('ADMIN', 'PROMOTOR')),
    estado      BIT          NOT NULL DEFAULT 1,
    created_at  DATETIME     NOT NULL DEFAULT GETDATE(),
    updated_at  DATETIME     NULL,
    deleted_at  DATETIME     NULL,
    restored_at DATETIME     NULL
)
GO

/* =========================================
   DATOS DE PRUEBA
   ========================================= */

/* Insertar registros en la tabla student */
SET DATEFORMAT dmy;
INSERT INTO student (names, last_names, email, birthday)
VALUES
    ('Juana',    'Garro Montero',     'juana.garro@outlook.com',    '10/05/1981'),
    ('Gloria',   'Ramirez Godoy',     'gloria.ramirez@gmail.com',   '19/07/1982'),
    ('Tomas',    'Avila Chumpitaz',   'tomas.avila@yahoo.com',      '20/07/1980'),
    ('Luisa',    'Ruiz Perez',        'luisa.ruiz@gmail.com',       '05/06/1990'),
    ('Carla',    'Campos Poma',       'carla.campos@hotmail.com',   '25/03/1992'),
    ('Mario',    'Varela Paredes',    'mario.varela@yahoo.com',     '20/06/1999'),
    ('Gabriel',  'Martinez Rios',     'gabriel.martinez@outlook.com','10/03/2000'),
    ('Hilario',  'Juarez Barrios',    'hilario.juarez@gmail.com',   '02/01/2003'),
    ('Rosario',  'Vargas Perez',      'rosario.vargas@gmail.com',   '01/10/1990'),
    ('Oscar',    'Valerio Cardenas',  'oscar.valerio@yahoo.com',    '02/03/1995')
GO

/* Insertar registros en la tabla promotor */
SET DATEFORMAT dmy;
INSERT INTO promotor (code, names, last_names, email, birthday, place, salary)
VALUES
    ('S001', 'Dario',        'Solorzano Barrios',   'dario.solorzano@instituto.edu.pe',  '20/04/1999', 'Arequipa', 2500),
    ('S002', 'Camila',       'Barrios Perez',        'camila.barrios@instituto.edu.pe',   '25/12/2000', 'Lima',     2575),
    ('S003', 'Luisa',        'Palomino Chumpitaz',  'luisa.palomino@instituto.edu.pe',   '27/10/2002', 'Trujillo', 2800),
    ('S004', 'Maria Fe',     'Vasquez Guerra',       'maria.vasquez@instituto.edu.pe',    '17/06/1998', 'Piura',    2750),
    ('S005', 'Eduardo Alberto','Manzo Vargas',       'eduardo.manzo@instituto.edu.pe',    '25/11/1999', 'Lima',     2900)
GO

/* Insertar registros en la tabla teachers */
INSERT INTO teachers (names, last_names, specialty, phone, email)
VALUES
    ('Adrian',  'Chumpitaz Perez',   'Tecnologia',      '997744123', 'adrian.chumpitaz@instituto.edu.pe'),
    ('Zoila',   'Guerrero Paz',      'Administracion',  '974123658', 'zoila.guerrero@instituto.edu.pe'),
    ('Marcos',  'Reyes Valenzuela',  'Marketing',       '985214721', 'marcos.reyes@instituto.edu.pe'),
    ('Camila',  'Ortiz Ramos',       'Comunicaciones',  '925136847', 'camila.ortiz@instituto.edu.pe'),
    ('Fabiola', 'Yupanqui Rios',     'Tecnologia',      '985147236', 'fabiola.yupanqui@instituto.edu.pe')
GO

/* Insertar registros en la tabla course */
INSERT INTO course (code, names, credits)
VALUES
    ('CO01', 'Algoritmos y estructuras de datos', 2),
    ('CO02', 'Herramientas Ofimatica',             1),
    ('CO03', 'Base de Datos',                      3),
    ('CO04', 'Lenguaje de Programacion I',         2),
    ('CO05', 'Redaccion profesional',              2)
GO

/* Insertar registros en la tabla careers */
INSERT INTO careers (names, descriptions, durations)
VALUES
    ('Administracion de empresas',
     'Abarca todas aquellas actividades relacionadas con el buen funcionamiento y aprovechamiento de los recursos de la organizacion para generar valor para sus clientes y colaboradores.',
     3),
    ('Computacion e Informatica',
     'Carrera que permite desarrollar sistemas de informacion multiplataforma para lograr soluciones integrales que contribuyan con el incremento de la productividad de las organizaciones.',
     3),
    ('Publicidad y Branding',
     'Administra procesos y recursos de comunicacion publicitaria, para dar a conocer un producto o un servicio, posicionandolo en el mercado.',
     3),
    ('Animacion Digital',
     'Realizar contenido audiovisual con propositos educativos, comerciales o de entretenimiento, aplicando las herramientas de la edicion de video, la post produccion y la produccion audiovisual.',
     3),
    ('Gestion de Recursos Humanos',
     'Abarca todas aquellas actividades relacionadas con la contratacion, desarrollo de capacidades y potencial de los equipos, y la retencion y crecimiento de los mismos.',
     3)
GO

/* Insertar registros en la tabla careers_detail */
INSERT INTO careers_detail (careers_id, course_code, teachers_id)
VALUES
    (1, 'CO05', 2),
    (1, 'CO02', 1),
    (2, 'CO01', 5),
    (2, 'CO02', 1),
    (3, 'CO05', 4)
GO

/* Insertar registros en la tabla campus */
INSERT INTO campus (code, name, direction, place)
VALUES
    ('C001', 'Lima Centro',          'Av. Mariscal Oscar B. 3866-4070',        'Lima'),
    ('C002', 'San Juan de Lurigancho','Av. Proceres de la Independencia 3023', 'Lima'),
    ('C003', 'Arequipa',             'Av. Porongoche 500',                      'Arequipa'),
    ('C004', 'Trujillo',             'Av. del Ejercito 889',                    'Trujillo'),
    ('C005', 'Piura',                'Calle Los Girasoles 466',                 'Piura')
GO

/* Insertar registros en la tabla enrollment */
SET DATEFORMAT dmy;
INSERT INTO enrollment (student_id, promotor_code, careers_id, campus_code, price, start_date)
VALUES
    (2,  'S001', 1, 'C002', 600, '01/03/2023'),
    (3,  'S001', 1, 'C002', 600, '01/03/2023'),
    (4,  'S001', 1, 'C002', 600, '01/03/2023'),
    (10, 'S002', 2, 'C001', 650, '15/03/2023'),
    (5,  'S004', 4, 'C003', 650, '10/12/2023')
GO

/* Insertar usuarios del sistema */
INSERT INTO USUARIOS (nombre, usuario, password, rol, created_at)
VALUES
    ('Administrador', 'admin',    '12345', 'ADMIN',   GETDATE()),
    ('Dario Solorzano','dsolorzano','12345', 'PROMOTOR', GETDATE())
GO
