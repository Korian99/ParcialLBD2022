-- Año: 2022
-- Grupo Nro: 9
-- Integrantes: Israilev Mateo y Matienzo Benjamín Alejandro
-- Tema: Base de datos Nutricionistas
-- Nombre del Esquema (LBD2022G09Nutricionistas)
-- Plataforma (SO + Versión): Windows 11 + 21H2
-- Motor y Versión: MySQL 8.0.28
-- GitHub Repositorio: LBD2022G09
-- GitHub Usuario: Korian99 y benja12matienzo


-- De acuerdo a lo presentado en el práctico anterior, realizar las siguientes consultas:
-- 1. Dada una paciente, mostrar sus estudios entre un rango de fechas. Mostrar la fecha, hora
-- inicio y hora de finalización del estudio. Ordenar según la fecha en orden cronológico
-- inverso, y luego según la hora de inicio en orden cronológico.
-- CORREGIDO

SET @FechaInicial :='2021-03-03 14:00:00', @FechaFinal := '2022-05-10 16:00:00';

SELECT 
estudios.FechaComienzo, 
estudios.FechaFinalizacion 
FROM estudios 
WHERE (estudios.FechaComienzo BETWEEN @FechaInicial AND @FechaFinal) AND
(estudios.FechaFinalizacion BETWEEN @FechaInicial AND @FechaFinal)
ORDER BY cast(FechaComienzo as DATE) DESC, cast(FechaComienzo as TIME) ASC;

-- 2. Realizar un listado de todos los nutricionistas. Mostrar apellido, nombre, dni y cuit.
-- Ordenar el listado alfabéticamente por apellido.

SELECT
personas.Apellidos,
personas.Nombres,
nutricionistas.idNutricionista,
nutricionistas.Matricula
FROM 
`lbd2022g09nutricion`.`personas` 
JOIN `lbd2022g09nutricion`.`nutricionistas`
ON nutricionistas.idNutricionista = personas.idPersona
ORDER BY personas.Apellidos ASC;


-- 3. Dada una nutricionista, mostrar todos sus estudios realizados, mostrando el detalle de los
-- mismos (lineas estudios y variables)
-- CORREGIDO

SELECT
`lbd2022g09nutricion`.`estudios`.idEstudios,
`lbd2022g09nutricion`.`variables`.Variable,
`lbd2022g09nutricion`.`LineasEstudio`.ValorMedido,
`lbd2022g09nutricion`.`variables`.Unidades
FROM 
`lbd2022g09nutricion`.`estudios`
JOIN `lbd2022g09nutricion`.`LineasEstudio` 
ON `lbd2022g09nutricion`.`estudios`.idEstudios = `lbd2022g09nutricion`.`LineasEstudio`.idEstudios 
AND `lbd2022g09nutricion`.`estudios`.idTiposEstudio = `lbd2022g09nutricion`.`LineasEstudio`.estudios_idTiposEstudio
JOIN `lbd2022g09nutricion`.`variablestipoestudio`
ON `lbd2022g09nutricion`.`LineasEstudio`.idVariable = `lbd2022g09nutricion`.`variablestipoestudio`.idVariable
AND `lbd2022g09nutricion`.`LineasEstudio`.variablestipoestudio_idTiposEstudio = `lbd2022g09nutricion`.`variablestipoestudio`.idTiposEstudio
JOIN `lbd2022g09nutricion`.`variables`
ON `lbd2022g09nutricion`.`variablestipoestudio`.idVariable = `lbd2022g09nutricion`.`variables`.idVariable
WHERE `lbd2022g09nutricion`.`estudios`.IdNutricionista=1;

-- 4. Mostrar el total recaudado por los estudios entre un rango de fechas.
-- deberia ser estudio CORREGIDO
SET @FechaInicial :='2022-01-01', @FechaFinal := '2022-03-03';
SELECT SUM(estudios.Precio) FROM  
tiposestudio JOIN estudios
ON tiposestudio.idTiposEstudio = estudios.idTiposEstudio
WHERE `lbd2022g09nutricion`.`estudios`.`FechaComienzo` BETWEEN @FechaInicial  AND @FechaFinal;

