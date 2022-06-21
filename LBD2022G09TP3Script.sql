-- Año: 2022
-- Grupo Nro: 9
-- Integrantes: Israilev Mateo y Matienzo Benjamín Alejandro
-- Tema: Base de datos Nutricionistas
-- Nombre del Esquema (LBD2022G09Nutricionistas)
-- Plataforma (SO + Versión): Windows 11 + 21H2
-- Motor y Versión: MySQL 8.0.28
-- GitHub Repositorio: LBD2022G09
-- GitHub Usuario: Korian99 y benja12matienzo

-- Triggers: implementar la lógica para llevar una auditoría para todos los apartados
-- siguientes de las operaciones de
-- 1. Creación
-- 2. Modificación
-- 3. Borrado

-- Auditoria Personas
DROP TABLE IF EXISTS auditoriapersonas;
CREATE TABLE IF NOT EXISTS `lbd2022g09nutricion`.`AuditoriaPersonas` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `idPersona` INT NOT NULL,
  `Apellidos` VARCHAR(30) NOT NULL,
  `Nombres` VARCHAR(30) NOT NULL,
  `Usuario` VARCHAR(30) NULL DEFAULT NULL,
  `Contrasenia` CHAR(32) NOT NULL,
  `Estado` CHAR(1) NOT NULL,
   `Tipo` CHAR(1) NOT NULL, -- tipo de operación (I: Inserción, B: Borrado, A: Modificación Añadido, C: Modificacion eliminado)
  `UsuarioBD` VARCHAR(45) NOT NULL,  
  `Maquina` VARCHAR(45) NOT NULL,  
  `Fecha` DATETIME NOT NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

DROP TRIGGER IF EXISTS `Trig_Personas_Insercion`;
DELIMITER //
CREATE TRIGGER `Trig_Personas_Insercion` 
AFTER INSERT ON `Personas` FOR EACH ROW
BEGIN
	INSERT INTO AuditoriaPersonas (idPersona, Apellidos, Nombres, Usuario, Contrasenia, Estado, Tipo, UsuarioBD, Maquina, Fecha) VALUES (
		NEW.idPersona,
		NEW.Apellidos, 
        NEW.Nombres,
        NEW.Usuario,
        NEW.Contrasenia,
        NEW.Estado,
		'I', 
		SUBSTRING_INDEX(USER(), '@', 1), 
		SUBSTRING_INDEX(USER(), '@', -1), 
		NOW()
  );
END //
DELIMITER ;

DROP TRIGGER IF EXISTS `Trig_Personas_Borrado`;
DELIMITER //
CREATE TRIGGER `Trig_Personas_Borrado` 
AFTER DELETE ON `Personas` FOR EACH ROW
BEGIN
	INSERT INTO AuditoriaPersonas (idPersona, Apellidos, Nombres, Usuario, Contrasenia, Estado, Tipo, UsuarioBD, Maquina, Fecha)VALUES (
		OLD.idPersona,
		OLD.Apellidos, 
        OLD.Nombres,
        OLD.Usuario,
        OLD.Contrasenia,
        OLD.Estado,    
		'B', 
		SUBSTRING_INDEX(USER(), '@', 1), 
		SUBSTRING_INDEX(USER(), '@', -1), 
		NOW()
	);
END //
DELIMITER ;

DROP TRIGGER IF EXISTS `Trig_Personas_Modificacion`;
DELIMITER //
CREATE TRIGGER `Trig_Personas_Modificacion` 
AFTER UPDATE ON `Personas` FOR EACH ROW
BEGIN
	-- valores viejos
	INSERT INTO AuditoriaPersonas (idPersona, Apellidos, Nombres, Usuario, Contrasenia, Estado, Tipo, UsuarioBD, Maquina, Fecha) VALUES (
		OLD.idPersona,
		OLD.Apellidos, 
        OLD.Nombres,
        OLD.Usuario,
        OLD.Contrasenia,
        OLD.Estado,    
		'C', 
		SUBSTRING_INDEX(USER(), '@', 1), 
		SUBSTRING_INDEX(USER(), '@', -1), 
		NOW()
	);
    -- valores nuevos
	INSERT INTO AuditoriaPersonas (idPersona, Apellidos, Nombres, Usuario, Contrasenia, Estado, Tipo, UsuarioBD, Maquina, Fecha)VALUES (
		NEW.idPersona,
		NEW.Apellidos, 
        NEW.Nombres,
        NEW.Usuario,
        NEW.Contrasenia,
        NEW.Estado,
		'A', 
		SUBSTRING_INDEX(USER(), '@', 1), 
		SUBSTRING_INDEX(USER(), '@', -1), 
		NOW()
	);    
