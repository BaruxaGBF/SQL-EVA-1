select DISTINCT Us.idusuario, 
		CONCAT(Us.nombres, ' ', Us.apellidos) as "Nombre Completo",
		Us.email as "Email",
		InfRexUsu.RTxU as "Reproducciones totales",
		CONCAT((100*(count(CASE WHEN DiasR BETWEEN 1 AND 5 Then idreproducción END)))/InfRexUsu.RTxU,'%') as "Porcentage de reproduccion durante semana",
		CONCAT((100*(count(CASE WHEN DiasR BETWEEN 6 AND 7 Then idreproducción END)))/InfRexUsu.RTxU,'%') as "Porcentage de reproduccion durante fin de semana",
		(InfRexUsu.UFR-InfRexUsu.LFR)/31 as "meses activo",
		(SELECT sum(montopagado) from pagos P where P.idusuario=Us.idusuario) AS "Total Pagado en planes"
from usuarios US inner join (select idreproducción,
							 idusuario, 
							 count(RE.idreproducción)  over(PARTITION BY idusuario) AS RTxU,  
							 Max(RE.fechareproducción) over(PARTITION BY idusuario) AS UFR, 
							 min(RE.fechareproducción) over(PARTITION BY idusuario) as LFR,
							 EXTRACT(ISODOW FROM fechaReproducción) as DiasR
							 from reproducciones RE 
							 WHERE segundosReproducidos>=60) as InfRexUsu using(idusuario)
GROUP BY Us.idusuario,InfRexUsu.RTxU,InfRexUsu.UFR,InfRexUsu.LFR