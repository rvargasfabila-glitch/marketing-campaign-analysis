-- KPIs por tipo de resultado.
-- Un "resultado" no es comparable entre tipos (un mensaje de WhatsApp no equivale
-- a un clic), por eso el costo por resultado se calcula dentro de cada tipo.
-- CPR = SUM(costo) / SUM(resultados): pondera por volumen.
SELECT
  tipo_resultado,
  SUM(costo_mxn)   AS gasto_mxn,
  SUM(resultados)  AS resultados,
  ROUND(SUM(costo_mxn) FILTER (WHERE resultados IS NOT NULL)
        / NULLIF(SUM(resultados), 0), 2) AS costo_por_resultado,
  ROUND(100 * SUM(costo_mxn) / SUM(SUM(costo_mxn)) OVER (), 1) AS pct_del_gasto
FROM campanas
GROUP BY tipo_resultado
ORDER BY pct_del_gasto DESC;

-- Impresiones, clicks, CTR y CPC por tipo de resultado
SELECT
  tipo_resultado,
  SUM(impresiones) AS impresiones,
  SUM(clicks)      AS clicks,
  ROUND(SUM(clicks)::numeric / SUM(impresiones) * 100, 2) AS ctr_pct,
  ROUND(SUM(costo_mxn) / NULLIF(SUM(clicks), 0), 2)       AS cpc_mxn
FROM campanas
GROUP BY tipo_resultado
ORDER BY ctr_pct DESC;
