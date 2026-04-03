# 🇧🇷 Olist E-Commerce: SQL Analytics Pipeline

## 🔎 Project Snapshot

| Metric | Value |
|---|---|
| Total Revenue | R$15,422,461 |
| Total Orders | 96,478 |
| Unique Customers | 93,358 |
| Average Order Value | R$159.85 |
| Avg Delivery Time | 12.1 days |
| Late Orders | 8.1% |
| Period | Sep 2016 – Aug 2018 |

**Core Finding:** Revenue grew 7× in 2017 but plateaued in 2018 — driven by Black Friday seasonality, not organic retention. With a 3% repeat rate, every growth dollar is spent replacing churned customers.

---

## 📖 The Story: Growth Without Retention

Olist scaled from R$46k/month in late 2016 to R$1.1M/month by November 2017 — a 7× increase in 13 months. But the November 2017 spike was Black Friday (Dia de Ofertas), not organic growth. Revenue corrected to ~R$830k in January 2018 and never broke through the R$1.1M ceiling again.

The data tells a clear story: **97% of customers buy once and never return.** Revenue is a direct function of acquisition spend. Without a retention layer, the platform is refilling a leaky bucket.

---

## 📈 Key Findings

### Revenue Trend
Revenue grew consistently through 2017, peaked at R$1.15M in November 2017 (Black Friday), then stabilized at R$0.98–1.1M/month through 2018 with no further growth.

### 🔁 Repeat Rate: 3%
| Segment | Customers | Share |
|---|---|---|
| One-time buyers | 90,557 | 97% |
| Repeat buyers | 2,801 | 3% |

97% of customers never return. The mechanism that converts a first-time buyer into a repeat buyer is essentially nonexistent.

### 🏆 Revenue by Category
| Category | Orders | Revenue |
|---|---|---|
| Health Beauty | 8,647 | R$1,233,131 |
| Watches Gifts | 5,495 | R$1,166,176 |
| Bed Bath Table | 9,272 | R$1,023,434 |
| Sports Leisure | 7,530 | R$954,852 |
| Computers Accessories | 6,530 | R$888,724 |

Health Beauty leads in revenue despite fewer orders than Bed Bath Table — highest AOV in the top 5. Watches Gifts has the best revenue-to-orders ratio, indicating premium positioning.

### 💳 Payment Types
| Type | Orders | Revenue |
|---|---|---|
| Credit Card | 74,304 | R$12,101,094 (78%) |
| Boleto | 19,191 | R$2,769,932 (18%) |
| Voucher | 3,679 | R$343,013 (2%) |
| Debit Card | 1,485 | R$208,421 (1%) |

Boleto at 18% reflects a uniquely Brazilian payment behavior — significant for any platform localizing to this market.

### 🚚 Delivery Performance
| Metric | Value |
|---|---|
| Avg delivery time | 12.1 days |
| Median delivery time | 10.0 days |
| Late orders | 7,826 (8.1%) |

Median below average signals a tail of very slow deliveries pulling the mean up. 1 in 12 orders arrives late — a direct driver of low repeat rates.

### 🗺 Regional Breakdown
SP, RJ, and MG account for **62% of total revenue**. Northern states (AM, AC, RR) show minimal volume — likely reflecting logistics barriers and lower market penetration.

---

## 🚀 Recommendations

**1. Fix delivery tail** — 8.1% late rate is the most actionable retention lever. Customers who receive late orders are significantly less likely to return.

**2. Shift category mix toward consumables** — Health Beauty and Sports Leisure have repeat potential. Watches and furniture inflate AOV but contribute nothing to retention.

**3. Build a second-purchase trigger** — 93k customers bought once. A targeted offer within 21 days of first purchase (before the habit window closes) is the highest-leverage retention play available.

---

## 🛠 Tech Stack

| Layer | Detail |
|---|---|
| Database | PostgreSQL |
| Data Modeling | Fact table with pre-aggregated payments and order items to prevent join duplication |
| KPI Layer | SQL window functions, CTEs, percentile aggregations |
| Visualization | Tableau Public |

---

## 🗄 Data Model

5 source tables → 1 fact table built with pre-aggregated subqueries:

- **Payments** aggregated before JOIN → prevents revenue duplication from split payments
- **Order items** aggregated before JOIN → prevents row multiplication
- `customer_unique_id` used throughout → correct repeat rate calculation

---

## 📁 Project Structure
olist-sql-analytics/
├── sql/
│   ├── 01_schema.sql         
│   ├── 02_cleaning.sql       
│   ├── 03_fact_orders.sql   
│   └── 04_kpi.sql             
└── README.md
---

---

## 📊 Dashboard

👉 [View on Tableau Public](https://public.tableau.com/app/profile/aman.suvanov/viz/OlistE-CommerceAnalysis_17750368278340/DashboardOlist)

---

*Dataset: [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)*
