-- Año: 2022
-- Grupo Nro: 9
-- Integrantes: Israilev Mateo y Matienzo Benjamín Alejandro
-- Tema: Base de datos Nutricionistas
-- Nombre del Esquema (LBD2022G09Nutricionistas)
-- Plataforma (SO + Versión): Windows 11 + 21H2
-- Motor y Versión: MySQL 8.0.28
-- GitHub Repositorio: LBD2022G09
-- GitHub Usuario: Korian99 y benja12matienzo

-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema lbd2022g09nutricion
-- -----------------------------------------------------
DROP DATABASE IF EXISTS `lbd2022g09nutricion`;
-- -----------------------------------------------------
-- Schema lbd2022g09nutricion
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `lbd2022g09nutricion` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `lbd2022g09nutricion` ;

-- -----------------------------------------------------
-- Table `lbd2022g09nutricion`.`personas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `lbd2022g09nutricion`.`personas` (
  `idPersona` INT NOT NULL AUTO_INCREMENT,
  `Apellidos` VARCHAR(30) NOT NULL,
  `Nombres` VARCHAR(30) NOT NULL,
  `Usuario` VARCHAR(30) NULL DEFAULT NULL,
  `Contrasenia` CHAR(32) NOT NULL,
  `Estado` CHAR(1) NOT NULL DEFAULT 'A',
  PRIMARY KEY (`idPersona`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;





-- -----------------------------------------------------
-- Table `lbd2022g09nutricion`.`nutricionistas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `lbd2022g09nutricion`.`nutricionistas` (
  `idNutricionista` INT NOT NULL,
  `Matricula` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`idNutricionista`),
  UNIQUE INDEX `Matricula_UNIQUE` (`Matricula` ASC),
  CONSTRAINT `fk_Nutricionistas_Personas1`
    FOREIGN KEY (`idNutricionista`)
    REFERENCES `lbd2022g09nutricion`.`personas` (`idPersona`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `lbd2022g09nutricion`.`tiposdoc`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `lbd2022g09nutricion`.`tiposdoc` (
  `idTiposDoc` INT NOT NULL,
  `TipoDoc` VARCHAR(45) NOT NULL,
  `Estado` CHAR(1) NOT NULL DEFAULT 'A',
  PRIMARY KEY (`idTiposDoc`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `lbd2022g09nutricion`.`pacientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `lbd2022g09nutricion`.`pacientes` (
  `Documento` VARCHAR(15) NOT NULL,
  `ObraSocial` VARCHAR(50) NULL DEFAULT NULL,
  `idTipoDoc` INT NOT NULL,
  `idPaciente` INT NOT NULL,
  `Sexo` ENUM('Masculino','Femenino'),
  `FechaNacimiento` DATETIME NOT NULL,
  `Consideraciones` VARCHAR(300) NULL,
  PRIMARY KEY (`idPaciente`),
  CONSTRAINT `fk_Pacientes_Personas1`
    FOREIGN KEY (`idPaciente`)
    REFERENCES `lbd2022g09nutricion`.`personas` (`idPersona`),
  CONSTRAINT `fk_Pacientes_TiposDoc1`
    FOREIGN KEY (`idTipoDoc`)
    REFERENCES `lbd2022g09nutricion`.`tiposdoc` (`idTiposDoc`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `lbd2022g09nutricion`.`tiposestudio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `lbd2022g09nutricion`.`tiposestudio` (
  `idTiposEstudio` INT NOT NULL AUTO_INCREMENT,
  `TipoEstudio` VARCHAR(100) NOT NULL,
  `Descripcion` TEXT NULL DEFAULT NULL,
  `Estado` CHAR(1) NOT NULL DEFAULT 'A',
  `Precio` INT NOT NULL, 
  PRIMARY KEY (`idTiposEstudio`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `lbd2022g09nutricion`.`estudios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `lbd2022g09nutricion`.`estudios` (
  `idEstudios` INT NOT NULL,
  `FechaAlta` DATETIME NOT NULL,
  `FechaConfirmacion` DATETIME NULL DEFAULT NULL,
  `FechaComienzo` DATETIME NULL DEFAULT NULL,
  `FechaFinalizacion` DATETIME NULL DEFAULT NULL,
  `FechaBaja` DATETIME NULL DEFAULT NULL,
  `IdNutricionista` INT NOT NULL,
  `IdPaciente` INT NOT NULL,
  `Abonado` boolean NOT NULL DEFAULT FALSE,
  `Precio` INT, 
  `idTiposEstudio` INT NOT NULL,
  PRIMARY KEY (`idEstudios`,`idTiposEstudio`),
  INDEX `fk_Estudios_Nutricionistas1_idx` (`IdNutricionista` ASC),
  INDEX `fk_Estudios_Pacientes1_idx` (`IdPaciente` ASC),
  INDEX `fk_Estudios_TiposEstudio1_idx` (`idTiposEstudio` ASC),
  CONSTRAINT `fk_Estudios_Nutricionistas1`
    FOREIGN KEY (`IdNutricionista`)
    REFERENCES `lbd2022g09nutricion`.`nutricionistas` (`idNutricionista`),
  CONSTRAINT `fk_Estudios_Pacientes1`
    FOREIGN KEY (`IdPaciente`)
    REFERENCES `lbd2022g09nutricion`.`pacientes` (`idPaciente`),
  CONSTRAINT `fk_estudios_tiposestudio1`
    FOREIGN KEY (`idTiposEstudio`)
    REFERENCES `lbd2022g09nutricion`.`tiposestudio` (`idTiposEstudio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- Precio podria ser añadido con un trigger cada vez que se crea un estudio con un tipoestudio
-- -----------------------------------------------------
-- Table `lbd2022g09nutricion`.`variables`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `lbd2022g09nutricion`.`variables` (
  `idVariable` INT NOT NULL AUTO_INCREMENT,
  `Variable` VARCHAR(100) NOT NULL,
  `Unidades` VARCHAR(20) NOT NULL,
  `Estado` CHAR(1) NOT NULL DEFAULT 'A',
  `ValorMinimoEsperado` INT NULL,
  `ValorMaximoEsperado` INT NULL,
  PRIMARY KEY (`idVariable`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;




-- -----------------------------------------------------
-- Table `lbd2022g09nutricion`.`variablestipoestudio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `lbd2022g09nutricion`.`variablestipoestudio` (
  `idTiposEstudio` INT NOT NULL,
  `idVariable` INT NOT NULL,
  PRIMARY KEY (`idTiposEstudio`, `idVariable`),
  INDEX `fk_TiposEstudio_has_Variables_Variables1_idx` (`idVariable` ASC),
  INDEX `fk_TiposEstudio_has_Variables_TiposEstudio1_idx` (`idTiposEstudio` ASC),
  CONSTRAINT `fk_TiposEstudio_has_Variables_TiposEstudio1`
    FOREIGN KEY (`idTiposEstudio`)
    REFERENCES `lbd2022g09nutricion`.`tiposestudio` (`idTiposEstudio`),
  CONSTRAINT `fk_TiposEstudio_has_Variables_Variables1`
    FOREIGN KEY (`idVariable`)
    REFERENCES `lbd2022g09nutricion`.`variables` (`idVariable`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `lbd2022g09nutricion`.`lineasestudio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `lbd2022g09nutricion`.`lineasestudio` (
CHECK (estudios_idTiposEstudio = variablestipoestudio_idTiposEstudio),
  `ValorMedido` FLOAT(12,4) NOT NULL,
  `idEstudios` INT NOT NULL, 
  `estudios_idTiposEstudio` INT NOT NULL,
  `variablestipoestudio_idTiposEstudio` INT NOT NULL,
  `idVariable` INT NOT NULL,
  PRIMARY KEY (`idEstudios`, `estudios_idTiposEstudio`, `idVariable`,`variablestipoestudio_idTiposEstudio`),
  INDEX `fk_lineasestudio_estudios1_idx` (`idEstudios` ASC, `estudios_idTiposEstudio` ASC),
  INDEX `fk_lineasestudio_variablestipoestudio1_idx` (`variablestipoestudio_idTiposEstudio` ASC, `idVariable` ASC),
  CONSTRAINT `fk_lineasestudio_estudios1`
    FOREIGN KEY (`idEstudios`,`estudios_idTiposEstudio`)
    REFERENCES `lbd2022g09nutricion`.`estudios` (`idEstudios`,`idTiposEstudio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_lineasestudio_variablestipoestudio1`
    FOREIGN KEY (`variablestipoestudio_idTiposEstudio` , `idVariable`)
    REFERENCES `lbd2022g09nutricion`.`variablestipoestudio` (`idTiposEstudio` , `idVariable`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- Implementacion de Checks
ALTER TABLE `lbd2022g09nutricion`.`personas` 
CHANGE COLUMN `Estado` `Estado` CHAR(1) NOT NULL DEFAULT 'A' CHECK (`Estado`= 'A' OR `Estado` = 'B') ENFORCED;

ALTER TABLE `lbd2022g09nutricion`.`tiposestudio` 
CHANGE COLUMN `Estado` `Estado` CHAR(1) NOT NULL DEFAULT 'A' CHECK (`Estado`= 'A' OR `Estado` = 'B') ENFORCED;

ALTER TABLE `lbd2022g09nutricion`.`tiposdoc` 
CHANGE COLUMN `Estado` `Estado` CHAR(1) NOT NULL DEFAULT 'A' CHECK (`Estado`= 'A' OR `Estado` = 'B') ENFORCED;

ALTER TABLE `lbd2022g09nutricion`.`variables` 
CHANGE COLUMN `Estado` `Estado` CHAR(1) NOT NULL DEFAULT 'A' CHECK (`Estado`= 'A' OR `Estado` = 'B') ENFORCED;

-- Creacion de indices para buscar por nombres de personas, DNI (o cualquiera sea el documento) y fechas
CREATE INDEX `idx_personas_Apellidos_Nombres`  ON `lbd2022g09nutricion`.`personas` (Apellidos, Nombres);
CREATE INDEX `idx_pacientes_Documento`  ON `lbd2022g09nutricion`.`pacientes` (Documento);
CREATE INDEX `idx_estudios_FechaAlta`  ON `lbd2022g09nutricion`.`estudios` (FechaAlta);
CREATE INDEX `idx_estudios_FechaComienzo`  ON `lbd2022g09nutricion`.`estudios` (FechaComienzo);
CREATE INDEX `idx_estudios_FechaFinalizacion`  ON `lbd2022g09nutricion`.`estudios` (FechaFinalizacion);

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


-- Orden de insercion -> TiposDoc > Personas > Pacientes y Nutricionistas > Variables y TiposEstudio -> VariablesTipoEstudio > Estudios >LineasEstudio
-- INSERCION TIPOSDOC

INSERT INTO `lbd2022g09nutricion`.`tiposdoc` (`idTiposDoc`,`TipoDoc`) VALUES
(1, 'DNI'), (4, 'CARNET EXT.'), (6, 'RUC'), (7, 'PASAPORTE') ,(11, 'P. NAC.'), (0, 'OTROS');
-- INSERT INTO `lbd2022g09nutricion`.`tiposdoc` (`idTiposDoc`,`TipoDoc`, `Estado` ) VALUES
-- (16, 'NOFUNC', 'C'); -- No deberia funcionar por mi restriccion check
-- SELECT * FROM `lbd2022g09nutricion`.`tiposdoc`; -- Verifico



-- INSERCION PERSONAS
INSERT INTO `lbd2022g09nutricion`.`personas`
(`Apellidos`,`Nombres`,`Usuario`,`Contrasenia`) VALUES
('Alvarez' ,'Lucas', 'N1' ,'PASSN1'), ('Anclaro' ,'Rodrigo', 'N2' ,'PASSN2'), ('Alvarado' ,'Gustavo', 'N3' ,'PASSN3'), ('Amarelo' ,'Ana', 'N4' ,'PASSN4')
, ('Amado' ,'Nicolas', 'N5' ,'PASSN5'), ('Acosta' ,'Lautaro', 'N6' ,'PASSN6'), ('Acosta' ,'Luciano', 'N7' ,'PASSN7'), ('Archiduque' ,'Fernando', 'N8' ,'PASSN8')
, ('Aquiles' ,'Tendon', 'N9' ,'PASSN9'), ('Alabado' ,'SeaDios', 'N10' ,'PASSN10'), ('Alvarez' ,'Jorge', 'N11' ,'PASSN11'), ('Amado' ,'Jesica', 'N12' ,'PASSN12')
, ('Aldaba' ,'Corralon', 'N13' ,'PASSN13'), ('Anasico' ,'Julieta', 'N14' ,'PASSN14'), ('Alvarez' ,'Horacio', 'N15' ,'PASSN15'), ('Alonso' ,'Fernando', 'N16' ,'PASSN16')
, ('Alcacer' ,'Paco', 'N17' ,'PASSN17'), ('Aguila' ,'Florencia', 'N18' ,'PASSN18'), ('Anclarens' ,'Rodrigo', 'N19' ,'PASSN19'), ('Alcacer' ,'Andres', 'N20' ,'PASSN20')  ;

INSERT INTO `lbd2022g09nutricion`.`nutricionistas`
(`Matricula`,`idNutricionista`) VALUES
('MUno' , 1), ('MDos' , 2), ('MTres' , 3), ('MCuatro' , 4), ('MCinco' , 5), ('MSeis' ,6), ('MSiete' ,7), ('MOcho' ,8), ('MNueve' , 9), ('MDiez' , 10),
('MUnoUno' , 11), ('MUnoDos' , 12), ('MUnoTres' , 13), ('MUnoCuatro' ,14), ('MUnoCinco' ,15), ('MUnoSeis' ,16), ('MUnoSiete' ,17), ('MUnoOcho' ,18),
('MUnoNueve' ,19), ('MVeinte' , 20);
-- SELECT * FROM `lbd2022g09nutricion`.`personas`;
-- SELECT * FROM `lbd2022g09nutricion`.`nutricionistas`;
-- TESTEO
-- INSERT INTO `lbd2022g09nutricion`.`personas` (`Apellidos`,`Nombres`,`Usuario`,`Contrasenia`) VALUES ('Prueba' ,'Nutricionista', 'NPrueba' ,'PASSP'); -- Falla por el check
-- INSERT INTO `lbd2022g09nutricion`.`personas` (idPersona, `Apellidos`,`Nombres`,`Contrasenia`) VALUES (115, 'Prueba' ,'Nutricionista', 'PRUEBADEF'); -- Default
-- DELETE FROM `lbd2022g09nutricion`.`personas` WHERE idPersona= 115 ;
-- INSERT INTO `lbd2022g09nutricion`.`nutricionistas`(`Matricula`,`idNutricionista`) VALUES ('NoHayPersona' , 46);
--



INSERT INTO `lbd2022g09nutricion`.`personas`
(`Apellidos`,`Nombres`,`Usuario`,`Contrasenia`) VALUES
('Berarducci' ,'Gianlucca', 'P1' ,'PASSP1'), ('Ballesteros' ,'Atilio', 'P2' ,'PASSP2'), ('Israilev' ,'Mateo', 'P3' ,'PASSP3'), ('Caldez' ,'Rosalba', 'P4' ,'PASSP4')
, ('Perelmut' ,'Valentina', 'P5' ,'PASSP5'), ('Faciano' ,'Enzo', 'N6' ,'PASSN6'), ('Latina' ,'Santiago', 'N7' ,'PASSN7'), ('Berreta' ,'Santiago', 'N8' ,'PASSN8')
, ('Gianotti' ,'Santiago', 'P9' ,'PASSP9'), ('Iriarte' ,'Josefina', 'N10' ,'PASSN10'), ('Brenan' ,'Pablo', 'N11' ,'PASSN11'), ('Messi' ,'Lionel', 'N12' ,'PASSN12')
, ('Higuain' ,'Gonzalo', 'P13' ,'PASSP13'), ('Maradona' ,'Diego', 'N14' ,'PASSN14'), ('Fernandez' ,'Nacho', 'N15' ,'PASSN15'), ('Funes Mori' ,'Ramiro', 'N16' ,'PASSN16')
, ('Gallardo' ,'Marcelo', 'P17' ,'PASSP17'), ('Riquelme' ,'Juan', 'N18' ,'PASSP18'), ('Ortega' ,'Ariel', 'N19' ,'PASSN19'), ('Batistuta' ,'Gabriel', 'N20' ,'PASSN20')  ;


INSERT INTO `lbd2022g09nutricion`.`pacientes`
(`Documento`,`ObraSocial`,`idTipoDoc`,`idPaciente`,`Sexo`,`FechaNacimiento`) VALUES
('1','ASUNT',1, 21,'Masculino','1992-01-03 23:00:00'), ('2','OSDE',1, 22,'Femenino','1989-01-03 06:00:00'), ('3', null ,1, 23,'Masculino','1999-01-03 02:00:00'), 
('4','PRENSA',4, 24,'Femenino','1993-01-03 18:00:00'), ('5','ASUNT',1, 25,'Masculino','2009-01-03 05:00:00'),('6',null,6, 26,'Femenino','1980-01-03 03:00:00'),
('7',null,1, 27,'Masculino','1995-01-03 10:00:00'), ('8','ASUNT',1, 28,'Femenino','2006-01-03 04:00:00'), ('9','OSDE',1, 29,'Masculino','2004-01-03 01:00:00'), 
('10','OSDE',7, 30,'Femenino','1989-01-03 09:00:00'), ('11','PRENSA',1, 31,'Masculino','2007-01-03 07:00:00'), ('12','PRENSA',1, 32,'Femenino','1968-01-03 04:00:00'), 
('13','OTRA',1, 33,'Masculino','1979-01-03 08:00:00'), ('14', NULL,1, 34,'Femenino','1999-01-03 15:00:00'), ('15','NULL',1, 35,'Masculino','1987-01-03 07:00:00'), 
('16',NULL,1, 36,'Femenino','2001-01-03 04:00:00'), ('17',NULL,1, 37,'Masculino','2002-01-03 06:00:00'), ('18','NULL',11, 38,'Femenino','2003-01-03 08:00:00'), 
('19','LAMISMAQUELAANTERIOR',1, 39,'Masculino','1997-02-05 08:00:00'), ('20','PRENSA',1, 40,'Femenino','1988-12-25 12:00:00');

-- TESTEO
-- INSERT INTO `lbd2022g09nutricion`.`pacientes` (`Documento`,`ObraSocial`,`idTipoDoc`,`idPaciente`) VALUES ('1','ASUNT',22, 115); -- tipoDoc errado
-- INSERT INTO `lbd2022g09nutricion`.`personas` (idPersona, `Apellidos`,`Nombres`,`Contrasenia`) VALUES (115, 'Prueba' ,'Nutricionista', 'PRUEBADEF');
-- INSERT INTO `lbd2022g09nutricion`.`pacientes` (`Documento`,`idTipoDoc`,`idPaciente`) VALUES ('1',7, 115); -- testeo default
-- DELETE FROM `lbd2022g09nutricion`.`pacientes` WHERE idPaciente= 115 ;
-- DELETE FROM `lbd2022g09nutricion`.`personas` WHERE idPersona= 115 ;
-- INSERT INTO `lbd2022g09nutricion`.`pacientes`(`Matricula`,`idNutricionista`) VALUES ('NoHayPersona' , 46);

-- SELECT * FROM `lbd2022g09nutricion`.`personas`;
-- SELECT * FROM `lbd2022g09nutricion`.`pacientes`;

-- INSERCION Variables y TiposEstudio -> VariablesTipoEstudio > 
INSERT INTO `lbd2022g09nutricion`.`variables`(`Variable`,`Unidades`,`Estado`) VALUES
('Var1','Unidad1','A'), ('Var2','Unidad3','A'),('Var3','Unidad3','B'),('Var4','Unidad4','A'),('Var5','Unidad2','B'),('Var6','Unidad1','A'),('Var7','Unidad1','B'),('Var8','Unidad3','A'),
('Var9','Unidad2','A'),('Var10','Unidad4','B'),('Var11','Unidad3','B'),('Var12','Unidad6','A'),('Var13','Unidad5','A'),('Var14','Unidad2','B'),('Var15','Unidad1','A'),('Var16','Unidad1','A');
INSERT INTO `lbd2022g09nutricion`.`variables`(`Variable`,`Unidades`) VALUES
('Var17','Unidad4'), ('Var18','Unidad1'),('Var19','Unidad2'),('Var20','Unidad3');
UPDATE `lbd2022g09nutricion`.`variables`
SET
`ValorMinimoEsperado` = 71,
`ValorMaximoEsperado` = 82 
WHERE `idVariable` = 1 ;

UPDATE `lbd2022g09nutricion`.`variables`
SET
`ValorMinimoEsperado` = 9,
`ValorMaximoEsperado` = 11 
WHERE `idVariable` = 2 ;

UPDATE `lbd2022g09nutricion`.`variables`
SET
`ValorMinimoEsperado` = 75,
`ValorMaximoEsperado` = 85 
WHERE `idVariable` = 3 ;

UPDATE `lbd2022g09nutricion`.`variables`
SET
`ValorMinimoEsperado` = 13,
`ValorMaximoEsperado` = 17 
WHERE `idVariable` = 4 ;

UPDATE `lbd2022g09nutricion`.`variables`
SET
`ValorMinimoEsperado` = 15,
`ValorMaximoEsperado` = 20 
WHERE `idVariable` = 7 ;

UPDATE `lbd2022g09nutricion`.`variables`
SET
`ValorMinimoEsperado` = 17,
`ValorMaximoEsperado` = 18 
WHERE `idVariable` = 10 ;

UPDATE `lbd2022g09nutricion`.`variables`
SET
`ValorMinimoEsperado` = 14,
`ValorMaximoEsperado` = 15 
WHERE `idVariable` = 11 ;
-- INSERT INTO `lbd2022g09nutricion`.`variables`(`Variable`,`Unidades`,`Estado`) VALUES('EstadoIncorrecto','Unidad1','C');
-- SELECT `variables`.`idVariable`, `variables`.`Variable`,    `variables`.`Unidades`,    `variables`.`Estado`FROM `lbd2022g09nutricion`.`variables`;


INSERT INTO `lbd2022g09nutricion`.`tiposestudio` (`TipoEstudio`,`Descripcion`,`Estado`,`Precio`) VALUES
('TipoEstudio1','Aqui va la Descripcion', 'A',500),('TipoEstudio2','Aqui va la Descripcion', 'B',1500), ('TipoEstudio3','Aqui va la Descripcion', 'A',1000), ('TipoEstudio4','Aqui va la Descripcion', 'A',1300),
('TipoEstudio5','Aqui va la Descripcion', 'B',500),('TipoEstudio6','Aqui va la Descripcion', 'A',1500),('TipoEstudio7','Aqui va la Descripcion', 'B',1000),('TipoEstudio8','Aqui va la Descripcion', 'A',1400),
('TipoEstudio9','Aqui va la Descripcion', 'A',500),('TipoEstudio10','Aqui va la Descripcion', 'A',1500),('TipoEstudio11','Aqui va la Descripcion', 'A',1000),('TipoEstudio12','Aqui va la Descripcion', 'B',1600);
INSERT INTO `lbd2022g09nutricion`.`tiposestudio` (`TipoEstudio`,`Descripcion`,`Precio`) VALUES
('TipoEstudio13','Aqui va la Descripcion',700), ('TipoEstudio14','Aqui va la Descripcion',800), ('TipoEstudio15','Aqui va la Descripcion',900), ('TipoEstudio16','Aqui va la Descripcion',1100);
INSERT INTO `lbd2022g09nutricion`.`tiposestudio` (`TipoEstudio`,`Precio`) VALUES
('TipoEstudio17',500),('TipoEstudio18',500);
INSERT INTO `lbd2022g09nutricion`.`tiposestudio` (`TipoEstudio` ,`Estado`,`Precio`) VALUES
('TipoEstudio19', 'B',2000),('TipoEstudio20', 'B',1800);

 SELECT * FROM `lbd2022g09nutricion`.`tiposestudio`;



INSERT INTO `lbd2022g09nutricion`.`variablestipoestudio`(`idTiposEstudio`,`idVariable`)VALUES
(1,1),(1,2),(1,3),(2,3),(2,4),(2,7),(3,1),(4,4),(5,5),(6,6),(7,7),(8,8),(9,9),(10,10),(11,11),(12,12),(13,13),(14,14),(15,15),(16,16),(17,17),(18,18),(19,19),(19,1),(20,1);


-- INSERCION Estudios >LineasEstudio
-- `idEstudios` INT NOT NULL,
--  `FechaAlta` YYYY-MM-DD,
--  `FechaConfirmacion` DATETIME NULL DEFAULT NULL,
--  `FechaComienzo` DATETIME NULL DEFAULT NULL,
--  `FechaFinalizacion` DATETIME NULL DEFAULT NULL,
--  `FechaBaja` DATETIME NULL DEFAULT NULL,
--  `IdNutricionista` INT NOT NULL,
--  `IdPaciente` INT NOT NULL,
-- `idTiposEstudio` INT NOT NULL,
INSERT INTO `lbd2022g09nutricion`.`estudios`(`idEstudios`,`FechaAlta`,`FechaConfirmacion`,`FechaComienzo`,`FechaFinalizacion`,`FechaBaja`,`IdNutricionista`,`IdPaciente`,`idTiposEstudio`)VALUES
(1,'2022-01-01 15:00:00','2022-01-01 15:00:00','2022-01-03 15:00:00','2022-01-10 15:00:00',NULL,1,21,1),
(2,'2022-01-01 15:00:00','2022-01-01 15:00:00','2022-01-03 15:00:00','2022-01-10 15:00:00',NULL,1,22,2),
(3,'2022-01-03 15:00:00',NULL,NULL,NULL,NULL,2,23,3),
(4,'2022-01-03 15:00:00',NULL,NULL,NULL,NULL,3,24,4),
(5,'2022-01-03 15:00:00',NULL,NULL,NULL,NULL,4,25,5),
(6,'2022-03-01 15:00:00','2022-03-05 15:00:00',NULL,NULL,NULL,5,26,6),
(7,'2022-03-01 15:00:00','2022-03-05 15:00:00',NULL,NULL,NULL,6,27,7),
(8,'2022-03-01 15:00:00','2022-03-06 15:00:00','2022-04-03 15:00:00','2022-04-10 15:00:00',NULL,7,28,10),
(9,'2022-03-01 15:00:00','2022-03-06 15:00:00','2022-04-03 15:00:00',NULL,NULL,8,29,10),
(10,'2022-03-01 15:00:00','2022-03-07 15:00:00','2022-04-03 15:00:00','2022-04-10 15:00:00',NULL,8,30,11),
(11,'2022-03-01 15:00:00','2022-03-07 15:00:00',NULL,NULL,NULL,9,30,1),
(12,'2022-03-01 15:00:00','2022-03-07 15:00:00','2022-04-03 15:00:00','2022-04-10 15:00:00',NULL,1,31,2),
(13,'2022-03-01 15:00:00','2022-03-07 15:00:00','2022-04-03 15:00:00','2022-04-10 15:00:00',NULL,2,32,3),
(14,'2022-03-01 15:00:00','2022-03-05 15:00:00',NULL,NULL,NULL,10,33,1),
(15,'2022-03-01 15:00:00','2022-03-05 15:00:00',NULL,NULL,NULL,16,30,5),
(16,'2022-03-01 15:00:00','2022-03-07 15:00:00','2022-04-03 15:00:00','2022-04-10 15:00:00',NULL,1,29,2),
(17,'2022-03-01 15:00:00','2022-03-05 15:00:00',NULL,NULL,NULL,15,34,3),
(18,'2022-03-01 15:00:00','2022-03-07 15:00:00','2022-04-03 15:00:00','2022-04-10 15:00:00',NULL,18,31,2),
(19,'2022-01-03 15:00:00',NULL,NULL,NULL,NULL,19,34,14),
(20,'2022-01-03 15:00:00',NULL,NULL,NULL,NULL,20,36,14);

-- SELECT * FROM `lbd2022g09nutricion`.`estudios`;
-- INSERCION >LineasEstudio
--  `idVariable` INT NOT NULL,
--  `idEstudios` INT NOT NULL,
--  `idTiposEstudio` INT NOT NULL,
--  `ValorMedido` FLOAT(12,4) NOT NULL,

INSERT INTO `lbd2022g09nutricion`.`lineasestudio` (idEstudios, idVariable, variablestipoestudio_idTiposEstudio, estudios_idTiposEstudio, ValorMedido) VALUES 
(1,1,1,1,70), (1,2,1,1,10), (1,3,1,1,75),
(2,3,2,2,83), (2,4,2,2,15), (2,7,2,2,15),
(8,10,10,10,17),
(9,10,10,10,16),
(10,11,11,11,13),
(12,3,2,2,25), (12,4,2,2,15), (12,7,2,2,15),
(13,1,3,3,80),
(16,3,2,2,90), (16,4,2,2,15), (16,7,2,2,10),
(18,3,2,2,85), (18,4,2,2,15), (18,7,2,2,25);

-- SELECT * FROM `lbd2022g09nutricion`.`LineasEstudio`;CREATE INDEX `idx_personas_Apellidos_Nombres`  ON `lbd2022g09nutricion`.`personas` (Apellidos, Nombres) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT

