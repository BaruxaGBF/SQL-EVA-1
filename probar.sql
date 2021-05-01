SELECT DISTINCT idusuario,idplan, sum(montopagado) over(PARTITION BY idusuario,idplan) as PagadoxP
from pagos
GROUP by idusuario,idpago

SELECT idusuario,count(CASE WHEN DiasR BETWEEN 1 AND 5 Then idreproducción END) "durante semana",
count(CASE WHEN DiasR BETWEEN 6 AND 7 Then idreproducción END) "fin de"
from (select idreproducción,idusuario, 
      EXTRACT(ISODOW FROM fechaReproducción) as DiasR
	  from reproducciones RE ) as InfRexUsu
GROUP BY idusuario

SELECT C.título, I.nombre, ROUND((SELECT AVG(calificación) FROM Calificaciones WHERE Calificaciones.idCanción = C.idCanción), 1), SUM(cantidadReproducciones), CONCAT(ROUND(100.0 * SUM(cantidadReproducciones)/ (SELECT COUNT(idReproducción) FROM Reproducciones INNER JOIN Canciones USING(idCanción) WHERE Canciones.idintérpreteprincipal = C.idintérpreteprincipal ), 1), '%'), CONCAT(SUM(CASE WHEN díaDeLaSemana BETWEEN 1 AND 5 THEN cantidadReproducciones END), ' (', ROUND(100.0 * SUM(CASE WHEN díaDeLaSemana BETWEEN 1 AND 5 THEN cantidadReproducciones END)/SUM(cantidadReproducciones), 1), '%)') AS "reproducciones de lunes a viernes", CONCAT(SUM(CASE WHEN díaDeLaSemana BETWEEN 6 AND 7 THEN cantidadReproducciones END), ' (', ROUND(100.0 * SUM(CASE WHEN díaDeLaSemana BETWEEN 6 AND 7 THEN cantidadReproducciones END)/SUM(cantidadReproducciones), 1), '%)') AS "reproducciones de sábado y domingo" FROM Intérpretes I INNER JOIN Canciones C ON I.idIntérprete = C.idintérpreteprincipal INNER JOIN (SELECT idCanción, EXTRACT(ISODOW FROM fechaReproducción) AS díaDeLaSemana, COUNT(idReproducción) AS cantidadReproducciones FROM Reproducciones WHERE segundosReproducidos>=30 GROUP BY idCanción, EXTRACT(ISODOW FROM fechaReproducción)) AS R USING (idCanción) GROUP BY I.idIntérprete, C.idCanción ORDER BY SUM(cantidadReproducciones) DESC