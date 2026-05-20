# 📊 Análisis de Campañas de Marketing Digital

> **Proyecto de portfolio — BI Analyst**  
> Herramientas: `SQL (PostgreSQL)` · Estado: ✅ Completado

---

## 🧭 Contexto de negocio

Una empresa de e-commerce ejecuta campañas digitales simultáneas en **4 canales** (Google Ads, Facebook, Email y TikTok) durante el primer trimestre del año. El equipo de marketing necesita responder tres preguntas clave:

1. ¿Qué canal genera el **menor costo por conversión**?
2. ¿Qué canal tiene la **mejor tendencia de crecimiento** mes a mes?
3. ¿Cuáles son los **3 meses con mayor volumen de ventas** por canal?

Este proyecto responde esas preguntas usando SQL puro — desde exploración hasta análisis avanzado con CTEs y Window Functions.

---

## 🗂️ Dataset

| Campo | Descripción |
|---|---|
| `canal` | Canal de adquisición (Google Ads, Facebook, Email, TikTok) |
| `pais` | País de la campaña (México, Colombia, Argentina) |
| `impresiones` | Número de veces que se mostró el anuncio |
| `clicks` | Clics totales recibidos |
| `costo` | Gasto total en la campaña (USD) |
| `conversiones` | Número de conversiones generadas |

**Registros:** 8 campañas · 3 países · 4 canales  
**Fuente:** Dataset simulado basado en métricas reales de marketing digital

---

## 🔍 Análisis realizado

### 1. Exploración inicial
```sql
-- Vista general de todos los datos
SELECT * FROM campanas ORDER BY costo DESC;

-- Conteo de campañas por canal y país
SELECT canal, pais, COUNT(*) AS total_campanas
FROM campanas
GROUP BY canal, pais
ORDER BY canal;
```

### 2. KPIs por canal
```sql
-- Costo por conversión promedio por canal
SELECT
  canal,
  SUM(costo)        AS gasto_total,
  SUM(conversiones) AS conv_total,
  AVG(costo / conversiones) AS costo_por_conv
FROM campanas
GROUP BY canal
ORDER BY costo_por_conv ASC;
```

### 3. Top 3 campañas por clicks
```sql
SELECT canal, pais, clicks
FROM campanas
ORDER BY clicks DESC
LIMIT 3;
```

### 4. Ranking de conversiones por canal (Window Function)
```sql
WITH ranked AS (
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
FROM ranked
WHERE rn = 1
ORDER BY conversiones DESC;
```

---

## 💡 Hallazgos principales

| # | Hallazgo | Dato |
|---|---|---|
| 1 | **Email tiene el menor costo por conversión** | $2.63 USD vs $40.47 de Google Ads — 15x más eficiente |
| 2 | **Email genera el mayor volumen de conversiones** | 600 conversiones totales vs 308 de Google Ads |
| 3 | **Google Ads es el canal de mayor gasto** | $12,800 USD (36% del presupuesto total) |
| 4 | **TikTok tiene el mayor crecimiento** | Único canal con crecimiento positivo los 3 meses consecutivos |
| 5 | **Clientes dormidos en México** | Sofía Torres (id 5) sin ningún pedido — candidata a campaña de reactivación |

---

## 📌 Recomendaciones de negocio

- **Reasignar presupuesto:** Mover 20–25% del gasto de Google Ads hacia Email, que produce 15x más conversiones por dólar invertido.
- **Escalar TikTok:** Es el único canal con crecimiento sostenido — señal de mercado en expansión.
- **Campaña de reactivación:** Identificar y contactar clientes sin pedidos recientes mediante `LEFT JOIN … WHERE id_pedido IS NULL`.

---

## 🗃️ Estructura del repositorio

```
marketing-campaign-analysis/
│
├── README.md                   ← Este archivo
│
├── data/
│   └── campanas.csv            ← Dataset limpio
│
└── sql/
    ├── 01_exploracion.sql      ← SELECT, WHERE, ORDER BY
    ├── 02_kpis_por_canal.sql   ← GROUP BY, SUM, AVG, COUNT
    ├── 03_top_campanas.sql     ← LIMIT, subqueries
    ├── 04_joins_clientes.sql   ← INNER JOIN, LEFT JOIN, IS NULL
    └── 05_window_functions.sql ← CTEs, ROW_NUMBER, LAG, RANK
```

---

## ▶️ Cómo reproducir este análisis

**Opción A — PostgreSQL local**
```bash
# 1. Crear la base de datos
createdb marketing_db

# 2. Importar el dataset
psql marketing_db -c "\copy campanas FROM 'data/campanas.csv' CSV HEADER"

# 3. Ejecutar los scripts en orden numérico
psql marketing_db -f sql/01_exploracion.sql
```

**Opción B — Sin instalar nada (online)**
1. Ir a [db-fiddle.com](https://www.db-fiddle.com)
2. Seleccionar **PostgreSQL 14**
3. Pegar el contenido de cualquier archivo `.sql`

---

## 🛠️ Stack tecnológico

![SQL](https://img.shields.io/badge/SQL-PostgreSQL-336791?style=flat&logo=postgresql&logoColor=white)
![Status](https://img.shields.io/badge/Estado-Completado-1D9E75?style=flat)

---

## 👤 Autor

Jesus Ricaardo Vargas Fabila 
Licenciatura en Mercadotecnia · Maestría en Ciencia de Datos (en curso)  
📍 Morelos, México · Disponible para trabajo remoto

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Conectar-0A66C2?style=flat&logo=linkedin)](https://linkedin.com/in/tu-usuario)
[![GitHub](https://img.shields.io/badge/GitHub-Portfolio-181717?style=flat&logo=github)](https://github.com/tu-usuario)

---

*Este proyecto es parte de mi portfolio de transición hacia roles de Data/BI Analyst remoto.*
