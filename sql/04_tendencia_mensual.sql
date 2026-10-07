-- Tendencia mes a mes por canal (LAG)

-- Conversiones mensuales por canal y crecimiento vs. mes anterior
WITH mensual AS (
  SELECT canal, mes, SUM(conversiones) AS conversiones
  FROM campanas
  GROUP BY canal, mes
)
SELECT
  canal,
  mes,
  conversiones,
  LAG(conversiones) OVER (PARTITION BY canal ORDER BY mes) AS conv_mes_anterior,
  ROUND(
    100.0 * (conversiones - LAG(conversiones) OVER (PARTITION BY canal ORDER BY mes))
    / NULLIF(LAG(conversiones) OVER (PARTITION BY canal ORDER BY mes), 0),
    1
  ) AS crecimiento_pct
FROM mensual
ORDER BY canal, mes;

-- Crecimiento total del trimestre (último mes vs. primer mes) por canal
WITH mensual AS (
  SELECT canal, mes, SUM(conversiones) AS conversiones
  FROM campanas
  GROUP BY canal, mes
)
SELECT DISTINCT
  canal,
  FIRST_VALUE(conversiones) OVER w AS conv_primer_mes,
  LAST_VALUE(conversiones)  OVER w AS conv_ultimo_mes,
  ROUND(100.0 * (LAST_VALUE(conversiones) OVER w - FIRST_VALUE(conversiones) OVER w)
        / FIRST_VALUE(conversiones) OVER w, 1) AS crecimiento_trimestre_pct
FROM mensual
WINDOW w AS (PARTITION BY canal ORDER BY mes
             ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
ORDER BY crecimiento_trimestre_pct DESC;
