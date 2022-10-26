USE PLATZY_CURSO_SQL_PRACTICO;

SELECT ROW_NUMBER() OVER(ORDER BY id) AS row_id, *
FROM alumnos
ORDER BY id OFFSET (
SELECT COUNT(*)/2 FROM alumnos) ROWS 



SELECT * FROM(
	SELECT ROW_NUMBER() OVER(ORDER BY id) AS row_id, *
	FROM alumnos
)AS alumnos_with_row_num
WHERE row_id IN (1,5,10,12,15,20)


SELECT * FROM alumnos
WHERE id IN	(
	SELECT id FROM alumnos WHERE tutor_id = 30
)

SELECT * FROM alumnos
WHERE id NOT IN	(
	SELECT id FROM alumnos WHERE tutor_id = 30
)

	
SELECT DATEPART(YEAR, fecha_incorporacion) AS anio_incorporacion,
	DATEPART(MONTH, fecha_incorporacion) AS mes_incorporacion,
	DATEPART(DAY, fecha_incorporacion) AS dia_incorporacion,
	DATEPART(HOUR, fecha_incorporacion) AS hora_incorporacion,
	DATEPART(MINUTE, fecha_incorporacion) AS minuto_incorporacion,
	DATEPART(SECOND, fecha_incorporacion) AS segundo_incorporacion
FROM alumnos



SELECT * FROM alumnos
WHERE (DATEPART(YEAR, fecha_incorporacion)) = 2019


SELECT * FROM(
	SELECT * , DATEPART(YEAR, fecha_incorporacion) AS anio_incorporacion
	FROM alumnos
) AS tb_alumnos_with_years
WHERE anio_incorporacion = 2020


SELECT * FROM(
	SELECT * , SUM(colegiatura) OVER(ORDER BY carrera_id, tutor_id) AS suma_colegiatura
	FROM alumnos	
) AS tb_alumnos_with_colegiatura



SELECT * FROM(
	SELECT * , DATEPART(YEAR, fecha_incorporacion) AS anio_incorporacion,
	DATEPART(MONTH, fecha_incorporacion) AS mes_incorporacion
	FROM alumnos
) AS tb_alumnos_with_years
WHERE anio_incorporacion = 2018 AND mes_incorporacion = 5


SELECT  CONCAT(CONVERT(VARCHAR(50),nombre),' ',CONVERT(VARCHAR(50),apellido)), COUNT(*)
FROM alumnos
GROUP BY nombre, apellido

SELECT * FROM alumnos