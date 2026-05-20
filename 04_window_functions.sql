-- Análisis avanzado con CTEs y Window Functions

-- Ranking de conversiones dentro de cada canal
SELECT
  canal,
  pais,
  conversiones,
  ROW_NUMBER() OVER (
    PARTITION BY canal
    ORDER BY conversiones DESC
  ) AS ranking
FROM campanas;

-- Mejor campaña de cada canal (ranking = 1)
WITH mejor_campana AS (
  SELECT
    canal,
    pais,
    conversiones,
    ROW_NUMBER() OVER (
      PARTITION BY canal
      ORDER BY conversiones DESC
    ) AS rn
  FROM campanas
)
SELECT canal, pais, conversiones
FROM mejor_campana
WHERE rn = 1
ORDER BY conversiones DESC;

-- Canal con menor costo por conversión promedio
WITH costo_eficiencia AS (
  SELECT
    canal,
    AVG(costo::numeric / conversiones) AS costo_por_conv
  FROM campanas
  GROUP BY canal
)
SELECT canal, ROUND(costo_por_conv, 2) AS costo_por_conv
FROM costo_eficiencia
ORDER BY costo_por_conv ASC
LIMIT 1;