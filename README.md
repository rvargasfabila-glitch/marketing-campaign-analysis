# 📊 Análisis de Campañas de Meta Ads

> **Proyecto de portfolio — BI Analyst**  
> Herramientas: `SQL (PostgreSQL)` · Datos reales de Meta Ads (anonimizados) · Estado: ✅ Completado

---

## 🧭 Contexto de negocio

Análisis de **17 campañas reales de Meta Ads** (Facebook/Instagram) de una cuenta publicitaria de servicios, durante aproximadamente tres meses. Las campañas persiguen distintos resultados (mensajes de WhatsApp, leads por formulario, clics a un enlace y visitas a una landing). El análisis responde:

1. ¿Dónde se concentra el gasto y qué **costo por resultado** tiene cada tipo de campaña?
2. ¿Cómo evoluciona el **costo por mensaje** mes a mes?
3. ¿Qué campañas son las más y las menos eficientes?

---

## 🗂️ Dataset

Archivo: [`data/campanas.csv`](data/campanas.csv) · Esquema: [`sql/00_schema.sql`](sql/00_schema.sql)

Extraído de la API de Meta Ads (nivel campaña, desglose mensual). **Anonimizado:** los nombres de campaña se sustituyeron por etiquetas (`Campaña 01`…), se omiten IDs de cuenta y campaña, y el gasto se redondea a pesos enteros.

| Campo | Descripción |
|---|---|
| `id_registro` | Identificador del registro |
| `campana` | Etiqueta anonimizada de la campaña |
| `tipo_resultado` | Resultado que optimiza la campaña: `mensajes_whatsapp`, `leads_formulario`, `clicks_enlace`, `vistas_landing` |
| `estado` | `activa` o `pausada` (al cierre de la extracción) |
| `mes` | Primer día del mes |
| `impresiones`, `clicks` | Impresiones y clics (todos) |
| `costo_mxn` | Gasto en pesos mexicanos |
| `resultados` | Resultados reportados por Meta; vacío si no los reportó |

**Registros:** 36 (campaña × mes con gasto) · **Moneda:** MXN

**Limitaciones**
- El primer mes y el último son parciales (la extracción no cubre el mes completo).
- Un "resultado" no es comparable entre tipos (un mensaje no equivale a un clic), por lo que el costo por resultado solo se compara **dentro** de cada tipo.
- Hay 3 registros de campañas de leads sin resultado reportado; se excluyen del costo por resultado.

---

## 🔍 Análisis realizado

| Script | Contenido |
|---|---|
| [`01_exploracion.sql`](sql/01_exploracion.sql) | Vista general, registros por tipo, rango de fechas |
| [`02_kpis_por_tipo.sql`](sql/02_kpis_por_tipo.sql) | Gasto, resultados, costo por resultado, % del gasto, CTR y CPC |
| [`03_top_campanas.sql`](sql/03_top_campanas.sql) | Top por gasto, más eficientes, sobre el promedio |
| [`04_tendencia_mensual.sql`](sql/04_tendencia_mensual.sql) | Tendencia mensual con `LAG` |
| [`05_window_functions.sql`](sql/05_window_functions.sql) | `RANK`, `ROW_NUMBER`, gasto acumulado |

El costo por resultado se calcula como `SUM(costo) / SUM(resultados)`, que pondera por volumen; promediar el ratio de cada campaña distorsiona la comparación.

```sql
SELECT
  tipo_resultado,
  SUM(costo_mxn)  AS gasto_mxn,
  SUM(resultados) AS resultados,
  ROUND(SUM(costo_mxn) FILTER (WHERE resultados IS NOT NULL)
        / NULLIF(SUM(resultados), 0), 2) AS costo_por_resultado
FROM campanas
GROUP BY tipo_resultado;
```

---

## 💡 Hallazgos principales

| # | Hallazgo | Dato |
|---|---|---|
| 1 | **El gasto se concentra en WhatsApp** | 94.9% del gasto y 2,351 mensajes a **$34.36 MXN por mensaje** |
| 2 | **El costo por mensaje sube cada mes** | $26.71 (mes 1) → $35.38 (mes 2) → $48.55 (mes 3) → $60.63 (mes 4, parcial); +32.5%, +37.2% y +24.9% mes a mes |
| 3 | **Las campañas activas son menos eficientes que las pausadas** | $48.71 vs $32.59 por mensaje |
| 4 | **Enorme diferencia de eficiencia entre campañas** | La mejor de WhatsApp cuesta $9.77 por mensaje; las de leads por formulario, $202–$276 por lead |
| 5 | **Las campañas de tráfico son las más baratas por resultado** | ~$0.45 MXN por clic al enlace o visita a landing (no equivalen a mensajes ni leads) |

---

## 📌 Recomendaciones de negocio

- **Revisar las campañas activas de WhatsApp**: su costo por mensaje ($48.71) es ~50% mayor que el de las pausadas. Probar creativos y segmentaciones de las campañas más eficientes (p. ej. la Campaña 04, $9.77).
- **Vigilar la tendencia al alza del costo por mensaje**: puede reflejar saturación de audiencia o fatiga de creativos; conviene renovar creativos y ampliar audiencias.
- **Replantear las campañas de leads por formulario**: con $200+ por lead frente a ~$34 por mensaje, hay que validar si convierten mejor en ventas para justificar el costo.
- **Medir calidad, no solo volumen**: este análisis llega hasta mensajes y leads; conectar con ventas o clientes cerrados daría el costo de adquisición real.

---

## 🗃️ Estructura del repositorio

```
marketing-campaign-analysis/
│
├── README.md
│
├── data/
│   └── campanas.csv              ← Datos reales anonimizados (36 filas)
│
└── sql/
    ├── 00_schema.sql             ← CREATE TABLE + carga del CSV
    ├── 01_exploracion.sql        ← SELECT, GROUP BY, FILTER
    ├── 02_kpis_por_tipo.sql      ← SUM, costo por resultado, CTR, CPC
    ├── 03_top_campanas.sql       ← LIMIT, HAVING, subqueries
    ├── 04_tendencia_mensual.sql  ← CTEs, LAG
    └── 05_window_functions.sql   ← RANK, ROW_NUMBER, SUM OVER
```

---

## ▶️ Cómo reproducir este análisis

**Opción A — PostgreSQL local** (desde la raíz del repo)
```bash
createdb marketing_db
psql marketing_db -f sql/00_schema.sql      # crea la tabla y carga el CSV
psql marketing_db -f sql/02_kpis_por_tipo.sql
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

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Conectar-0A66C2?style=flat&logo=linkedin)](https://www.linkedin.com/in/ricardo-vargas-04a025249)
[![GitHub](https://img.shields.io/badge/GitHub-Portfolio-181717?style=flat&logo=github)](https://github.com/rvargasfabila-glitch)

---

*Este proyecto es parte de mi portfolio de transición hacia roles de Data/BI Analyst remoto.*
