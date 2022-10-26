USE PLATZY_CURSO_SQL_PRACTICO

SELECT * FROM alumnos;
SELECT SUM(colegiatura) as totalColegiatura FROM alumnos;
SELECT AVG(colegiatura) as promedioColegiatura FROM alumnos;
SELECT MIN(colegiatura) as minimoColegiatura FROM alumnos;
SELECT MAX(colegiatura) as maximoColegiatura FROM alumnos;


SELECT IIF(500<1000, 'YES', 'NO');

SELECT IIF(colegiatura<1000, 'YES', 'NO') AS colegiaturaText FROM alumnos 

SELECT colegiatura,
CASE 
	WHEN colegiatura > 2000 THEN 'ESTA SOBRE 2000'
	WHEN colegiatura = 2000 THEN 'ES IGUAL 2000'
 	ELSE 'ESTA BAJO 2000'
END AS colegiaturaText FROM alumnos



-- LEFT JOIN
-- INNER JOIN
-- RIGHT JOIN

-- LEFT OUTER JOIN
-- RIGHT OUTER JOIN
-- FULL OUTER JOIN


