USE PLATZY_CURSO_SQL_PRACTICO;

-- SELECCIONAR LOS N PRIMEROS
SELECT TOP 1 * FROM alumnos 


SELECT *
FROM (
	SELECT ROW_NUMBER() OVER(ORDER BY id) AS row_id, *
	FROM alumnos
) AS alumnos_with_row_num

-- SELECCIONAR LOS 5 PRIMEROS
SELECT TOP 5 * FROM alumnos 

SELECT *
FROM (
	SELECT ROW_NUMBER() OVER(ORDER BY id) AS row_id, *
	FROM alumnos
) AS alumnos_with_row_num
WHERE row_id BETWEEN 1 AND 5



SELECT *
FROM (
	SELECT SUM(colegiatura) OVER(ORDER BY id) AS Acumulacion, *
	FROM alumnos WHERE carrera_id =23
) AS alumnos_with_row_num


SELECT *
FROM (
	SELECT SUM(colegiatura) OVER(ORDER BY id) AS Acumulacion
	FROM alumnos WHERE carrera_id =23
) AS alumnos_with_row_num


SELECT * FROM
	(SELECT DISTINCT colegiatura
	FROM alumnos ORDER BY colegiatura
	DESC)
	



SELECT TOP 5 * FROM alumnos

SELECT * FROM alumnos 
ORDER BY id
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY

SELECT DISTINCT colegiatura
FROM alumnos 
ORDER BY colegiatura DESC OFFSET 1 ROWS FETCH NEXT 1 ROWS ONLY



SELECT DISTINCT colegiatura 
FROM alumnos AS a1
WHERE 2 = (
	SELECT COUNT(DISTINCT colegiatura)
	FROM alumnos AS a2
	WHERE a1.colegiatura <= a2.colegiatura
	)

SELECT * FROM alumnos AS d_alum
INNER JOIN(
	SELECT DISTINCT colegiatura from alumnos
	ORDER BY colegiatura DESC OFFSET 1 ROWS FETCH NEXT 1 ROWS ONLY
) AS segunda_mayor_colegiatura
ON d_alum.colegiatura = segunda_mayor_colegiatura.colegiatura


SELECT * FROM alumnos AS data_alumnos
WHERE colegiatura = (
SELECT DISTINCT colegiatura from alumnos
	ORDER BY colegiatura DESC OFFSET 1 ROWS FETCH NEXT 1 ROWS ONLY
)
