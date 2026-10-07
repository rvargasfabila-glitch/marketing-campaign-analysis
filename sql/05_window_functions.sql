-- Análisis avanzado con CTEs y Window Functions

-- Ranking de campañas de WhatsApp por mensajes dentro de cada mes
SELECT
  mes,
  campana,
  resultados AS mensajes,
  RANK() OVER (PARTITION BY mes ORDER BY resultados DESC) AS posicion
FROM campanas
WHERE tipo_resultado = 'mensajes_whatsapp' AND resultados IS NOT NULL
ORDER BY mes, posicion;

-- Mejor campaña de cada tipo de resultado por costo por resultado (ROW_NUMBER)
WITH acumulado AS (
  SELECT
    tipo_resultado,
    campana,
    SUM(costo_mxn)  AS gasto_mxn,
    SUM(resultados) AS resultados,
    SUM(costo_mxn) / NULLIF(SUM(resultados), 0) AS cpr
  FROM campanas
  GROUP BY tipo_resultado, campana
  HAVING SUM(resultados) > 0
),
ranked AS (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY tipo_resultado ORDER BY cpr ASC) AS rn
  FROM acumulado
)
SELECT tipo_resultado, campana, gasto_mxn, resultados, ROUND(cpr, 2) AS costo_por_resultado
FROM ranked
WHERE rn = 1
ORDER BY tipo_resultado;

-- Gasto acumulado por mes (SUM como window function)
WITH mensual AS (
  SELECT mes, SUM(costo_mxn) AS gasto_mxn FROM campanas GROUP BY mes
)
SELECT mes, gasto_mxn, SUM(gasto_mxn) OVER (ORDER BY mes) AS gasto_acumulado_mxn
FROM mensual
ORDER BY mes;
