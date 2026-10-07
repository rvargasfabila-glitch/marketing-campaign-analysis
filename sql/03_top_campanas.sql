-- Rankings y top campañas

-- Top 3 campañas con más clicks
SELECT id_campana, canal, pais, mes, clicks
FROM campanas
ORDER BY clicks DESC
LIMIT 3;

-- Top 3 campañas más eficientes (menor costo por conversión)
SELECT
  id_campana,
  canal,
  pais,
  mes,
  costo,
  conversiones,
  ROUND(costo / NULLIF(conversiones, 0), 2) AS costo_por_conv
FROM campanas
WHERE conversiones > 0
ORDER BY costo_por_conv ASC
LIMIT 3;

-- Campañas con conversiones por encima del promedio general
SELECT id_campana, canal, pais, mes, conversiones
FROM campanas
WHERE conversiones > (SELECT AVG(conversiones) FROM campanas)
ORDER BY conversiones DESC;
