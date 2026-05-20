-- KPIs principales por canal de marketing

-- Gasto total, conversiones y costo por conversión por canal
SELECT
  canal,
  SUM(costo)        AS gasto_total,
  SUM(conversiones) AS conv_total,
  ROUND(AVG(costo::numeric / conversiones), 2) AS costo_por_conv
FROM campanas
GROUP BY canal
ORDER BY costo_por_conv ASC;

-- Total de clicks e impresiones por canal
SELECT
  canal,
  SUM(clicks)       AS clicks_total,
  SUM(impresiones)  AS impresiones_total,
  ROUND(SUM(clicks)::numeric / SUM(impresiones) * 100, 2) AS ctr_pct
FROM campanas
GROUP BY canal
ORDER BY ctr_pct DESC;