-- 5. Hacer un ranking con los pacientes que más estudios realizaron entre un rango de
-- fechas. Mostrar apellido y nombre del pacientes y cantidad de estudios.
-- Corregido
SET @FechaInicial :='2022-01-01', @FechaFinal := '2022-04-01';

SELECT
personas.idPersona,
personas.Nombres,
personas.Apellidos,
COUNT(FechaFinalizacion) AS CdadEstudios
FROM 
`lbd2022g09nutricion`.estudios join `lbd2022g09nutricion`.pacientes 
ON estudios.idPaciente = pacientes.idPaciente
join `lbd2022g09nutricion`.personas
ON pacientes.idPaciente = personas.idPersona
WHERE estudios.FechaFinalizacion BETWEEN @FechaInicial AND @FechaFinal
GROUP BY estudios.idPaciente, personas.Nombres, personas.Apellidos
ORDER BY CdadEstudios DESC;


SELECT * FROM `lbd2022g09nutricion`.estudios;

-- 6. Hacer un ranking con los tipo de estudios que tuvieron más turnos entre un ranking de
-- fechas. Mostrar el nombre del mismo y la cantidad de turnos.
SET @FechaInicial :='2000-01-01', @FechaFinal := '2025-04-01';

SELECT 
TipoEstudio,
COUNT(estudios.idTiposEstudio) AS Turnos
FROM
estudios JOIN tiposestudio
ON estudios.idTiposEstudio = tiposestudio.idTiposEstudio
WHERE FechaComienzo BETWEEN @FechaInicial AND @FechaFinal
GROUP BY estudios.idTiposEstudio, TipoEstudio
ORDER BY estudios.idTiposEstudio;



-- 7. Hacer un ranking con las variables de estudio que salen por fuera de los valores
-- esperados más frecuentemente en un rango de fecha
SET @FechaInicial :='2022-02-03 15:00:00', @FechaFinal := '2022-04-03 15:00:00';

SELECT variables.idVariable, Variable, Unidades, COUNT(DISTINCT ValorMedido) AS Turnos
FROM variables JOIN variablestipoestudio 
ON variables.idVariable = variablestipoestudio.idVariable
JOIN lineasestudio 
ON variablestipoestudio.idVariable = lineasestudio.idVariable AND variablestipoestudio.idTiposEstudio = lineasestudio.variablestipoestudio_idTiposEstudio
JOIN estudios
ON estudios.idEstudios = lineasestudio.idEstudios AND estudios.idTiposEstudio = LineasEstudio.estudios_idTiposEstudio
WHERE (FechaComienzo BETWEEN @FechaInicial AND @FechaFinal) AND
(ValorMedido NOT BETWEEN variables.ValorMinimoEsperado AND variables.ValorMaximoEsperado)
GROUP BY lineasestudio.idVariable, Variable, Unidades
ORDER BY Turnos DESC;



-- 8. Crear una vista con la funcionalidad del apartado 2.
DROP VIEW if exists Nutricionistas_vista;

CREATE VIEW Nutricionistas_vista AS
SELECT
personas.Apellidos,
personas.Nombres,
nutricionistas.idNutricionista,
nutricionistas.Matricula
FROM 
`lbd2022g09nutricion`.`personas` 
JOIN `lbd2022g09nutricion`.`nutricionistas`
ON nutricionistas.idNutricionista = personas.idPersona
ORDER BY personas.Apellidos ASC;

-- 9. Crear una copia de la tabla “Estudios”, llamada EstudiosJSON, que además tenga una
-- columna del tipo JSON para guardar las líneas de estudio. Llenar esta tabla con los mismos
-- datos del TP1 y resolver la consulta en la que dado un estudio, muestra los datos del mismo
-- juntos con sus líneas
DROP TABLE if exists estudiosJSON;

CREATE TABLE IF NOT EXISTS `lbd2022g09nutricion`.`estudiosJSON`
SELECT * FROM estudios;
ALTER TABLE `lbd2022g09nutricion`.`estudiosjson` 
ADD COLUMN `lineasestudio` JSON NULL AFTER `idTiposEstudio`,
ADD PRIMARY KEY (`idEstudios`, `idTiposEstudio`);