END //
DELIMITER ;
-- Auditoria Nutricionistas
DROP TABLE IF EXISTS AuditoriaNutricionistas;
CREATE TABLE IF NOT EXISTS `lbd2022g09nutricion`.`AuditoriaNutricionistas` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `idNutricionista` INT NOT NULL,
  `Matricula` VARCHAR(15) NOT NULL,
  `Tipo` CHAR(1) NOT NULL, -- tipo de operación (I: Inserción, B: Borrado, A: Modificación Añadido, C: Modificacion eliminado)
  `Usuario` VARCHAR(45) NOT NULL,  
  `Maquina` VARCHAR(45) NOT NULL,  
  `Fecha` DATETIME NOT NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;
DROP TRIGGER IF EXISTS `Trig_Nutricionistas_Insercion`;
DELIMITER //
CREATE TRIGGER `Trig_Nutricionistas_Insercion` 
AFTER INSERT ON `Nutricionistas` FOR EACH ROW
BEGIN
	INSERT INTO AuditoriaNutricionistas(idNutricionista, Matricula, Tipo, Usuario, Maquina, Fecha) VALUES (
		NEW.idNutricionista,
		NEW.Matricula, 
		'I', 
		SUBSTRING_INDEX(USER(), '@', 1), 
		SUBSTRING_INDEX(USER(), '@', -1), 
		NOW()
  );
END //
DELIMITER ;

DROP TRIGGER IF EXISTS `Trig_Nutricionistas_Borrado`;
DELIMITER //
CREATE TRIGGER `Trig_Nutricionistas_Borrado` 
AFTER DELETE ON `Nutricionistas` FOR EACH ROW
BEGIN
	INSERT INTO AuditoriaNutricionistas (idNutricionista, Matricula, Tipo, Usuario, Maquina, Fecha)VALUES (
		OLD.idNutricionista,
		OLD.Matricula, 
		'B', 
		SUBSTRING_INDEX(USER(), '@', 1), 
		SUBSTRING_INDEX(USER(), '@', -1), 
		NOW()
	);
END //
DELIMITER ;

DROP TRIGGER IF EXISTS `Trig_Nutricionistas_Modificacion`;
DELIMITER //
CREATE TRIGGER `Trig_Nutricionistas_Modificacion` 
AFTER UPDATE ON `Nutricionistas` FOR EACH ROW
BEGIN
	-- valores viejos
	INSERT INTO AuditoriaNutricionistas(idNutricionista, Matricula, Tipo, Usuario, Maquina, Fecha) VALUES (
		OLD.idNutricionista,
		OLD.Matricula,    
		'C', 
		SUBSTRING_INDEX(USER(), '@', 1), 
		SUBSTRING_INDEX(USER(), '@', -1), 
		NOW()
	);
    -- valores nuevos
	INSERT INTO AuditoriaNutricionistas(idNutricionista, Matricula, Tipo, Usuario, Maquina, Fecha) VALUES (
		NEW.idNutricionista,
		NEW.Matricula, 
		'A', 
		SUBSTRING_INDEX(USER(), '@', 1), 
		SUBSTRING_INDEX(USER(), '@', -1), 
		NOW()
	);    
END //
DELIMITER ;


-- 4. Creación de una persona nutricionista (en las 2 tablas).

DROP PROCEDURE IF EXISTS CrearNutricionista;
DELIMITER //
CREATE PROCEDURE CrearNutricionista(pID INT, pApellidos VARCHAR(30), pNombres VARCHAR(30), pUsuario VARCHAR(30), pContrasenia CHAR(32), pEstado CHAR(1), pMatricula VARCHAR(15),OUT mensaje VARCHAR(100))
SALIR:BEGIN  
	IF (pID IS NULL) OR (pApellidos IS NULL) OR (pNombres IS NULL) OR (pUsuario IS NULL) OR (pContrasenia IS NULL) OR (pMatricula IS NULL) THEN
		SET mensaje = 'Error en los datos del nutricionista';
	LEAVE SALIR;
	ELSEIF EXISTS (SELECT * FROM Personas WHERE idPersona = pID) THEN
		SET mensaje =  'Ya existe una persona con ese id';
	LEAVE SALIR;
	ELSEIF EXISTS (SELECT * FROM Personas WHERE Usuario = pUsuario) THEN
		SET mensaje =  'Ya existe una persona con ese nombre de usuario';
	LEAVE SALIR;
	ELSEIF EXISTS (SELECT * FROM Nutricionistas WHERE Matricula = pMatricula) THEN
		SET mensaje =  'Ya existe un nutricionista con esa matricula';
	LEAVE SALIR;
	ELSE
		START TRANSACTION;
			INSERT INTO Personas (IdPersona, Apellidos, Nombres, Usuario, Contrasenia, Estado)VALUES (pID, pApellidos, pNombres, pUsuario, pContrasenia, pEstado);
			INSERT INTO Nutricionistas (idNutricionista, Matricula)VALUES (pID, pMatricula);
		COMMIT;		
    END IF;
