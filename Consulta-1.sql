SELECT Can.idcanción,
       Can.título,
       Gen.nombre AS "Genero",
       Inter.nombre AS "Interprete",
       Inter.tipointérprete AS "Tipo Interprete",
       Alb.título AS "Album",
       Alb.selloDiscográfico AS "Sello Discográfico",
       COUNT(idreproducción) AS "TotalR",
       COUNT(DISTINCT idUsuario) AS "Usuarios que la R",
       ROUND(AVG(segundosReproducidos)) AS " Tiempo Promedio Reproducido",
       MAX(fechaReproducción) AS "ultima Reproduccion ",
       MIN(fechaReproducción) AS "reproducion mas antigua"
FROM reproducciones AS RE
INNER JOIN canciones Can ON RE.idcanción=Can.idcanción
LEFT OUTER JOIN géneros Gen ON Can.idgénero=Gen.idgénero
LEFT OUTER JOIN intérpretes Inter ON Can.idintérpreteprincipal=Inter.idintérprete
LEFT OUTER JOIN Álbumes Alb ON Can.idÁlbumoriginal=Alb.idalbum
GROUP BY Can.idcanción,
         Can.título,
         Gen.nombre,
         Inter.nombre,
         Inter.tipointérprete,
         Alb.título,
         Alb.selloDiscográfico
HAVING COUNT(idreproducción)>10