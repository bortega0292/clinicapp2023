CREATE TABLE roles
(
    rol INT (11) NOT NULL,
    descript VARCHAR(50) NOT NULL
);

CREATE TABLE users
(
    id INT (11) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR (50) NOT NULL,
    documento INT (50) NOT NULL
);

ALTER TABLE users 
ADD PRIMARY KEY (id);

ALTER TABLE users
MODIFY id INT(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

CREATE TABLE articulos
(
    id INT (11) NOT NULL,
    title VARCHAR(50) NOT NULL,
    descript TEXT,
    hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    users_id INT(11),
    CONSTRAINT fk_users_id FOREIGN KEY(users_id) REFERENCES users(id)
);

ALTER TABLE articulos 
ADD PRIMARY KEY (id);

ALTER TABLE articulos
MODIFY id INT(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

CREATE TABLE doctores
(
    id INT(11) NOT NULL,
    id_doc VARCHAR(25),
    first_name VARCHAR(50),
    last_name VARCHAR(50), 
    phone VARCHAR(20),
    email VARCHAR(100),
    specialty INT(11)
);
ALTER TABLE doctores 
ADD PRIMARY KEY (id);

ALTER TABLE doctores
MODIFY id INT(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

CREATE TABLE pacientes
(
    id INT (11) NOT NULL,
    id_doc VARCHAR(25) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    brth_dte DATETIME,
    address_dir VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    workplace VARCHAR(50),
    ocupation VARCHAR(50),
    ss_doc VARCHAR(25) NOT NULL

);
ALTER TABLE pacientes 
ADD PRIMARY KEY (id);

ALTER TABLE pacientes
MODIFY id INT(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

CREATE TABLE facturas
(
    id INT (11) NOT NULL,
    amount DECIMAL(6,2) NOT NULL,
    patient INT (11) NOT NULL,
    record INT (11),
    paymtype INT(1),
    payment DECIMAL(6,2),
    add_user INT(11),
    add_dte DATETIME
);

ALTER TABLE facturas 
ADD PRIMARY KEY (id);

ALTER TABLE facturas
MODIFY id INT(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

CREATE TABLE pagos
(
    id INT (11) NOT NULL,
    paymtype INT(1),
    payment DECIMAL(6,2),
    invoice INT (11) NOT NULL,
    add_user INT(11),
    add_dte DATETIME
);

ALTER TABLE pagos 
ADD PRIMARY KEY (id);

ALTER TABLE pagos
MODIFY id INT(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

CREATE TABLE citas
(
    id INT (11) NOT NULL,
    doctor INT (11) NOT NULL,
    patient INT (11) NOT NULL,
    date_time DATETIME,
    estatus VARCHAR (25) NOT NULL,
    observations TEXT,
    add_user INT(11),
    add_dte DATETIME
);

ALTER TABLE citas 
ADD PRIMARY KEY (id);

ALTER TABLE citas
MODIFY id INT(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

-- Agregar Articulo
DELIMITER $$
CREATE PROCEDURE AddArticulo
(
    in Tittle    VARCHAR(100),
    in Description        TEXT, 
    in Add_user INT(11),
    in Add_dte DATETIME
)
BEGIN
INSERT INTO articulos(tittle, description, add_user, add_dte) 
VALUES (Tittle, Description, Add_user, STR_TO_DATE(Add_dte,'%Y-%m-%d %H:%i:%s'));
END
$$

-- Agregar Usuario
DELIMITER $$
CREATE PROCEDURE AddUsuario
(  
    in username VARCHAR(45),
    in password VARCHAR(100),
    in nombre VARCHAR(45),
    in apellido VARCHAR(45),
    in documento VARCHAR(45),
    in rol INT(11)
)
BEGIN
INSERT INTO usuarios
(username,password,nombre,apellido,documento,rol) 
VALUES 
(username,password,nombre,apellido,documento,rol);
END
$$


-- Agregar Paciente
DELIMITER $$
CREATE PROCEDURE AddPaciente
(
    in Id_doc VARCHAR(25),
    in First_name VARCHAR(50),
    in Last_name VARCHAR(50),
    in Brth_dte DATETIME,
    in Address_dir VARCHAR(100),
    in Phone VARCHAR(20),
    in Email VARCHAR(20),
    in Workplace VARCHAR(50),
    in Ocupation VARCHAR(50),
    in Ss_doc VARCHAR(25),
    in Add_user INT(11),
    in add_dte DATETIME
)
BEGIN
INSERT INTO pacientes
(id_doc, first_name, last_name, brth_dte, address_dir, phone, email, workplace, ocupation, ss_doc, add_user, add_dte) 
VALUES 
(Id_doc, First_name, Last_name, Brth_dte, Address_dir, Phone, Email, Workplace, Ocupation, Ss_doc, Add_user, STR_TO_DATE(Add_dte,'%Y-%m-%d %H:%i:%s'));
END
$$

ALTER TABLE pacientes ADD FOREIGN KEY(add_user) REFERENCES usuarios(id);

-- Agregar Gasto
DELIMITER $$
CREATE PROCEDURE AddGasto
( 
    in Tittle VARCHAR(100), 
    in Description TEXT, 
    in Add_user INT(11), 
    in Add_dte DATETIME
)
BEGIN
INSERT INTO Gastos (tittle, description, add_user, add_dte) 
VALUES (Title, Description, Add_user, STR_TO_DATE(Add_dte,'%Y-%m-%d %H:%i:%s'));

END
$$

-- Agregar Factura
DELIMITER $$
CREATE PROCEDURE AddFactura
( 

    in Amount DECIMAL(6,2),
    in Patient INT (11),
    in Add_user INT(11), 
    in Add_dte DATETIME
)
BEGIN
INSERT INTO facturas (amount, patient, add_user, add_dte) 
VALUES (Amount, Patient, Add_user, STR_TO_DATE(Add_dte,'%Y-%m-%d %H:%i:%s'));
END
$$

-- Agregar Pago
DELIMITER $$
CREATE PROCEDURE AddPago
( 
    paymtype INT(1),
    payment DECIMAL(6,2),
    invoice INT (11),
    add_user INT(11),
    add_dte DATETIME
)
BEGIN
INSERT INTO pagos (paymtype, payment, invoice, add_user, add_dte) 
VALUES (Paymtype, Payment, Invoice, Add_user, STR_TO_DATE(Add_dte,'%Y-%m-%d %H:%i:%s'));

UPDATE facturas f
   SET f.canceled = 1
 WHERE f.id = Invoice
   AND f.amount = (SELECT SUM(p.payment)
                     FROM pagos p
                    WHERE p.invoice = Invoice);
END
$$

-- Listar Articulos
DELIMITER $$
CREATE PROCEDURE ListArticulos()
BEGIN
SELECT * FROM articulos;
END
$$

-- Listar Doctores
DELIMITER $$
CREATE PROCEDURE ListDoctores()
BEGIN
SELECT d.*,
       CASE WHEN d.specialty = 1 THEN 'Dentista'
            WHEN d.specialty = 2 THEN 'Ortodontista'
            ELSE d.specialty
       END especialidad,
       CASE WHEN d.gender = 'M' THEN 'Dr.'
            WHEN d.gender = 'F' THEN 'Dra.'
            ELSE d.gender
       END genero
 FROM doctores As d
WHERE d.available = 1
ORDER BY last_name ASC, first_name ASC;
END
$$

-- Listar Pacientes
DELIMITER $$
CREATE PROCEDURE ListPacientes()
BEGIN
SELECT p.*,
       u.username AS usuario
   FROM pacientes AS p
   LEFT 
   JOIN usuarios AS u
   ON p.add_user = u.id;
END
$$

-- Contar Articulos
DELIMITER $$
CREATE PROCEDURE CountPacientes()
BEGIN
SELECT COUNT(id) AS total_pacientes FROM pacientes;
END
$$

-- Contar Gastos
DELIMITER $$
CREATE PROCEDURE CountGastos()
BEGIN
SELECT COUNT(id) AS total FROM gastos;
END
$$

-- Contar Usuarios
DELIMITER $$
CREATE PROCEDURE CountUsuarios()
BEGIN
SELECT COUNT(id) AS total_users FROM usuarios;
END
$$

-- Listar ultimos articulos
DELIMITER $$
CREATE PROCEDURE LastArticulos()
BEGIN
SELECT * FROM articulos ORDER BY id DESC LIMIT 6;
END
$$

-- Listar ultimos Pacientes
DELIMITER $$
CREATE PROCEDURE LastPacientes()
BEGIN
SELECT p.*,
       u.username AS usuario
   FROM pacientes AS p
   LEFT 
   JOIN usuarios AS u
   ON p.add_user = u.id
   ORDER BY u.id DESC LIMIT 6;
END
$$

-- Listar Gastos
DELIMITER $$
CREATE PROCEDURE ListGastos()
BEGIN
SELECT g.*,
       u.username AS usuario,
       ROW_NUMBER() OVER(ORDER BY g.id) AS rownum
   FROM gastos AS g
   LEFT 
   JOIN usuarios AS u
   ON g.add_user = u.id
WHERE g.canceled = 0
ORDER BY g.id DESC;
END
$$

-- Listar Facturas
DELIMITER $$
CREATE PROCEDURE ListFacturas()
BEGIN
SELECT f.*,
       CASE WHEN f.record IS NULL THEN 'No'
            WHEN f.record IS NOT NULL THEN 'Si'
       END sts_invoice,
       (f.amount-IFNULL(f.payment,0)) balance,
       p.first_name,
       p.last_name,
       u.username AS usuario,
       ROW_NUMBER() OVER(ORDER BY f.id) AS rownum
   FROM facturas AS f
   LEFT
   JOIN pacientes AS p
   ON f.patient = p.id
   LEFT 
   JOIN usuarios AS u
   ON f.add_user = u.id
WHERE f.canceled = 0
ORDER BY f.id DESC;
END
$$

-- View Expedientes
DELIMITER $$
CREATE PROCEDURE ListExpedientes(in num INT(11))
BEGIN
SELECT e.id,
       e.add_dte,
       p.first_name,
       p.last_name
   FROM expedientes AS e 
   LEFT
   JOIN pacientes AS p 
    ON e.patient = p.id
   LEFT
   JOIN usuarios u
    ON e.add_user = u.id
 WHERE p.id = (SELECT patient
                 FROM facturas
               WHERE id = num);
END
$$

-- Editar Articulo
DELIMITER $$
CREATE PROCEDURE EditArticulo(in num VARCHAR(20))
BEGIN
SELECT * FROM articulos WHERE id = num;
END
$$

-- Eliminar Articulo
DELIMITER $$
CREATE PROCEDURE DeleteArticulo(in num VARCHAR(20))
BEGIN
DELETE FROM articulos WHERE id = num;
END
$$

-- Eliminar Paciente
DELIMITER $$
CREATE PROCEDURE DeletePaciente(in num VARCHAR(20))
BEGIN
DELETE FROM pacientes WHERE id = num;
END
$$

-- Eliminar Gastos
DELIMITER $$
CREATE PROCEDURE DeleteGasto(in num VARCHAR(20))
BEGIN
DELETE FROM gastos WHERE id = num;
END
$$

-- Listar Usuarios
DELIMITER $$
CREATE PROCEDURE ListUsers()
BEGIN
SELECT * FROM users;
END
$$

-- View Pacientes
DELIMITER $$
CREATE PROCEDURE ViewPaciente()
BEGIN
SELECT p.*,
       u.username AS usuario
   FROM pacientes AS p
   LEFT 
   JOIN usuarios AS u
   ON p.add_user = u.id
WHERE u.id = num;
END
$$

-- View Datos de Sesion
DELIMITER $$
CREATE PROCEDURE ViewDataSession(in user_id VARCHAR(100))
BEGIN
SELECT username
   FROM usuarios 
WHERE username = user_id;
END
$$

-- Query para sacar user_id de tabla sessions
SELECT REPLACE(SUBSTR(data, IF(INSTR(data, '"user":') = 0, NULL, INSTR(data, '"user":')) + 7), '}', '') AS user_log FROM sessions;
SELECT username FROM users WHERE id = (SELECT REPLACE(SUBSTR(data, IF(INSTR(data, '"user":') = 0, NULL, INSTR(data, '"user":')) + 7), '}', '') AS user_log FROM sessions WHERE REPLACE(SUBSTR(data, IF(INSTR(data, '"user":') = 0, NULL, INSTR(data, '"user":')) + 7), '}', '') IS NOT NULL);

-- Sumar Gastos
DELIMITER $$
CREATE PROCEDURE SumaGastos(out suma_gastos DECIMAL(6,2))
BEGIN
SELECT SUM(amount) AS suma_gastos FROM gastos;
END
$$

-- Sumar Facturas
DELIMITER $$
CREATE PROCEDURE SumaFacturas(out suma_facturas DECIMAL(6,2))
BEGIN
SELECT SUM(amount) AS suma_facturas FROM facturas;
END
$$

-- Cancelar Gastos
DELIMITER $$
CREATE PROCEDURE CanceledGasto(in num VARCHAR(20))
BEGIN
UPDATE gastos SET canceled = 1 WHERE canceled = 0;
END
$$

-- Editar Gastos
DELIMITER $$
CREATE PROCEDURE EditGasto(in num VARCHAR(20), out NewDescription text)
BEGIN
UPDATE gastos SET description = NewDescription WHERE id = num;
END
$$

-- Agregar columna a tabla
DELIMITER $$
ALTER TABLE pacientes 
ADD treatment INT(1) NOT NULL,
ADD allergy INT(1) NOT NULL,
ADD asthma INT(1) NOT NULL,
ADD diabts INT(1) NOT NULL,
ADD hypert INT(1) NOT NULL,
ADD pregncy INT(1) NOT NULL;
$$

-- Tabla Expedientes
DELIMITER $$
CREATE TABLE expedientes
(
    id INT (11) NOT NULL,
    patient INT(11) NOT NULL,
    tooth_1 INT(1)NOT NULL,
    tooth_2 INT(1)NOT NULL, 
    tooth_3 INT(1)NOT NULL, 
    tooth_4 INT(1)NOT NULL, 
    tooth_5 INT(1)NOT NULL, 
    tooth_6 INT(1)NOT NULL, 
    tooth_7 INT(1)NOT NULL, 
    tooth_8 INT(1)NOT NULL, 
    tooth_9 INT(1)NOT NULL, 
    tooth_10 INT(1)NOT NULL, 
    tooth_11 INT(1)NOT NULL, 
    tooth_12 INT(1)NOT NULL, 
    tooth_13 INT(1)NOT NULL, 
    tooth_14 INT(1)NOT NULL, 
    tooth_15 INT(1)NOT NULL, 
    tooth_16 INT(1)NOT NULL, 
    tooth_17 INT(1)NOT NULL, 
    tooth_18 INT(1)NOT NULL, 
    tooth_19 INT(1)NOT NULL, 
    tooth_20 INT(1)NOT NULL, 
    tooth_21 INT(1)NOT NULL, 
    tooth_22 INT(1)NOT NULL, 
    tooth_23 INT(1)NOT NULL, 
    tooth_24 INT(1)NOT NULL, 
    tooth_25 INT(1)NOT NULL, 
    tooth_26 INT(1)NOT NULL, 
    tooth_27 INT(1)NOT NULL, 
    tooth_28 INT(1)NOT NULL, 
    tooth_29 INT(1)NOT NULL, 
    tooth_30 INT(1)NOT NULL, 
    tooth_31 INT(1)NOT NULL, 
    tooth_32 INT(1)NOT NULL, 
    tooth_33 INT(1)NOT NULL, 
    tooth_34 INT(1)NOT NULL, 
    tooth_35 INT(1)NOT NULL, 
    tooth_36 INT(1)NOT NULL, 
    tooth_37 INT(1)NOT NULL, 
    tooth_38 INT(1)NOT NULL, 
    tooth_39 INT(1)NOT NULL, 
    tooth_40 INT(1)NOT NULL, 
    tooth_41 INT(1)NOT NULL, 
    tooth_42 INT(1)NOT NULL, 
    tooth_43 INT(1)NOT NULL, 
    tooth_44 INT(1)NOT NULL,
    tooth_45 INT(1)NOT NULL, 
    tooth_46 INT(1)NOT NULL, 
    tooth_47 INT(1)NOT NULL, 
    tooth_48 INT(1)NOT NULL,  
    treatment TEXT,
    add_user INT(11), 
    add_dte DATETIME
);
$$

DELIMITER $$
ALTER TABLE expedientes 
ADD PRIMARY KEY (id);
ALTER TABLE expedientes
MODIFY id INT(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
&&

-- Agregar Expediente
DELIMITER $$
CREATE PROCEDURE AddExpediente
(
    in Patient INT(11),
    in Tooth_1 INT(11), 
    in Tooth_2 INT(11), 
    in Tooth_3 INT(11), 
    in Tooth_4 INT(11), 
    in Tooth_5 INT(11), 
    in Tooth_6 INT(11), 
    in Tooth_7 INT(11), 
    in Tooth_8 INT(11), 
    in Tooth_9 INT(11), 
    in Tooth_10 INT(11), 
    in Tooth_11 INT(11), 
    in Tooth_12 INT(11), 
    in Tooth_13 INT(11), 
    in Tooth_14 INT(11), 
    in Tooth_15 INT(11), 
    in Tooth_16 INT(11), 
    in Tooth_17 INT(11), 
    in Tooth_18 INT(11), 
    in Tooth_19 INT(11), 
    in Tooth_20 INT(11), 
    in Tooth_21 INT(11), 
    in Tooth_22 INT(11), 
    in Tooth_23 INT(11), 
    in Tooth_24 INT(11), 
    in Tooth_25 INT(11), 
    in Tooth_26 INT(11), 
    in Tooth_27 INT(11), 
    in Tooth_28 INT(11), 
    in Tooth_29 INT(11), 
    in Tooth_30 INT(11), 
    in Tooth_31 INT(11), 
    in Tooth_32 INT(11), 
    in Tooth_33 INT(11), 
    in Tooth_34 INT(11), 
    in Tooth_35 INT(11), 
    in Tooth_36 INT(11), 
    in Tooth_37 INT(11), 
    in Tooth_38 INT(11), 
    in Tooth_39 INT(11), 
    in Tooth_40 INT(11), 
    in Tooth_41 INT(11), 
    in Tooth_42 INT(11), 
    in Tooth_43 INT(11), 
    in Tooth_44 INT(11), 
    in Tooth_45 INT(11), 
    in Tooth_46 INT(11), 
    in Tooth_47 INT(11), 
    in Tooth_48 INT(11),
    in Treatment TEXT,
    in Add_user INT(11),
    in Add_dte DATETIME
)
BEGIN
INSERT INTO expedientes
(patient, tooth_1, tooth_2, tooth_3, tooth_4, tooth_5, tooth_6, tooth_7, tooth_8, tooth_9, tooth_10, tooth_11, tooth_12, tooth_13, tooth_14, tooth_15, tooth_16, tooth_17, tooth_18, tooth_19, tooth_20, tooth_21, tooth_22, tooth_23, tooth_24, tooth_25, tooth_26, tooth_27, tooth_28, tooth_29, tooth_30, tooth_31, tooth_32, tooth_33, tooth_34, tooth_35, tooth_36, tooth_37, tooth_38, tooth_39, tooth_40, tooth_41, tooth_42, tooth_43, tooth_44, tooth_45, tooth_46, tooth_47, tooth_48, treatment, add_user, add_dte) 
VALUES 
(Patient, Tooth_1, Tooth_2, Tooth_3, Tooth_4, Tooth_5, Tooth_6, Tooth_7, Tooth_8, Tooth_9, Tooth_10, Tooth_11, Tooth_12, Tooth_13, Tooth_14, Tooth_15, Tooth_16, Tooth_17, Tooth_18, Tooth_19, Tooth_20, Tooth_21, Tooth_22, Tooth_23, Tooth_24, Tooth_25, Tooth_26, Tooth_27, Tooth_28, Tooth_29, Tooth_30, Tooth_31, Tooth_32, Tooth_33, Tooth_34, Tooth_35, Tooth_36, Tooth_37, Tooth_38, Tooth_39, Tooth_40, Tooth_41, Tooth_42, Tooth_43, Tooth_44, Tooth_45, Tooth_46, Tooth_47, Tooth_48, Treatment, Add_user, STR_TO_DATE(Add_dte,'%Y-%m-%d %H:%i:%s'));
END
$$

-- Ver Expediente
DELIMITER $$
CREATE PROCEDURE ViewExpediente(in paciente INT(11)) 
BEGIN
SELECT e.*,
       u.username AS usuario
   FROM expedientes AS e
   LEFT 
   JOIN usuarios AS u
   ON e.add_user = u.id
WHERE e.patient = 18;
END
$$

-- Ver pagos
DELIMITER $$
CREATE PROCEDURE ViewPago(in paciente INT(11)) 
BEGIN
SELECT pg.*
 FROM facturas AS f
 LEFT
JOIN pagos AS pg
  ON pg.invoice = f.id
WHERE f.record = num;
END
$$

-- View ExpedientesPaciente
DELIMITER $$
CREATE PROCEDURE ListExpedientesPaciente(in num INT(11))
BEGIN
SELECT e.id,
       e.add_dte,
       p.first_name,
       p.last_name,
       TIMESTAMPDIFF(YEAR,p.brth_dte,CURDATE()) AS age
   FROM expedientes AS e
   LEFT 
   JOIN pacientes AS p
   ON e.patient = p.id
   LEFT
   JOIN usuarios u
   ON p.add_user = u.id
WHERE p.id = num;
END
$$

-- View Factura
DELIMITER $$
CREATE PROCEDURE ViewFactura(in num INT(11))
BEGIN
SELECT f.*,
       p.first_name,
       p.last_name,
       u.username usuario
   FROM facturas AS f
   LEFT 
   JOIN usuarios AS u
   ON f.add_user = u.id
   LEFT
   JOIN pacientes AS p
   ON f.patient = p.id
WHERE f.id = num
  AND f.canceled = 0;
END
$$

-- Agendar Cita
DELIMITER $$
CREATE PROCEDURE AddCita
(
    in Doctor INT (11),
    in Patient INT (11),
    in Date DATETIME,
    in Time DATETIME,
    in Estatus VARCHAR (25),
    in Observations TEXT,
    in Add_user INT(11),
    in Add_dte DATETIME
)
BEGIN
INSERT INTO citas
(doctor, patient, date_time, estatus, observations, add_user, add_dte) 
VALUES 
(Doctor, Patient, STR_TO_DATE(Date+Time,'%Y-%m-%d %H:%i:%s'), Estatus, Observations, Add_user, STR_TO_DATE(Add_dte,'%Y-%m-%d %H:%i:%s'));
END
$$

-- Listar Citas
DELIMITER $$
CREATE PROCEDURE ListCitas
(
   in Add_Dte DATETIME
)
BEGIN
UPDATE citas As c
   SET c.estatus = 3
 WHERE c.estatus = 1
   AND c.date_time < sysdate();
   
SELECT c.*,
       CONCAT(d.first_name,' ',d.last_name) medico,
       CONCAT(p.first_name,' ',p.last_name) paciente,
       CASE WHEN c.estatus = 1 THEN 'Pendiente'
            WHEN c.estatus = 2 THEN 'Realizada'
            WHEN c.estatus = 3 THEN 'Expirada'
            WHEN c.estatus = 4 THEN 'Cancelada'
            ELSE NULL
        END estado,
       u.username AS usuario
   FROM citas AS c
   LEFT
   JOIN doctores AS d
     ON d.id = c.doctor
   LEFT 
   JOIN pacientes p
     ON p.id = c.patient 
   LEFT 
   JOIN usuarios AS u
     ON c.add_user = u.id
ORDER BY c.date_time ASC;
END
$$

-- View Cita
DELIMITER $$
CREATE PROCEDURE ViewCita
(
   in num INT(11)
)
SELECT c.*,
       CONCAT(d.first_name,' ',d.last_name) medico,
       CONCAT(p.first_name,' ',p.last_name) paciente,
       CASE WHEN c.estatus = 1 THEN 'Pendiente'
            WHEN c.estatus = 2 THEN 'Realizada'
            WHEN c.estatus = 3 THEN 'Expirada'
            WHEN c.estatus = 4 THEN 'Cancelada'
            ELSE NULL
        END estado,
       u.username AS usuario
   FROM citas AS c
   LEFT
   JOIN doctores AS d
     ON d.id = c.doctor
   LEFT 
   JOIN pacientes p
     ON p.id = c.patient 
   LEFT 
   JOIN usuarios AS u
     ON c.add_user = u.id
WHERE c.id = num
ORDER BY c.date_time ASC;
END
$$

-- Event Agregar Gasto
DELIMITER $$
CREATE EVENT AggGasto
ON SCHEDULE 
    EVERY 1 DAY 
    STARTS '2023-03-01 00:00:00'
ON COMPLETION PRESERVE
DO
BEGIN
SET @HOY := DATE_SUB(NOW(), INTERVAL 5 HOUR);
SET @DIA := DAYOFMONTH(@HOY);
SET @ULTIMO_DIA := LAST_DAY(@HOY);
SET @MES := MONTHNAME(@HOY);
SET @ULTIMO_HOY := DATE_FORMAT(@HOY, '%Y-%m-%d');

IF @DIA = 15 THEN
    CALL AddGasto('Contrato de Limpieza', CONCAT('1er Pago del mes a Maria Acosta - ', @MES, EXTRACT(DAY FROM @HOY)), 2, @HOY, 80.50);
END IF;

IF @ULTIMO_DIA = @ULTIMO_HOY THEN
    CALL AddGasto('Contrato de Limpieza', CONCAT('2do Pago del mes a Maria Acosta - ', @MES, EXTRACT(DAY FROM @HOY)), 2, @HOY, 80.50);
END IF;
END
$$