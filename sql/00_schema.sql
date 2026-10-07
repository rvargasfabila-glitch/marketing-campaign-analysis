-- Esquema de la tabla campanas (campañas de Meta Ads, anonimizadas) y carga del dataset
-- Ejecutar desde la raíz del repo: psql marketing_db -f sql/00_schema.sql

DROP TABLE IF EXISTS campanas;

CREATE TABLE campanas (
  id_registro    INTEGER PRIMARY KEY,
  campana        TEXT          NOT NULL,   -- etiqueta anonimizada (Campaña 01, 02, ...)
  tipo_resultado TEXT          NOT NULL CHECK (tipo_resultado IN
                   ('mensajes_whatsapp', 'leads_formulario', 'clicks_enlace', 'vistas_landing')),
  estado         TEXT          NOT NULL CHECK (estado IN ('activa', 'pausada')),
  mes            DATE          NOT NULL,   -- primer día del mes
  impresiones    INTEGER       NOT NULL CHECK (impresiones >= 0),
  clicks         INTEGER       NOT NULL CHECK (clicks >= 0),
  costo_mxn      NUMERIC(12,2) NOT NULL CHECK (costo_mxn >= 0),
  resultados     INTEGER       CHECK (resultados >= 0)  -- NULL = Meta no reportó el resultado
);

\copy campanas FROM 'data/campanas.csv' CSV HEADER
