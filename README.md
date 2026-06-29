# 🛒 Flipkart Sales Analysis — End-to-End Data Analyst Project

![Tools](https://img.shields.io/badge/Tools-Excel%20%7C%20SQL%20%7C%20Power%20BI-2874F0?style=flat-square)
![Status](https://img.shields.io/badge/Status-Complete-success?style=flat-square)

An end-to-end data analytics project on a 20,000-product Flipkart e-commerce
dataset — covering data cleaning in **Excel**, analysis in **SQL**, and an
interactive 4-page dashboard in **Power BI**.

---

## 📌 Project Overview

| | |
|---|---|
| **Dataset** | Flipkart e-commerce catalog — 20,000 products |
| **Revenue analyzed** | ₹20.4 Crore |
| **Tools used** | Excel, SQL (T-SQL syntax), Power BI, DAX |
| **Time period** | Apr – Dec 2023 |
| **Geography** | 6 Indian cities (Bengaluru, Mumbai, Delhi, Chennai, Hyderabad, Pune) |
| **Categories** | 33 product categories |

---

## 🎯 Business Questions Answered

1. Which categories and products drive the most revenue?
2. Does deeper discounting actually increase sales volume, or just erode margin?
3. How does product rating relate to sales performance?
4. What does the monthly revenue trend look like — any seasonality?
5. Which cities are premium vs. value markets, and how does pricing vary by city?

---

## 🧹 Step 1: Data Cleaning (Excel)

Raw data had several real-world quality issues that needed handling before
analysis:

- **90% of products had `product_rating = 0`** — investigated and confirmed
  this meant *"not yet rated"*, not a genuine zero score. Created a
  `rating_status` flag (Rated / Not Rated) in the cleaned dataset and
  excluded unrated products from average-rating calculations so they
  didn't silently skew results downward.
- **78 missing `discounted_price` values** — estimated using
  `retail_price × (1 − discount_pct)`, consistent with how the field was
  derived everywhere else in the dataset.
- **Missing `brand` values** — filled as `"Unknown"` rather than dropped,
  to preserve revenue/units contribution, then excluded from brand-level
  rankings in the dashboard.
- Parsed `order_date` into a proper date type and engineered `price_band`,
  `discount_band`, `month`, `quarter`, and `weekday` columns to support
  segment-level analysis downstream.

Cleaned output: [`flipkart_cleaned.csv`](./flipkart_cleaned.csv)

**A bug I caught and fixed myself:** an early SQL draft applied
`WHERE product_rating > 0` to category-revenue queries — which silently
excluded ~90% of the dataset (the unrated products) from revenue totals,
massively understating real category performance (e.g. Clothing's revenue
looked like ₹80L instead of the real ₹7.05 Cr). Caught it with a data
quality check and fixed it by moving the rating filter inside the `AVG()`
only — documented with before/after comments in the SQL file below.

---

## 🗃️ Step 2: SQL Analysis

7 analysis queries in [`Flipkart_SQL_Corrected_Final.sql`](./Flipkart_SQL_Corrected_Final.sql):

1. **Category-wise revenue** — revenue, units, avg discount, avg rating
2. **Top 10 best-selling products** by revenue
3. **Discount-bucket impact** on units sold and revenue
4. **Rating-band vs. sales performance**
5. **Monthly revenue trend**
6. **City-wise demand** with a Premium / Mid-Range / Value market segmentation
7. **Data quality check** — Rated vs. Not Rated split (the query that caught the bug above)

---

## 📊 Step 3: Power BI Dashboard

A 4-page interactive dashboard built on a star schema with DAX
time-intelligence measures (MoM growth via `DATEADD`) rather than
hardcoded period comparisons.

### Executive Overview
![Executive Overview](https://github.com/bhardwajrenuka94/Flipkart-Sales-Analysis/blob/main/page1_overview.png.png)

### Sales Deep-Dive
![Sales Deep-Dive](https://github.com/bhardwajrenuka94/Flipkart-Sales-Analysis/blob/main/page2_sales.png.png)

### Discount & Pricing Analysis
![Discount & Pricing Analysis](https://github.com/bhardwajrenuka94/Flipkart-Sales-Analysis/blob/main/page3_discount.png.png)

### Product & Rating Insights
![Product & Rating Insights](https://github.com/bhardwajrenuka94/Flipkart-Sales-Analysis/blob/main/page4_product.png.png)

| Page | Contents |
|---|---|
| **Executive Overview** | 4 slicers, KPI cards (Revenue, Units, Orders, Avg Discount), monthly revenue trend, revenue by city, revenue by category (treemap) |
| **Sales Deep-Dive** | Category performance table, revenue by weekday, top products table |
| **Discount & Pricing Analysis** | Avg discount KPI, revenue by discount band, revenue by price band, discount % vs. units sold (scatter, bubble = revenue) |
| **Product & Rating Insights** | Rated vs. not-rated split, revenue by brand, avg rating by category, "hidden gems" table (high-rated, low-revenue products) |

Theme: custom Flipkart-branded color palette (`#2874F0` blue / `#FFE11B` yellow).

Dashboard file: [`Flipkart_Sales_Dashboard.pbix`](./Flipkart_Sales_Dashboard.pbix)
*(open in Power BI Desktop)*

---

## 📈 Key Findings

- **Clothing (₹7.05 Cr) and Jewellery (₹3.64 Cr)** are the top two revenue
  categories — together over half of total revenue.
- **Heavy discounts (50%+) drive the most revenue and unit volume** of any
  discount band — but the relationship isn't strictly linear across bands,
  suggesting discount depth alone doesn't fully explain demand.
- **Rating and revenue aren't strongly linked** — several high-rated (4.5+)
  products generate very little revenue ("hidden gems"), while plenty of
  top-revenue products have no rating yet.
- **Mid-range and Premium price bands** drive the most revenue, more than
  Budget or Luxury — most buyers are clustering in the middle of the price
  spectrum.
- Revenue is **fairly stable across cities and weekdays** in this dataset —
  no single city or day dominates disproportionately, suggesting consistent
  demand rather than concentrated spikes.

---

## 🛠️ Tech Stack

`SQL` `Excel (data cleaning)` `Power BI` `DAX`

---

## 📁 Files in This Repo

| File | Description |
|---|---|
| `flipkart_cleaned.csv` | Cleaned dataset, ready for SQL/Power BI |
| `Flipkart_SQL_Corrected_Final.sql` | 7 analysis queries, with inline bug-fix documentation |
| `Flipkart_Sales_Dashboard.pbix` | Full 4-page Power BI dashboard |

---

*Built by Renuka Bhardwaj as part of a Data Analyst portfolio project.*