END //
DELIMITER ;

CALL CrearNutricionista(67, "Apellidos","Nombres", "CarlitosElCarlos", "Contrasenia", "A", "MatriculaNuevo", @Mensaje1);
SELECT @mensaje1;
CALL CrearNutricionista(67, null,"Nombres", "CarlitosElCarlos", "Contrasenia", "A", "MatriculaNuevo", @Mensaje2);
SELECT @mensaje2;
CALL CrearNutricionista(68, "Apellidos","Nombres", "CarlitosElCarlos", "Contrasenia", "A", "MatriculaNuevo", @Mensaje3);
SELECT @mensaje3;
CALL CrearNutricionista(69, "Apellidos","Nombres", "OtroUsuarioQuenoestausado", "Contrasenia", "A", "MUno", @Mensaje4);
SELECT @mensaje4;

-- 5. Modificación de una persona nutricionista (en las 2 tablas).

DROP PROCEDURE IF EXISTS ModificarNutricionista;
DELIMITER //
CREATE PROCEDURE ModificarNutricionista(pID INT, pApellidos VARCHAR(30), pNombres VARCHAR(30), pUsuario VARCHAR(30), pContrasenia CHAR(32), pEstado CHAR(1), pMatricula VARCHAR(15), OUT mensaje VARCHAR(100))
SALIR:BEGIN  
	IF EXISTS (SELECT * FROM Personas WHERE Usuario = pUsuario) THEN
		SET mensaje =  'Ya existe una persona con ese nombre de usuario';
	LEAVE SALIR;
	ELSEIF EXISTS (SELECT * FROM Nutricionistas WHERE Matricula = pMatricula) THEN
		SET mensaje =  'Ya existe un nutricionista con esa matricula';
	LEAVE SALIR;
    ELSEIF NOT EXISTS (SELECT * FROM Nutricionistas WHERE idNutricionista = pID) THEN
		SET mensaje =  'No existe este nutricionista';
	LEAVE SALIR;
	ELSE
	START TRANSACTION;
		IF (pApellidos IS NOT NULL) THEN
		UPDATE Personas SET Apellidos=pApellidos WHERE idPersona = pID;
        END IF;
        IF (pNombres IS NOT NULL) THEN
		UPDATE Personas SET Nombres=pNombres WHERE idPersona = pID;
        END IF;
        IF (pUsuario IS NOT NULL) THEN
		UPDATE Personas SET Usuario=pUsuario WHERE idPersona = pID;
        END IF;
        IF (pContrasenia IS NOT NULL) THEN
		UPDATE Personas SET Contrasenia=pContrasenia WHERE idPersona = pID;
        END IF;
        IF (pEstado IS NOT NULL) THEN
		UPDATE Personas SET Estado=pEstado WHERE idPersona = pID;
        END IF;
        IF (pMatricula IS NOT NULL) THEN
		UPDATE Nutricionistas SET Matricula=pMatricula WHERE idNutricionista = pID;
        END IF;
	COMMIT;
    END IF;
END //
DELIMITER ;

CALL ModificarNutricionista(20, "Apellidos","Nombres", "C293", "Contrasenia", "A", "OtraMatricula", @Mensaje1);
SELECT @mensaje1;
CALL ModificarNutricionista(20, "Apellidos","Nombres", "CarlitosElCarlos", "Contrasenia", "A", "MatriculaNuevo", @Mensaje2);
SELECT @mensaje2;
CALL ModificarNutricionista(68, "Apellidos","Nombres", "C897", "Contrasenia", "A", "MatriculaNuevo", @Mensaje3);
SELECT @mensaje3;
CALL ModificarNutricionista(988, "Apellidos","Nombres", "OtroUsuarioQuenoestausado", "Contrasenia", "A", "ASD", @Mensaje4);
SELECT @mensaje4;
-- 6. Borrado de una persona nutricionista (en las 2 tablas).

