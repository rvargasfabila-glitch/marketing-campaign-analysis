-- Exploración inicial de la tabla campanas
SELECT * 
FROM campanas 
ORDER BY costo DESC;

-- Conteo de campañas por canal
SELECT canal, COUNT(*) AS total_campanas
FROM campanas
GROUP BY canal
ORDER BY total_campanas DESC;