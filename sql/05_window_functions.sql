-- Análisis avanzado con CTEs y Window Functions

-- Ranking de campañas por conversiones dentro de cada canal
SELECT
  canal,
  pais,
  mes,
  conversiones,
  ROW_NUMBER() OVER (PARTITION BY canal ORDER BY conversiones DESC) AS ranking
FROM campanas;

-- Mejor campaña de cada canal (ranking = 1)
WITH mejor_campana AS (
  SELECT
    canal,
    pais,
    mes,
    conversiones,
    ROW_NUMBER() OVER (PARTITION BY canal ORDER BY conversiones DESC) AS rn
  FROM campanas
)
SELECT canal, pais, mes, conversiones
FROM mejor_campana
WHERE rn = 1
ORDER BY conversiones DESC;

-- Top 3 meses con más conversiones por canal (RANK)
WITH mensual AS (
  SELECT canal, mes, SUM(conversiones) AS conversiones
  FROM campanas
  GROUP BY canal, mes
),
ranked AS (
  SELECT
    canal,
    mes,
    conversiones,
    RANK() OVER (PARTITION BY canal ORDER BY conversiones DESC) AS posicion
  FROM mensual
)
SELECT canal, mes, conversiones, posicion
FROM ranked
WHERE posicion <= 3
ORDER BY canal, posicion;

-- Canal con menor costo por conversión
WITH costo_eficiencia AS (
  SELECT canal, SUM(costo) / NULLIF(SUM(conversiones), 0) AS costo_por_conv
  FROM campanas
  GROUP BY canal
)
SELECT canal, ROUND(costo_por_conv, 2) AS costo_por_conv
FROM costo_eficiencia
ORDER BY costo_por_conv ASC
LIMIT 1;