DROP PROCEDURE IF EXISTS BorradoNutricionista;
DELIMITER //
CREATE PROCEDURE BorradoNutricionista(pID INT, OUT mensaje VARCHAR(100))
SALIR:BEGIN  
	IF NOT EXISTS (SELECT * FROM Nutricionistas WHERE idNutricionista = pID) THEN
		SET mensaje =  'No existe este nutricionista';
	LEAVE SALIR;
    ELSEIF EXISTS (SELECT * FROM Estudios WHERE idNutricionista = pID) THEN
		SET mensaje =  'El nutricionista tiene estudios';
	LEAVE SALIR;
    ELSE
	START TRANSACTION;
		DELETE FROM `lbd2022g09nutricion`.`nutricionistas` WHERE idNutricionista=pID;
		DELETE FROM `lbd2022g09nutricion`.`personas` WHERE idPersona=pID;
	COMMIT;
    END IF;
END //
DELIMITER ;
CALL BorradoNutricionista(67, @Mensaje1);
SELECT @mensaje1;
CALL BorradoNutricionista(67, @Mensaje2);
SELECT @mensaje2;
CALL BorradoNutricionista(69, @Mensaje3);
SELECT @mensaje3;
CALL BorradoNutricionista(1, @Mensaje4);
SELECT @mensaje4;

-- 7. Búsqueda de una persona nutricionista.

DROP PROCEDURE IF EXISTS BusquedaNutricionista;
DELIMITER //
CREATE PROCEDURE BusquedaNutricionista(pID INT, OUT mensaje VARCHAR(100))
SALIR:BEGIN 
	IF NOT EXISTS (SELECT * FROM Nutricionistas WHERE idNutricionista = pID) THEN
		SET mensaje =  'No existe este nutricionista';
	LEAVE SALIR;
    ELSE
	SELECT idPersona, Apellidos, Nombres, Usuario, Contrasenia, Estado, Matricula FROM Nutricionistas JOIN Personas
    ON idNutricionista = idPersona WHERE idNutricionista = pID;
    END IF;
END //
DELIMITER ;
CALL BusquedaNutricionista(1, @Mensaje1);
CALL BusquedaNutricionista(67, @Mensaje2);
SELECT @mensaje2;
CALL BusquedaNutricionista(69, @Mensaje3);
SELECT @mensaje3;
CALL BusquedaNutricionista(55, @Mensaje4);
SELECT @mensaje4;
-- 8. Listado de estudios y sus líneas de estudio, filtrado y ordenado por el criterio que
-- considere más adecuado.
DROP PROCEDURE IF EXISTS ListadoEstudios;
DELIMITER //
CREATE PROCEDURE ListadoEstudios(FechaInicio DATETIME, FechaFin DATETIME)
BEGIN  
	IF FechaInicio IS NOT NULL AND FechaFin IS NOT NULL THEN
	SELECT * FROM Estudios JOIN LineasEstudio
    ON Estudios.idEstudios = LineasEstudio.idEstudios AND Estudios.idTiposEstudio = LineasEstudio.estudios_idTiposEstudio
    WHERE FechaComienzo BETWEEN fechaInicio AND fechaFin ORDER BY fechaComienzo;
    ELSEIF FechaInicio IS NULL AND FechaFin IS NOT NULL THEN
	SELECT * FROM Estudios JOIN LineasEstudio
    ON Estudios.idEstudios = LineasEstudio.idEstudios AND Estudios.idTiposEstudio = LineasEstudio.estudios_idTiposEstudio
    WHERE FechaComienzo < fechaFin ORDER BY fechaComienzo;
    ELSEIF FechaInicio IS NOT NULL AND FechaFin IS NULL THEN
	SELECT * FROM Estudios JOIN LineasEstudio
    ON Estudios.idEstudios = LineasEstudio.idEstudios AND Estudios.idTiposEstudio = LineasEstudio.estudios_idTiposEstudio
    WHERE FechaComienzo > fechaInicio ORDER BY fechaComienzo;
    ELSEIF FechaInicio IS NULL AND FechaFin IS NULL THEN
	SELECT * FROM Estudios JOIN LineasEstudio
    ON Estudios.idEstudios = LineasEstudio.idEstudios AND Estudios.idTiposEstudio = LineasEstudio.estudios_idTiposEstudio
    ORDER BY fechaComienzo;
    END IF;
