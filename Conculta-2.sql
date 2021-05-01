select DISTINCT DENSE_RANK()OVER(ORDER BY (SELECT sum(montopagado) from pagos P where P.idusuario=Us.idusuario) DESC) AS "Top pagado en planes", 
		CONCAT(Us.nombres, ' ', Us.apellidos) as "Nombre Completo",
		Us.email as "Email",
		InfRexUsu.RTxU as "Reproducciones totales",
		CONCAT('(',count(CASE WHEN DiasR BETWEEN 1 AND 5 Then idreproducción END),') ',CONCAT((100*(count(CASE WHEN DiasR BETWEEN 1 AND 5 Then idreproducción END)))/InfRexUsu.RTxU,'%')) as "Porcentage de reproduccion durante semana",
		CONCAT('(',count(CASE WHEN DiasR BETWEEN 6 AND 7 Then idreproducción END),') ',CONCAT((100*(count(CASE WHEN DiasR BETWEEN 6 AND 7 Then idreproducción END)))/InfRexUsu.RTxU,'%')) as "Porcentage de reproduccion durante fin de semana",
		(InfRexUsu.UFR-InfRexUsu.LFR)/31 as "meses activo",
		(SELECT sum(montopagado) from pagos P where P.idusuario=Us.idusuario) AS "Total Pagado en planes"
FROM usuarios US
INNER JOIN
  (SELECT idreproducción,
          idusuario,
          count(RE.idreproducción) over(PARTITION BY idusuario) AS RTxU,
          Max(RE.fechareproducción) over(PARTITION BY idusuario) AS UFR,
          min(RE.fechareproducción) over(PARTITION BY idusuario) AS LFR,
          EXTRACT(ISODOW
                  FROM fechaReproducción) AS DiasR
   FROM reproducciones RE
   WHERE segundosReproducidos>=60) AS InfRexUsu USING(idusuario)
GROUP BY Us.idusuario,
         InfRexUsu.RTxU,
         InfRexUsu.UFR,
         InfRexUsu.LFR