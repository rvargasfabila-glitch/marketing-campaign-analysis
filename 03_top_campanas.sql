-- Rankings y top campañas

-- Top 3 campañas con más clicks
SELECT canal, pais, clicks
FROM campanas
ORDER BY clicks DESC
LIMIT 3;

-- Top 3 campañas más eficientes (menor costo por conversión)
SELECT
  canal,
  pais,
  costo,
  conversiones,
  ROUND(costo::numeric / conversiones, 2) AS costo_por_conv
FROM campanas
ORDER BY costo_por_conv ASC
LIMIT 3;

-- Canales con conversiones por encima del promedio general
SELECT canal, pais, conversiones
FROM campanas
WHERE conversiones > (SELECT AVG(conversiones) FROM campanas)
ORDER BY conversiones DESC;