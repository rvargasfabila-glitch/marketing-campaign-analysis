-- Exploración inicial de la tabla campanas

-- Vista general ordenada por costo
SELECT *
FROM campanas
ORDER BY costo DESC;

-- Conteo de campañas por canal y país
SELECT canal, pais, COUNT(*) AS total_campanas
FROM campanas
GROUP BY canal, pais
ORDER BY canal, pais;

-- Rango de fechas y total de registros
SELECT MIN(mes) AS primer_mes, MAX(mes) AS ultimo_mes, COUNT(*) AS registros
FROM campanas;
