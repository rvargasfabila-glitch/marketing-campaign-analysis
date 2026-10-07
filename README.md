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

Archivo: [`data/campanas.csv`](data/campanas.csv) · Esquema: [`sql/00_schema.sql`](sql/00_schema.sql)

| Campo | Descripción |
|---|---|
| `id_campana` | Identificador único |
| `canal` | Canal de adquisición (Google Ads, Facebook, Email, TikTok) |
| `pais` | País de la campaña (México, Colombia, Argentina) |
| `mes` | Primer día del mes (enero–marzo 2025) |
| `impresiones` | Número de veces que se mostró el anuncio |
| `clicks` | Clics totales recibidos |
| `costo` | Gasto total en la campaña (USD) |
| `conversiones` | Número de conversiones generadas |

**Registros:** 36 campañas (4 canales × 3 países × 3 meses)
**Fuente:** dataset **simulado** con métricas de marketing digital plausibles; no son datos reales de ninguna empresa.

---

## 🔍 Análisis realizado

| Script | Contenido |
|---|---|
| [`01_exploracion.sql`](sql/01_exploracion.sql) | Vista general, conteo por canal/país, rango de fechas |
| [`02_kpis_por_canal.sql`](sql/02_kpis_por_canal.sql) | Gasto, conversiones, CPA, % del gasto, CTR y tasa de conversión |
| [`03_top_campanas.sql`](sql/03_top_campanas.sql) | Top por clicks, top más eficientes, campañas sobre el promedio |
| [`04_tendencia_mensual.sql`](sql/04_tendencia_mensual.sql) | Crecimiento mes a mes con `LAG` y `FIRST_VALUE`/`LAST_VALUE` |
| [`05_window_functions.sql`](sql/05_window_functions.sql) | CTEs, `ROW_NUMBER`, `RANK`, top 3 meses por canal |

### Nota metodológica
El costo por conversión (CPA) se calcula como `SUM(costo) / SUM(conversiones)`, que pondera por volumen. Promediar el ratio de cada campaña (`AVG(costo / conversiones)`) da el mismo peso a campañas pequeñas y grandes y distorsiona la comparación entre canales.

```sql
SELECT
  canal,
  SUM(costo)        AS gasto_total,
  SUM(conversiones) AS conv_total,
  ROUND(SUM(costo) / NULLIF(SUM(conversiones), 0), 2) AS costo_por_conv
FROM campanas
GROUP BY canal
ORDER BY costo_por_conv ASC;
```

---

## 💡 Hallazgos principales

| # | Hallazgo | Dato |
|---|---|---|
| 1 | **Email tiene el menor costo por conversión** | $1.18 USD vs $38.77 de Google Ads (~33x más eficiente) |
| 2 | **Email genera el mayor volumen de conversiones** | 2,063 de 3,520 totales (59%) con solo 4.7% del gasto |
| 3 | **Google Ads concentra el gasto** | $29,854 USD (57.7% del total de $51,730) y solo 770 conversiones |
| 4 | **TikTok tiene la mejor tendencia** | Único canal con crecimiento mensual positivo en ambos meses: +9.5% y +35.9% (+48.8% en el trimestre) |
| 5 | **Facebook va a la baja** | Conversiones caen cada mes: 140 → 132 → 114 (−18.6%) |

> Cifras calculadas sobre el dataset simulado incluido; reprodúcelas con los scripts de `sql/`.

---

## 📌 Recomendaciones de negocio

- **Reasignar presupuesto:** mover parte del gasto de Google Ads hacia Email y probar el impacto. Email es muy eficiente, pero su audiencia es limitada, así que el CPA marginal probablemente subirá al escalar.
- **Escalar TikTok de forma gradual:** es el único canal en crecimiento sostenido, aunque su CPA ($23.71) sigue siendo alto frente a Email.
- **Revisar Facebook:** contenido y segmentación, ya que sus conversiones bajan mes a mes.

---

## 🗃️ Estructura del repositorio

```
marketing-campaign-analysis/
│
├── README.md
│
├── data/
│   └── campanas.csv              ← Dataset simulado (36 filas)
│
└── sql/
    ├── 00_schema.sql             ← CREATE TABLE + carga del CSV
    ├── 01_exploracion.sql        ← SELECT, GROUP BY, ORDER BY
    ├── 02_kpis_por_canal.sql     ← SUM, CPA, CTR, tasa de conversión
    ├── 03_top_campanas.sql       ← LIMIT, subqueries
    ├── 04_tendencia_mensual.sql  ← CTEs, LAG, FIRST_VALUE/LAST_VALUE
    └── 05_window_functions.sql   ← ROW_NUMBER, RANK
```

---

## ▶️ Cómo reproducir este análisis

**Opción A — PostgreSQL local** (desde la raíz del repo)
```bash
# 1. Crear la base de datos
createdb marketing_db

# 2. Crear la tabla e importar el dataset
psql marketing_db -f sql/00_schema.sql

# 3. Ejecutar los análisis en orden numérico
psql marketing_db -f sql/01_exploracion.sql
```

**Opción B — Sin instalar nada (online)**
1. Ir a [db-fiddle.com](https://www.db-fiddle.com) y seleccionar **PostgreSQL 14**
2. Pegar el `CREATE TABLE` de `00_schema.sql` e insertar los datos de `data/campanas.csv` (el `\copy` solo funciona en `psql`)
3. Pegar el contenido de cualquier otro archivo `.sql`

---

## 🛠️ Stack tecnológico

![SQL](https://img.shields.io/badge/SQL-PostgreSQL-336791?style=flat&logo=postgresql&logoColor=white)
![Status](https://img.shields.io/badge/Estado-Completado-1D9E75?style=flat)

---

## 👤 Autor

Jesus Ricardo Vargas Fabila 
Licenciatura en Mercadotecnia · Maestría en Ciencia de Datos (en curso)  
📍 Morelos, México · Disponible para trabajo remoto

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Conectar-0A66C2?style=flat&logo=linkedin)](https://linkedin.com/in/tu-usuario)
[![GitHub](https://img.shields.io/badge/GitHub-Portfolio-181717?style=flat&logo=github)](https://github.com/tu-usuario)

---

*Este proyecto es parte de mi portfolio de transición hacia roles de Data/BI Analyst remoto.*