UPDATE estudiosjson
SET estudiosjson.lineasestudio = '[{"idVariable": 1, "ValorMedido":70}, {"idVariable": 2, "ValorMedido":10},{"idVariable": 3, "ValorMedido":75}]'
WHERE idEstudios= 1 AND idTiposEstudio = 1;
UPDATE estudiosjson
SET estudiosjson.lineasestudio = '[{"idVariable": 3, "ValorMedido":83}, {"idVariable": 4, "ValorMedido":15},{"idVariable": 7, "ValorMedido":15}]'
WHERE idEstudios= 2 AND idTiposEstudio = 2;
UPDATE estudiosjson
SET estudiosjson.lineasestudio = '[{"idVariable": 3, "ValorMedido":25}, {"idVariable": 4, "ValorMedido":15},{"idVariable": 7, "ValorMedido":15}]'
WHERE idEstudios= 12 AND idTiposEstudio = 2;
UPDATE estudiosjson
SET estudiosjson.lineasestudio = '[{"idVariable": 3, "ValorMedido":90}, {"idVariable": 4, "ValorMedido":15},{"idVariable": 7, "ValorMedido":10}]'
WHERE idEstudios= 16 AND idTiposEstudio = 2;
UPDATE estudiosjson
SET estudiosjson.lineasestudio = '[{"idVariable": 3, "ValorMedido":85}, {"idVariable": 4, "ValorMedido":15},{"idVariable": 7, "ValorMedido":25}]'
WHERE idEstudios= 18 AND idTiposEstudio = 2;

UPDATE estudiosjson
SET estudiosjson.lineasestudio = '[{"idVariable": 10, "ValorMedido":17}]'
WHERE idEstudios= 8 AND idTiposEstudio = 10;
UPDATE estudiosjson
SET estudiosjson.lineasestudio = '[{"idVariable": 10, "ValorMedido":16}]'
WHERE idEstudios= 9 AND idTiposEstudio = 10;
UPDATE estudiosjson
SET estudiosjson.lineasestudio = '[{"idVariable": 11, "ValorMedido":13}]'
WHERE idEstudios= 10 AND idTiposEstudio = 11;
UPDATE estudiosjson
SET estudiosjson.lineasestudio = '[{"idVariable": 1, "ValorMedido":80}]'
WHERE idEstudios= 13 AND idTiposEstudio = 3;


SELECT idEstudios, FechaAlta, FechaConfirmacion, FechaComienzo, FechaFinalizacion, FechaBaja, IdNutricionista, IdPaciente, Abonado, Precio, idTiposEstudio, TablaJSON.* FROM estudiosjson,
JSON_TABLE(lineasestudio, '$[*]' COLUMNS(
idVariable INT PATH '$.idVariable' DEFAULT '111' ON EMPTY  DEFAULT '222' ON ERROR ,
ValorMedido INT PATH '$.ValorMedido'DEFAULT '111' ON EMPTY  DEFAULT '222' ON ERROR)
) AS TablaJSON;

-- 10: Realizar una vista que considere importante para su modelo. También dejar escrito el
-- enunciado de la misma.

-- Vista que muestra todos los nutricionistas con sus respectivos pacientes
DROP VIEW if exists PacientesSegunNutricionista;

CREATE VIEW PacientesSegunNutricionista (idNutricionista, idPaciente, idTipoDoc, Documento, Sexo, Apellidos, Nombres, Estado, CdadEstudiosActuales)
AS
	SELECT idNutricionista, pacientes.idPaciente, idTipoDoc, Documento, Sexo, Apellidos, Nombres, Estado, COUNT(estudios.idEstudios) FROM
    estudios JOIN pacientes JOIN personas ON estudios.idPaciente = pacientes.idPaciente AND pacientes.idPaciente = personas.idPersona
    GROUP BY pacientes.idPaciente;
SELECT * FROM PacientesSegunNutricionista;    
