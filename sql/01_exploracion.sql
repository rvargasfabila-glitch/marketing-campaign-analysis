-- Exploración inicial de la tabla campanas

-- Vista general ordenada por costo
SELECT *
FROM campanas
ORDER BY costo_mxn DESC;

-- Registros y campañas por tipo de resultado
SELECT tipo_resultado, COUNT(*) AS registros, COUNT(DISTINCT campana) AS campanas
FROM campanas
GROUP BY tipo_resultado
ORDER BY campanas DESC;

-- Rango de fechas y registros sin resultado reportado
SELECT MIN(mes) AS primer_mes, MAX(mes) AS ultimo_mes, COUNT(*) AS registros,
       COUNT(*) FILTER (WHERE resultados IS NULL) AS sin_resultado
FROM campanas;