END //
DELIMITER ;
CALL ListadoEstudios('2022-02-03 15:00:00', '2022-04-03 15:00:00');
CALL ListadoEstudios('2022-02-03 15:00:00', null);
CALL ListadoEstudios(null, '2022-04-03 15:00:00');
CALL ListadoEstudios(null, null);

-- 9. Dado un paciente, listar todas los estudios finalizados que se le hicieron entre un
-- rango de fechas.
DROP PROCEDURE IF EXISTS EstudiosFinalizadosPaciente;

DELIMITER //
CREATE PROCEDURE EstudiosFinalizadosPaciente(pID INT, fechaInicio DATETIME, fechaFin DATETIME, OUT mensaje VARCHAR(100))
SALIR:BEGIN  
	IF NOT EXISTS (SELECT * FROM Pacientes WHERE idPaciente = pID) THEN
		SET mensaje =  'No existe este paciente';
	LEAVE SALIR;
    ELSEIF NOT EXISTS (SELECT * FROM Estudios WHERE idPaciente = pID) THEN
		SET mensaje =  'No tiene estudios este paciente';
	LEAVE SALIR;
    ELSE
	START TRANSACTION;
		IF FechaInicio IS NOT NULL AND FechaFin IS NOT NULL THEN
			SELECT * FROM Estudios WHERE FechaFinalizacion BETWEEN fechaInicio AND fechaFin ORDER BY fechaComienzo;
		ELSEIF FechaInicio IS NULL AND FechaFin IS NOT NULL THEN
			SELECT * FROM Estudios WHERE FechaFinalizacion < fechaFin ORDER BY fechaComienzo;
		ELSEIF FechaInicio IS NOT NULL AND FechaFin IS NULL THEN
			SELECT * FROM Estudios WHERE FechaFinalizacion > fechaInicio ORDER BY fechaComienzo;
		ELSEIF FechaInicio IS NULL AND FechaFin IS NULL THEN
			SELECT * FROM Estudios;
    END IF;
	COMMIT;
    END IF;
END //
DELIMITER ;
CALL EstudiosFinalizadosPaciente(50,'2022-02-03 15:00:00', '2022-04-03 15:00:00',@mensaje1);
SELECT @mensaje1;
CALL EstudiosFinalizadosPaciente(21,'2022-02-03 15:00:00', null,@mensaje);
CALL EstudiosFinalizadosPaciente(25,null, '2022-04-03 15:00:00',@mensaje);
CALL EstudiosFinalizadosPaciente(38,null, null,@mensaje2);
SELECT @mensaje2;

-- 10. Realizar un procedimiento almacenado que obtenga como parámetro el estado
-- de los turnos indicado en la descripción general y devuelva el listado de los turnos
-- para dicho estado.
DROP PROCEDURE IF EXISTS TurnosPacientes;

DELIMITER //
CREATE PROCEDURE TurnosPacientes(Estado VARCHAR(10), OUT mensaje VARCHAR(100)) 
-- Estados posibles:  Disponible, Activo, Demorado, Baja
-- Disponible no es considerado porque son todos los turnos que no fueron guardados
BEGIN  
	START TRANSACTION;
    IF Estado = "Activo" THEN
		SELECT * FROM Estudios 
        WHERE  FechaComienzo < NOW() AND FechaBaja IS NULL;
	ELSEIF Estado = "Demorado" THEN
		SELECT * FROM Estudios 
        WHERE  FechaComienzo BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL 5 MINUTE) AND FechaBaja IS NULL;
    ELSEIF Estado = "Caducado" THEN
		SELECT * FROM Estudios 
        WHERE FechaComienzo > DATE_ADD(NOW(), INTERVAL 5 MINUTE) ;
	ELSE 
    SET mensaje =  'El estado no existe, pruebe Activo, Demorado o Caducado';
    END IF;
	COMMIT;
END //
DELIMITER ;

CALL TurnosPacientes("Activo",@mensaje);
CALL TurnosPacientes("Demorado",@mensaje);
CALL TurnosPacientes("Caducado",@mensaje);
CALL TurnosPacientes("Otra cosa",@mensaje);
SELECT @mensaje;


