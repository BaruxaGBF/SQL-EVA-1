select idusuario, 
		CONCAT(Us.nombres, ' ', Us.apellidos) as "Nombre Completo",
		Us.email as "Email",
		RTxU as "Reproducciones totales",
		DATE_PART('day', InfRexUsu.UFR::timestamp - InfRexUsu.LFR::timestamp),
		(InfRexUsu.UFR-InfRexUsu.LFR)
from usuarios US inner join (select idusuario, 
							 count(RE.idreproducción) AS RTxU,  
							 Max(RE.fechareproducción) AS UFR, 
							 min(RE.fechareproducción)  as LFR 
							 from reproducciones RE 
							 GROUP BY idusuario) as InfRexUsu using(idusuario)