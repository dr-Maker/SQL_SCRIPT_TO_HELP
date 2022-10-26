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