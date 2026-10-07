-- KPIs principales por canal de marketing

-- Gasto total, conversiones y costo por conversión (CPA) por canal.
-- CPA = SUM(costo) / SUM(conversiones): pondera por volumen, a diferencia
-- de AVG(costo / conversiones), que da el mismo peso a campañas pequeñas y grandes.
SELECT
  canal,
  SUM(costo)        AS gasto_total,
  SUM(conversiones) AS conv_total,
  ROUND(SUM(costo) / NULLIF(SUM(conversiones), 0), 2) AS costo_por_conv,
  ROUND(100 * SUM(costo) / SUM(SUM(costo)) OVER (), 1) AS pct_del_gasto
FROM campanas
GROUP BY canal
ORDER BY costo_por_conv ASC;

-- Clicks, impresiones, CTR y tasa de conversión por canal
SELECT
  canal,
  SUM(clicks)       AS clicks_total,
  SUM(impresiones)  AS impresiones_total,
  ROUND(SUM(clicks)::numeric / SUM(impresiones) * 100, 2)      AS ctr_pct,
  ROUND(SUM(conversiones)::numeric / SUM(clicks) * 100, 2)     AS tasa_conv_pct
FROM campanas
GROUP BY canal
ORDER BY ctr_pct DESC;
