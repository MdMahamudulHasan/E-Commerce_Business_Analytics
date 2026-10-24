# 📊 E-Commerce Business Analytics

### SQL + Python | TheLook eCommerce Dataset | 35+ Business Questions

[![SQL](https://img.shields.io/badge/SQL-BigQuery-4285F4?style=flat&logo=googlebigquery&logoColor=white)](https://console.cloud.google.com/bigquery)
[![Python](https://img.shields.io/badge/Python-3.13-3776AB?style=flat&logo=python&logoColor=white)](https://colab.research.google.com/)
[![Pandas](https://img.shields.io/badge/Pandas-2.x-150458?style=flat&logo=pandas&logoColor=white)]()
[![Matplotlib](https://img.shields.io/badge/Matplotlib-3.x-11557C?style=flat&logo=plotly&logoColor=white)]()
[![Seaborn](https://img.shields.io/badge/Seaborn-0.13-4C72B0?style=flat)]()
[![Plotly](https://img.shields.io/badge/Plotly-5.x-3F4F75?style=flat&logo=plotly&logoColor=white)]()
[![License](https://img.shields.io/badge/License-MIT-green.svg)]()

---

## 🎯 Project Overview

A comprehensive end-to-end business analytics project on **TheLook eCommerce** dataset (fictitious clothing store by Looker). The project answers **35+ real-world business questions** using two complementary approaches:

| Approach | Platform | Dataset | Output |
|----------|----------|---------|--------|
| **SQL Analytics** | Google BigQuery | Public Dataset (Cloud) | 35 `.sql` queries + 35 CSV results |
| **Python Analytics** | Google Colab | Kaggle CSV (Local) | Jupyter Notebook + Visualizations |

> **Dataset:** ~100K users · ~80K orders · ~300K order items · 7 tables · Synthetic data by Looker

---

## 🏗️ Repository Structure
E-Commerce Analytics/

│

├── 📓 Python E-Commerce Analytics/

│ └── Python_E_Commerce_Analytics.ipynb ← Full Colab Notebook (40 cells)

│

├── 📁 SQL-Ecommerce-Analytics/

│ ├── 📁 Queries/

│ │ ├── 01_Revenue Analysis/ ← Q1-Q5

│ │ ├── 02_Customer Analytics/ ← Q6-Q10

│ │ ├── 03_Product Analytics/ ← Q11-Q15

│ │ ├── 04_Funnel & Events Analysis/ ← Q16-Q20

│ │ ├── 05_Gap & Streak Analysis/ ← Q21-Q25

│ │ ├── 06_Ranking & Window Functions/ ← Q26-Q30

│ │ └── 07_Advanced Business Questions/ ← Q31-Q35

│ │

│ └── 📁 Results/

│ ├── Result CSV/ ← 35 query output files

│ └── Result Visualization/ ← Charts & dashboards (PDF)

│

└── README.md


---

## 📊 Dataset Schema

users ─────────────── id, name, email, age, gender, city, state, country, traffic_source

│

├── orders ──────── order_id, user_id, status, gender, created/shipped/delivered/returned_at

│ │

│ └── order_items ── id, order_id, product_id, inventory_item_id, status, sale_price

│ │

│ ├── products ── id, cost, category, name, brand, retail_price, department, sku

│ │

│ └── inventory_items ── id, product_id, cost, sold_at, product_category/brand/name

│

├── events ──────── id, user_id, session_id, event_type, uri, browser, traffic_source

│

└── distribution_centers ── id, name, latitude, longitude



---

## 🔍 35 Business Questions

### 💰 Section 1: Revenue Analysis
| # | Question | Key Technique |
|---|----------|---------------|
| Q1 | Monthly Revenue Trend | `GROUP BY`, `AGG` |
| Q2 | Running Total (Cumulative Revenue) | `SUM() OVER (ORDER BY)` |
| Q3 | Month-over-Month Growth Rate | `LAG()`, `NULLIF()` |
| Q4 | Cumulative Revenue by Category | `SUM() OVER (PARTITION BY)` |
| Q5 | Revenue Contribution % (Pareto) | `SUM() OVER ()`, Cumulative % |

### 👥 Section 2: Customer Analytics
| # | Question | Key Technique |
|---|----------|---------------|
| Q6 | Cohort Retention Analysis ⭐ | `DATE_TRUNC`, `DATE_DIFF`, Self-Join |
| Q7 | Customer Lifetime Value (CLV) | `NTILE()`, Projection Formula |
| Q8 | RFM Segmentation ⭐ | `NTILE()`, CASE WHEN |
| Q9 | Repeat vs One-Time Customers | `COUNT(DISTINCT)`, `CASE` |
| Q10 | Churn Identification | `DATE_DIFF`, Status Bucketing |

### 🛍️ Section 3: Product Analytics
| # | Question | Key Technique |
|---|----------|---------------|
| Q11 | Top-N Products Per Category ⭐ | `ROW_NUMBER() OVER (PARTITION BY)` |
| Q12 | Product Affinity (Bought Together) | Self-Join, `HAVING` |
| Q13 | Slow-Moving Inventory | `CASE WHEN`, `TIMESTAMP_DIFF` |
| Q14 | Price Elasticity Proxy | `CASE` Brackets, `AVG()` |
| Q15 | Return Rate by Category & Brand | Conditional `COUNT` |

### 🔄 Section 4: Funnel & Events
| # | Question | Key Technique |
|---|----------|---------------|
| Q16 | Conversion Funnel ⭐ | Conditional `COUNT(DISTINCT)` |
| Q17 | Session Duration Analysis | `TIMESTAMP_DIFF`, Bucketing |
| Q18 | Bounce Rate by Traffic Source | Session-Level Aggregation |
| Q19 | First-Touch Attribution | `ROW_NUMBER()`, `LEFT JOIN` |
| Q20 | Event Sequence Pattern | `LEAD()`, Self-Join |

### 📅 Section 5: Gap & Streak Analysis
| # | Question | Key Technique |
|---|----------|---------------|
| Q21 | Consecutive Purchase Streak | Islands & Gaps (`ROW_NUMBER` trick) |
| Q22 | Order Gap Analysis | `LAG()`, `DATE_DIFF` |
| Q23 | Revenue Growth Streak | `SUM() OVER` Grouping |
| Q24 | Inactive Periods | `LEAD()`, Gap Threshold |
| Q25 | Daily Active Users (DAU) | `COUNT(DISTINCT)`, Rolling Window |

### 🏆 Section 6: Ranking & Window Functions
| # | Question | Key Technique |
|---|----------|---------------|
| Q26 | Revenue Percentile Analysis | `PERCENT_RANK()`, `NTILE()` |
| Q27 | 7-Day Moving Average | `AVG() OVER (ROWS BETWEEN)` |
| Q28 | Dense Rank (No Gaps) | `RANK()` vs `DENSE_RANK()` vs `ROW_NUMBER()` |
| Q29 | LAG/LEAD Comparison | `LAG()`, `LEAD()`, MoM Change |
| Q30 | NTILE Customer Quartiles | `NTILE(4)`, Quartile Stats |

### 🚀 Section 7: Advanced Business
| # | Question | Key Technique |
|---|----------|---------------|
| Q31 | Year-over-Year Comparison | Self-Join on Year Offset |
| Q32 | Pareto Analysis (80/20) ⭐ | `ROW_NUMBER()`, Cumulative % |
| Q33 | Market Basket Analysis | Self-Join, Support & Confidence |
| Q34 | Geographic Performance | Multi-Table Join, Regional Agg |
| Q35 | Delivery SLA Breach | `TIMESTAMP_DIFF`, SLA Threshold |

---

## 🐍 Python Analysis (Colab Notebook)

The Python notebook covers the **same 35 questions** with:

- **Pandas** data manipulation & aggregation
- **Matplotlib + Seaborn** static visualizations
- **Plotly** interactive charts
- Professional color system & styling
- Executive summary dashboard

### Key Python Techniques Used

---

✅ GroupBy + Aggregation ✅ Pivot Tables
✅ Rolling Windows ✅ pd.qcut (RFM/NTILE)
✅ Date Arithmetic ✅ Self-Merge (Market Basket)
✅ Cumulative Calculations ✅ Conditional Styling
✅ Heatmaps (Cohort) ✅ Multi-Axis Charts
✅ Funnel Visualization ✅ Pareto Curves


---

## 📈 Key Business Insights

| Insight | Finding |
|---------|---------|
| 💰 **Pareto Rule** | ~20% of products drive ~80% of total revenue |
| 👥 **Retention** | Cohort retention drops to ~8% by Month 6 |
| 🔄 **Funnel** | Cart-to-purchase conversion is the biggest drop-off |
| 🛍️ **Returns** | Specific brands show >10% return rates |
| 📦 **Delivery** | Majority orders delivered within 5 days; SLA breach <15% |
| 🌍 **Geography** | United States dominates revenue; top 5 states drive ~60% |
| 📊 **Seasonality** | Revenue peaks in Q4 (holiday season) |

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| **SQL Engine** | Google BigQuery (Standard SQL) |
| **Python** | Python 3.13, Google Colab |
| **Data Processing** | Pandas, NumPy |
| **Visualization** | Matplotlib, Seaborn, Plotly |
| **Dataset** | TheLook eCommerce (BigQuery Public + Kaggle CSV) |
| **Version Control** | Git, GitHub |

---

## 🚀 How to Run

### SQL Queries (BigQuery)

1. Go to https://console.cloud.google.com/bigquery
2. Sign in with Google account
3. Star project: bigquery-public-data
4. Navigate to: bigquery-public-data.thelook_ecommerce
5. Copy any .sql file from Queries/ folder
6. Paste → Run → View Results

> **Cost:** FREE (within 1TB/month BigQuery free tier)

### Python Notebook (Colab)
1. Go to https://colab.research.google.com/
2. Upload: Python_E_Commerce_Analytics.ipynb
3. Download dataset from Kaggle (7 CSV files)
4. Upload CSVs to Colab file system
5. Run all cells (Runtime → Run All)

> **Cost:** FREE (Colab free tier)

---

## 📊 Sample Visualizations

| Cohort Retention Heatmap | Conversion Funnel | RFM Segmentation |
|:---:|:---:|:---:|
| Customer retention by month | User journey drop-off | Behavioral segments |

| Pareto Analysis | Revenue Trend | Geographic Performance |
|:---:|:---:|:---:|
| 80/20 product rule | Monthly growth | Revenue by region |

---

## 📚 Skills Demonstrated

**SQL:**
- Window Functions (`ROW_NUMBER`, `RANK`, `DENSE_RANK`, `NTILE`, `LAG`, `LEAD`)
- Running Totals & Moving Averages
- Cohort Analysis & Retention Curves
- RFM Segmentation
- Islands & Gaps Pattern
- Market Basket / Association Rules
- Pareto (80/20) Analysis
- Conversion Funnel Analysis
- Query Optimization & Execution Plans

**Python:**
- Data Cleaning & Transformation
- Exploratory Data Analysis (EDA)
- Statistical Aggregation
- Professional Data Visualization
- Dashboard Creation
- Business Insight Generation

---

## 📞 Connect

| Platform | Link |
|----------|------|
| **GitHub** | [MdMahamudulHasan](https://github.com/MdMahamudulHasan) |
| **LinkedIn** | [www.linkedin.com/in/md-mahamudul-hasan-373618334) |


---

## 📝 License

This project is open-source and available under the [MIT License](LICENSE).

---

> *"Data is the new oil, but analytics is the refinery."* 🛢️➡️⛽
> 
