-- Rankings por campaña (acumulado de todos los meses)

-- Top 5 campañas con más gasto
SELECT campana, tipo_resultado, estado, SUM(costo_mxn) AS gasto_mxn
FROM campanas
GROUP BY campana, tipo_resultado, estado
ORDER BY gasto_mxn DESC
LIMIT 5;

-- Top 5 campañas de WhatsApp más eficientes (menor costo por mensaje)
SELECT
  campana,
  SUM(costo_mxn)  AS gasto_mxn,
  SUM(resultados) AS mensajes,
  ROUND(SUM(costo_mxn) / NULLIF(SUM(resultados), 0), 2) AS costo_por_mensaje
FROM campanas
WHERE tipo_resultado = 'mensajes_whatsapp'
GROUP BY campana
HAVING SUM(resultados) > 0
ORDER BY costo_por_mensaje ASC
LIMIT 5;

-- Campañas que gastaron más que el promedio por campaña
SELECT campana, SUM(costo_mxn) AS gasto_mxn
FROM campanas
GROUP BY campana
HAVING SUM(costo_mxn) > (
  SELECT AVG(gasto) FROM (SELECT SUM(costo_mxn) AS gasto FROM campanas GROUP BY campana) t
)
ORDER BY gasto_mxn DESC;
