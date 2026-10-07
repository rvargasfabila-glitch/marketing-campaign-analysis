-- Esquema de la tabla campanas y carga del dataset
-- Ejecutar desde la raíz del repo: psql marketing_db -f sql/00_schema.sql

DROP TABLE IF EXISTS campanas;

CREATE TABLE campanas (
  id_campana   INTEGER PRIMARY KEY,
  canal        TEXT          NOT NULL CHECK (canal IN ('Google Ads', 'Facebook', 'Email', 'TikTok')),
  pais         TEXT          NOT NULL CHECK (pais IN ('México', 'Colombia', 'Argentina')),
  mes          DATE          NOT NULL,            -- primer día del mes
  impresiones  INTEGER       NOT NULL CHECK (impresiones >= 0),
  clicks       INTEGER       NOT NULL CHECK (clicks >= 0),
  costo        NUMERIC(12,2) NOT NULL CHECK (costo >= 0),  -- USD
  conversiones INTEGER       NOT NULL CHECK (conversiones >= 0)
);

\copy campanas FROM 'data/campanas.csv' CSV HEADER
