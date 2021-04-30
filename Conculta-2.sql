select Us.idusuario, 
		CONCAT(Us.nombres, ' ', Us.apellidos) as "Nombre Completo",
		Us.email as "Email",
		InfRexUsu.RTxU as "Reproducciones totales",
		(InfRexUsu.UFR-InfRexUsu.LFR)/31 as "meses activo"
from usuarios US inner join (select idusuario, 
							 count(RE.idreproducción) AS RTxU,  
							 Max(RE.fechareproducción) AS UFR, 
							 min(RE.fechareproducción)  as LFR 
							 from reproducciones RE 
							 GROUP BY idusuario) as InfRexUsu using(idusuario)