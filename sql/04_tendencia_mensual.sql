-- Tendencia mes a mes (LAG).
-- Nota: julio es parcial (datos desde el 8) y octubre llega solo al día 5,
-- así que el análisis de tendencia se centra en agosto vs. septiembre.

-- Gasto, mensajes de WhatsApp y costo por mensaje por mes, con variación vs. mes anterior
WITH mensual AS (
  SELECT
    mes,
    SUM(costo_mxn)  AS gasto_mxn,
    SUM(resultados) AS mensajes,
    ROUND(SUM(costo_mxn) / NULLIF(SUM(resultados), 0), 2) AS costo_por_mensaje
  FROM campanas
  WHERE tipo_resultado = 'mensajes_whatsapp'
  GROUP BY mes
)
SELECT
  mes,
  gasto_mxn,
  mensajes,
  costo_por_mensaje,
  LAG(costo_por_mensaje) OVER (ORDER BY mes) AS cpr_mes_anterior,
  ROUND(100.0 * (costo_por_mensaje - LAG(costo_por_mensaje) OVER (ORDER BY mes))
        / NULLIF(LAG(costo_por_mensaje) OVER (ORDER BY mes), 0), 1) AS variacion_cpr_pct
FROM mensual
ORDER BY mes;

-- Gasto mensual por tipo de resultado y variación vs. mes anterior
WITH mensual AS (
  SELECT tipo_resultado, mes, SUM(costo_mxn) AS gasto_mxn
  FROM campanas
  GROUP BY tipo_resultado, mes
)
SELECT
  tipo_resultado,
  mes,
  gasto_mxn,
  ROUND(100.0 * (gasto_mxn - LAG(gasto_mxn) OVER (PARTITION BY tipo_resultado ORDER BY mes))
        / NULLIF(LAG(gasto_mxn) OVER (PARTITION BY tipo_resultado ORDER BY mes), 0), 1) AS variacion_gasto_pct
FROM mensual
ORDER BY tipo_resultado, mes;
