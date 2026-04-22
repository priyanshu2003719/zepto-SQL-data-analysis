# zepto-SQL-data-analysis
Real E-commerce Data Analysis using PostgreSQL | Zepto Inventory Dataset 


# 🛒 Zepto E-commerce SQL Data Analyst Portfolio Project
This is a complete, real-world data analyst portfolio project based on an e-commerce inventory dataset scraped from [Zepto](https://www.zeptonow.com/) — one of India’s fastest-growing quick-commerce startups. This project simulates real analyst workflows, from raw data exploration to business-focused data analysis.

## 📌 Project Overview

The goal is to simulate how actual data analysts in the e-commerce or retail industries work behind the scenes to use SQL to:

✅ Set up a messy, real-world e-commerce inventory **database**

✅ Perform **Exploratory Data Analysis (EDA)** to explore product categories, availability, and pricing inconsistencies

✅ Implement **Data Cleaning** to handle null values, remove invalid entries, and convert pricing from paise to rupees

✅ Write **business-driven SQL queries** to derive insights around **pricing, inventory, stock availability, revenue** and more

## 📁 Dataset Overview
The dataset was sourced from [Kaggle](https://www.kaggle.com/datasets/palvinder2006/zepto-inventory-dataset/data?select=zepto_v2.csv) and was originally scraped from Zepto’s official product listings. It mimics what you’d typically encounter in a real-world e-commerce inventory system.

Each row represents a unique SKU (Stock Keeping Unit) for a product. Duplicate product names exist because the same product may appear multiple times in different package sizes, weights, discounts, or categories to improve visibility – exactly how real catalog data looks.

🧾 Columns:
- **sku_id:** Unique identifier for each product entry (Synthetic Primary Key)

- **name:** Product name as it appears on the app

- **category:** Product category like Fruits, Snacks, Beverages, etc.

- **mrp:** Maximum Retail Price (originally in paise, converted to ₹)

- **discountPercent:** Discount applied on MRP

- **discountedSellingPrice:** Final price after discount (also converted to ₹)

- **availableQuantity:** Units available in inventory

- **weightInGms:** Product weight in grams

- **outOfStock:** Boolean flag indicating stock availability

- **quantity:** Number of units per package (mixed with grams for loose produce)

## 🔧 Project Workflow

Here’s a step-by-step breakdown of what we do in this project:

### 1. Database & Table Creation
We start by creating a SQL table with appropriate data types:

```sql
CREATE TABLE zepto (
  sku_id SERIAL PRIMARY KEY,
  category VARCHAR(120),
  name VARCHAR(150) NOT NULL,
  mrp NUMERIC(8,2),
  discountPercent NUMERIC(5,2),
  availableQuantity INTEGER,
  discountedSellingPrice NUMERIC(8,2),
  weightInGms INTEGER,
  outOfStock BOOLEAN,
  quantity INTEGER
);
```

### 2. Data Import
- Loaded CSV using pgAdmin's import feature.

 - If you're not able to use the import feature, write this code instead:
```sql
   \copy zepto(category,name,mrp,discountPercent,availableQuantity,
            discountedSellingPrice,weightInGms,outOfStock,quantity)
  FROM 'data/zepto_v2.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"', ENCODING 'UTF8');
```
- Faced encoding issues (UTF-8 error), which were fixed by saving the CSV file using CSV UTF-8 format.

### 3. 🔍 Data Exploration
- Counted the total number of records in the dataset

- Viewed a sample of the dataset to understand structure and content

- Checked for null values across all columns

- Identified distinct product categories available in the dataset

- Compared in-stock vs out-of-stock product counts

- Detected products present multiple times, representing different SKUs

### 4. 🧹 Data Cleaning
- Identified and removed rows where MRP or discounted selling price was zero

- Converted mrp and discountedSellingPrice from paise to rupees for consistency and readability
  
### 5. 📊 Business Insights
- Found top 10 best-value products based on discount percentage

- Identified high-MRP products that are currently out of stock

- Estimated potential revenue for each product category

- Filtered expensive products (MRP > ₹500) with minimal discount

- Ranked top 5 categories offering highest average discounts

- Calculated price per gram to identify value-for-money products

- Grouped products based on weight into Low, Medium, and Bulk categories

- Measured total inventory weight per product category


## 🛠️ How to Use This Project

1. **Open zepto_SQL_data_analysis.sql**

    This file contains:

      - Table creation

      - Data exploration

      - Data cleaning

      - SQL Business analysis
  
2. **Load the dataset into pgAdmin or any other PostgreSQL client**

      - Create a database and run the SQL file

      - Import the dataset (convert to UTF-8 if necessary)



## 📜 License

MIT — feel free to fork, star, and use in your portfolio.




<style>
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body { font-family: var(--font-sans); color: var(--color-text-primary); }
  .wrap { padding: 1rem 0; }
  .header { margin-bottom: 1.5rem; }
  .header h1 { font-size: 20px; font-weight: 500; margin-bottom: 6px; }
  .header p { font-size: 14px; color: var(--color-text-secondary); }
  .schema-box { background: var(--color-background-secondary); border: 0.5px solid var(--color-border-tertiary); border-radius: var(--border-radius-lg); padding: 1rem 1.25rem; margin-bottom: 1.5rem; }
  .schema-box h2 { font-size: 15px; font-weight: 500; margin-bottom: 10px; }
  .cols { display: flex; flex-wrap: wrap; gap: 8px; }
  .col-badge { font-size: 12px; padding: 4px 10px; border-radius: 20px; font-family: var(--font-mono); }
  .cb-int { background: #E6F1FB; color: #0C447C; }
  .cb-str { background: #EAF3DE; color: #27500A; }
  .cb-bool { background: #FAEEDA; color: #633806; }
  .section-label { font-size: 12px; font-weight: 500; color: var(--color-text-secondary); text-transform: uppercase; letter-spacing: 0.04em; margin-bottom: 8px; margin-top: 1.5rem; }
  .q-card { background: var(--color-background-primary); border: 0.5px solid var(--color-border-tertiary); border-radius: var(--border-radius-lg); margin-bottom: 12px; overflow: hidden; }
  .q-header { display: flex; align-items: center; gap: 10px; padding: 12px 14px; cursor: pointer; }
  .q-header:hover { background: var(--color-background-secondary); }
  .level-badge { font-size: 11px; padding: 3px 9px; border-radius: 20px; font-weight: 500; white-space: nowrap; }
  .lv-basic { background: #EAF3DE; color: #3B6D11; }
  .lv-inter { background: #FAEEDA; color: #854F0B; }
  .lv-adv { background: #FCEBEB; color: #A32D2D; }
  .q-title { font-size: 14px; font-weight: 500; flex: 1; }
  .q-arrow { font-size: 12px; color: var(--color-text-secondary); transition: transform 0.2s; }
  .q-arrow.open { transform: rotate(90deg); }
  .q-body { display: none; padding: 0 14px 14px; border-top: 0.5px solid var(--color-border-tertiary); }
  .q-body.show { display: block; }
  .q-desc { font-size: 13px; color: var(--color-text-secondary); margin: 10px 0 8px; line-height: 1.5; }
  pre { background: var(--color-background-secondary); border-radius: 8px; padding: 12px 14px; font-size: 12px; font-family: var(--font-mono); overflow-x: auto; white-space: pre-wrap; word-break: break-word; color: var(--color-text-primary); border: 0.5px solid var(--color-border-tertiary); }
  .kw { color: #185FA5; font-weight: 500; }
  .fn { color: #3B6D11; }
  .cm { color: var(--color-text-secondary); font-style: italic; }
  .str2 { color: #854F0B; }
  .insight { background: #E6F1FB; border-left: 3px solid #378ADD; border-radius: 0 8px 8px 0; padding: 8px 12px; font-size: 12px; color: #0C447C; margin-top: 10px; line-height: 1.5; }
  .tabs { display: flex; gap: 6px; margin-bottom: 12px; flex-wrap: wrap; }
  .tab { font-size: 12px; padding: 6px 12px; border-radius: 20px; border: 0.5px solid var(--color-border-secondary); cursor: pointer; background: transparent; color: var(--color-text-secondary); }
  .tab.active { background: var(--color-background-info); color: var(--color-text-info); border-color: var(--color-border-info); }
  .stats-row { display: grid; grid-template-columns: repeat(auto-fit, minmax(130px, 1fr)); gap: 8px; margin-bottom: 1.5rem; }
  .stat { background: var(--color-background-secondary); border-radius: var(--border-radius-md); padding: 12px; }
  .stat-val { font-size: 22px; font-weight: 500; }
  .stat-lbl { font-size: 12px; color: var(--color-text-secondary); margin-top: 2px; }
</style>

<div class="wrap">
  <div class="header">
    <h1>Zepto Grocery Data — PostgreSQL project guide</h1>
    <p>3,732 products · 14 categories · 9 columns — full analysis &amp; SQL solutions</p>
  </div>

  <div class="stats-row">
    <div class="stat"><div class="stat-val">3,732</div><div class="stat-lbl">Total products</div></div>
    <div class="stat"><div class="stat-val">14</div><div class="stat-lbl">Categories</div></div>
    <div class="stat"><div class="stat-val">453</div><div class="stat-lbl">Out of stock</div></div>
    <div class="stat"><div class="stat-val">₹2,60,000</div><div class="stat-lbl">Max MRP</div></div>
  </div>

  <div class="schema-box">
    <h2>Table schema — zepto_products</h2>
    <div class="cols">
      <span class="col-badge cb-str">category (TEXT)</span>
      <span class="col-badge cb-str">name (TEXT)</span>
      <span class="col-badge cb-int">mrp (INT)</span>
      <span class="col-badge cb-int">discount_percent (INT)</span>
      <span class="col-badge cb-int">available_quantity (INT)</span>
      <span class="col-badge cb-int">discounted_selling_price (INT)</span>
      <span class="col-badge cb-int">weight_in_gms (INT)</span>
      <span class="col-badge cb-bool">out_of_stock (BOOLEAN)</span>
      <span class="col-badge cb-int">quantity (INT)</span>
    </div>
    <div style="margin-top:10px; font-size:12px; color:var(--color-text-secondary);">Note: MRP &amp; selling price stored in paise (÷100 = ₹). Weight in grams.</div>
  </div>

  <div class="tabs" id="levelTabs">
    <button class="tab active" data-level="all">All questions</button>
    <button class="tab" data-level="basic">Basic</button>
    <button class="tab" data-level="intermediate">Intermediate</button>
    <button class="tab" data-level="advanced">Advanced</button>
  </div>

  <div id="questions"></div>
</div>

<script>
const qs = [
  {
    id: 1, level: "basic",
    title: "Q1 — Create the table and load the data",
    desc: "First step in every project: define a clean schema with proper data types and constraints.",
    sql: `<span class="kw">CREATE TABLE</span> zepto_products (
  id          SERIAL <span class="kw">PRIMARY KEY</span>,
  category    TEXT    <span class="kw">NOT NULL</span>,
  name        TEXT    <span class="kw">NOT NULL</span>,
  mrp         INT,     <span class="cm">-- in paise</span>
  discount_percent    INT,
  available_quantity  INT,
  discounted_selling_price INT,
  weight_in_gms       INT,
  out_of_stock        BOOLEAN,
  quantity            INT
);

<span class="cm">-- Load from CSV (server-side)</span>
<span class="kw">COPY</span> zepto_products(category, name, mrp, discount_percent,
  available_quantity, discounted_selling_price,
  weight_in_gms, out_of_stock, quantity)
<span class="kw">FROM</span> <span class="str2">'/path/to/zepto_v2.csv'</span>
<span class="kw">DELIMITER</span> <span class="str2">','</span> <span class="kw">CSV HEADER</span>;`,
    insight: "Interview tip: always discuss WHY you chose INT for price (paise precision), BOOLEAN for flags, and SERIAL for surrogate keys."
  },
  {
    id: 2, level: "basic",
    title: "Q2 — Basic data profiling & quality check",
    desc: "Understand the dataset shape, null rates, and value distribution before any business queries.",
    sql: `<span class="cm">-- Row count and column nulls</span>
<span class="kw">SELECT</span>
  <span class="fn">COUNT</span>(*) <span class="kw">AS</span> total_rows,
  <span class="fn">COUNT</span>(mrp)       <span class="kw">AS</span> mrp_non_null,
  <span class="fn">COUNT</span>(weight_in_gms) <span class="kw">AS</span> weight_non_null,
  <span class="fn">ROUND</span>(<span class="fn">AVG</span>(discount_percent), 2) <span class="kw">AS</span> avg_discount,
  <span class="fn">MAX</span>(mrp) / 100.0  <span class="kw">AS</span> max_mrp_rupees,
  <span class="fn">MIN</span>(mrp) / 100.0  <span class="kw">AS</span> min_mrp_rupees
<span class="kw">FROM</span> zepto_products;

<span class="cm">-- Category distribution</span>
<span class="kw">SELECT</span> category,
  <span class="fn">COUNT</span>(*) <span class="kw">AS</span> product_count,
  <span class="fn">ROUND</span>(<span class="fn">COUNT</span>(*) * 100.0 / <span class="fn">SUM</span>(<span class="fn">COUNT</span>(*)) <span class="kw">OVER</span>(), 1) <span class="kw">AS</span> pct_share
<span class="kw">FROM</span> zepto_products
<span class="kw">GROUP BY</span> category
<span class="kw">ORDER BY</span> product_count <span class="kw">DESC</span>;`,
    insight: "Using a window function inside an aggregate (COUNT(*) OVER()) is a common interview question. It avoids a subquery and runs in one pass."
  },
  {
    id: 3, level: "basic",
    title: "Q3 — Out-of-stock analysis by category",
    desc: "Identify which categories are most affected by stockouts — directly useful for Zepto's inventory team.",
    sql: `<span class="kw">SELECT</span>
  category,
  <span class="fn">COUNT</span>(*) <span class="kw">AS</span> total_products,
  <span class="fn">SUM</span>(<span class="kw">CASE WHEN</span> out_of_stock = <span class="kw">TRUE</span> <span class="kw">THEN</span> 1 <span class="kw">ELSE</span> 0 <span class="kw">END</span>) <span class="kw">AS</span> oos_count,
  <span class="fn">ROUND</span>(
    <span class="fn">SUM</span>(<span class="kw">CASE WHEN</span> out_of_stock = <span class="kw">TRUE</span> <span class="kw">THEN</span> 1 <span class="kw">ELSE</span> 0 <span class="kw">END</span>) * 100.0
    / <span class="fn">COUNT</span>(*), 1
  ) <span class="kw">AS</span> oos_rate_pct
<span class="kw">FROM</span> zepto_products
<span class="kw">GROUP BY</span> category
<span class="kw">HAVING</span> oos_count > 0
<span class="kw">ORDER BY</span> oos_rate_pct <span class="kw">DESC</span>;`,
    insight: "HAVING vs WHERE: always explain that HAVING filters after aggregation. Great talking point on query execution order."
  },
  {
    id: 4, level: "intermediate",
    title: "Q4 — Discount effectiveness & pricing tiers",
    desc: "Segment products into price tiers and measure how discounts are distributed — a key retail analytics pattern.",
    sql: `<span class="kw">SELECT</span>
  <span class="kw">CASE</span>
    <span class="kw">WHEN</span> mrp / 100.0 < 50   <span class="kw">THEN</span> <span class="str2">'Budget (< ₹50)'</span>
    <span class="kw">WHEN</span> mrp / 100.0 < 200  <span class="kw">THEN</span> <span class="str2">'Mid (₹50–₹200)'</span>
    <span class="kw">WHEN</span> mrp / 100.0 < 500  <span class="kw">THEN</span> <span class="str2">'Premium (₹200–₹500)'</span>
    <span class="kw">ELSE</span>                        <span class="str2">'Luxury (₹500+)'</span>
  <span class="kw">END</span> <span class="kw">AS</span> price_tier,
  <span class="fn">COUNT</span>(*) <span class="kw">AS</span> products,
  <span class="fn">ROUND</span>(<span class="fn">AVG</span>(discount_percent), 1) <span class="kw">AS</span> avg_discount_pct,
  <span class="fn">ROUND</span>(<span class="fn">AVG</span>(mrp - discounted_selling_price) / 100.0, 2) <span class="kw">AS</span> avg_saving_rs,
  <span class="fn">MAX</span>(discount_percent) <span class="kw">AS</span> max_discount
<span class="kw">FROM</span> zepto_products
<span class="kw">GROUP BY</span> price_tier
<span class="kw">ORDER BY</span> <span class="fn">MIN</span>(mrp);`,
    insight: "Business insight to mention: if luxury items carry the highest discounts, Zepto may be using loss-leader pricing to drive basket size."
  },
  {
    id: 5, level: "intermediate",
    title: "Q5 — Top 5 products per category by discount",
    desc: "Use RANK() window function to find best-discounted products in each category — a classic N-per-group problem.",
    sql: `<span class="kw">WITH</span> ranked <span class="kw">AS</span> (
  <span class="kw">SELECT</span>
    category, name, mrp / 100.0 <span class="kw">AS</span> mrp_rs,
    discount_percent,
    discounted_selling_price / 100.0 <span class="kw">AS</span> selling_price_rs,
    <span class="fn">RANK</span>() <span class="kw">OVER</span> (
      <span class="kw">PARTITION BY</span> category
      <span class="kw">ORDER BY</span> discount_percent <span class="kw">DESC</span>
    ) <span class="kw">AS</span> rnk
  <span class="kw">FROM</span> zepto_products
  <span class="kw">WHERE</span> out_of_stock = <span class="kw">FALSE</span>
)
<span class="kw">SELECT</span> * <span class="kw">FROM</span> ranked
<span class="kw">WHERE</span> rnk <= 5
<span class="kw">ORDER BY</span> category, rnk;`,
    insight: "Interviewers love this pattern. Explain the difference between RANK(), DENSE_RANK(), and ROW_NUMBER() — all three are fair game."
  },
  {
    id: 6, level: "intermediate",
    title: "Q6 — Price-per-gram value analysis",
    desc: "Calculate and compare value-for-money across categories — a real metric Zepto buyers would track.",
    sql: `<span class="kw">SELECT</span>
  category,
  name,
  discounted_selling_price / 100.0 <span class="kw">AS</span> price_rs,
  weight_in_gms,
  <span class="fn">ROUND</span>(
    (discounted_selling_price / 100.0) / <span class="fn">NULLIF</span>(weight_in_gms, 0),
    4
  ) <span class="kw">AS</span> rs_per_gram,
  <span class="fn">RANK</span>() <span class="kw">OVER</span> (
    <span class="kw">PARTITION BY</span> category
    <span class="kw">ORDER BY</span>
      (discounted_selling_price / 100.0) / <span class="fn">NULLIF</span>(weight_in_gms, 0)
  ) <span class="kw">AS</span> value_rank
<span class="kw">FROM</span> zepto_products
<span class="kw">WHERE</span> weight_in_gms > 0
  <span class="kw">AND</span> out_of_stock = <span class="kw">FALSE</span>
<span class="kw">ORDER BY</span> category, value_rank;`,
    insight: "NULLIF(weight_in_gms, 0) prevents division-by-zero errors. Mentioning this guards against runtime errors — interviewers notice."
  },
  {
    id: 7, level: "intermediate",
    title: "Q7 — Inventory value at risk from stockouts",
    desc: "Estimate revenue at risk by calculating potential GMV lost due to out-of-stock products per category.",
    sql: `<span class="kw">SELECT</span>
  category,
  <span class="fn">COUNT</span>(*) <span class="kw">FILTER</span> (<span class="kw">WHERE</span> out_of_stock = <span class="kw">TRUE</span>) <span class="kw">AS</span> oos_skus,
  <span class="fn">SUM</span>(discounted_selling_price * quantity / 100.0)
    <span class="kw">FILTER</span> (<span class="kw">WHERE</span> out_of_stock = <span class="kw">TRUE</span>) <span class="kw">AS</span> revenue_at_risk_rs,
  <span class="fn">SUM</span>(discounted_selling_price * quantity / 100.0) <span class="kw">AS</span> total_gmv_rs,
  <span class="fn">ROUND</span>(
    <span class="fn">SUM</span>(discounted_selling_price * quantity / 100.0)
      <span class="kw">FILTER</span> (<span class="kw">WHERE</span> out_of_stock = <span class="kw">TRUE</span>) * 100.0
    / <span class="fn">NULLIF</span>(<span class="fn">SUM</span>(discounted_selling_price * quantity / 100.0), 0)
  , 2) <span class="kw">AS</span> risk_pct
<span class="kw">FROM</span> zepto_products
<span class="kw">GROUP BY</span> category
<span class="kw">ORDER BY</span> revenue_at_risk_rs <span class="kw">DESC NULLS LAST</span>;`,
    insight: "The FILTER clause (PostgreSQL 9.4+) is more readable than nested CASE WHEN for conditional aggregation. Showing this impresses interviewers."
  },
  {
    id: 8, level: "advanced",
    title: "Q8 — Category-level discount cohort with percentile buckets",
    desc: "Use NTILE() to bucket products into discount quartiles and compare them within each category — advanced analytics.",
    sql: `<span class="kw">WITH</span> bucketed <span class="kw">AS</span> (
  <span class="kw">SELECT</span>
    category, name, discount_percent,
    <span class="fn">NTILE</span>(4) <span class="kw">OVER</span> (
      <span class="kw">PARTITION BY</span> category
      <span class="kw">ORDER BY</span> discount_percent
    ) <span class="kw">AS</span> quartile
  <span class="kw">FROM</span> zepto_products
  <span class="kw">WHERE</span> discount_percent > 0
)
<span class="kw">SELECT</span>
  category,
  quartile,
  <span class="fn">COUNT</span>(*) <span class="kw">AS</span> products,
  <span class="fn">MIN</span>(discount_percent) <span class="kw">AS</span> min_disc,
  <span class="fn">MAX</span>(discount_percent) <span class="kw">AS</span> max_disc,
  <span class="fn">ROUND</span>(<span class="fn">AVG</span>(discount_percent), 1) <span class="kw">AS</span> avg_disc
<span class="kw">FROM</span> bucketed
<span class="kw">GROUP BY</span> category, quartile
<span class="kw">ORDER BY</span> category, quartile;`,
    insight: "NTILE() is less common than RANK() so using it signals advanced window function knowledge. Great for showing depth."
  },
  {
    id: 9, level: "advanced",
    title: "Q9 — Running total & cumulative inventory share",
    desc: "Build a Pareto (80/20) analysis on inventory quantity — which top categories account for 80% of all stock?",
    sql: `<span class="kw">WITH</span> cat_inv <span class="kw">AS</span> (
  <span class="kw">SELECT</span>
    category,
    <span class="fn">SUM</span>(available_quantity) <span class="kw">AS</span> total_qty
  <span class="kw">FROM</span> zepto_products
  <span class="kw">GROUP BY</span> category
),
running <span class="kw">AS</span> (
  <span class="kw">SELECT</span>
    category, total_qty,
    <span class="fn">SUM</span>(total_qty) <span class="kw">OVER</span> (
      <span class="kw">ORDER BY</span> total_qty <span class="kw">DESC</span>
      <span class="kw">ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW</span>
    ) <span class="kw">AS</span> running_qty,
    <span class="fn">SUM</span>(total_qty) <span class="kw">OVER</span> () <span class="kw">AS</span> grand_total
  <span class="kw">FROM</span> cat_inv
)
<span class="kw">SELECT</span>
  category, total_qty,
  <span class="fn">ROUND</span>(running_qty * 100.0 / grand_total, 1) <span class="kw">AS</span> cumulative_pct,
  <span class="kw">CASE WHEN</span> running_qty * 100.0 / grand_total <= 80
    <span class="kw">THEN</span> <span class="str2">'Top 80%'</span> <span class="kw">ELSE</span> <span class="str2">'Tail 20%'</span>
  <span class="kw">END</span> <span class="kw">AS</span> pareto_group
<span class="kw">FROM</span> running
<span class="kw">ORDER BY</span> total_qty <span class="kw">DESC</span>;`,
    insight: "Using ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW is the correct frame clause for running totals. Many candidates forget this — it stands out."
  },
  {
    id: 10, level: "advanced",
    title: "Q10 — Stored procedure: restock alert generator",
    desc: "Write a reusable function that returns low-stock, in-demand products for a given category — interview + real-world gold.",
    sql: `<span class="kw">CREATE OR REPLACE FUNCTION</span> <span class="fn">get_restock_alerts</span>(
  p_category      TEXT,
  p_stock_thresh  INT <span class="kw">DEFAULT</span> 50,
  p_discount_min  INT <span class="kw">DEFAULT</span> 5
)
<span class="kw">RETURNS TABLE</span> (
  product_name       TEXT,
  available_stock    INT,
  discount_pct       INT,
  selling_price_rs   NUMERIC,
  urgency_score      NUMERIC
) <span class="kw">LANGUAGE</span> plpgsql <span class="kw">AS</span> $$
<span class="kw">BEGIN</span>
  <span class="kw">RETURN QUERY</span>
  <span class="kw">SELECT</span>
    name,
    available_quantity,
    discount_percent,
    discounted_selling_price / 100.0,
    <span class="cm">-- urgency = demand proxy (discount) / stock level</span>
    <span class="fn">ROUND</span>(discount_percent::NUMERIC /
      <span class="fn">NULLIF</span>(available_quantity, 0), 4)
  <span class="kw">FROM</span> zepto_products
  <span class="kw">WHERE</span> category = p_category
    <span class="kw">AND</span> out_of_stock = <span class="kw">FALSE</span>
    <span class="kw">AND</span> available_quantity < p_stock_thresh
    <span class="kw">AND</span> discount_percent >= p_discount_min
  <span class="kw">ORDER BY</span> urgency_score <span class="kw">DESC</span>;
<span class="kw">END</span>;
$$;

<span class="cm">-- Usage</span>
<span class="kw">SELECT</span> * <span class="kw">FROM</span> <span class="fn">get_restock_alerts</span>(<span class="str2">'Fruits & Vegetables'</span>, 30, 10);`,
    insight: "Writing a parameterized function shows you think in systems, not just queries. The urgency_score metric also shows business thinking."
  },
  {
    id: 11, level: "advanced",
    title: "Q11 — Create a materialized view for a BI dashboard",
    desc: "Pre-aggregate category-level KPIs into a materialized view — shows understanding of performance optimization for reporting.",
    sql: `<span class="kw">CREATE MATERIALIZED VIEW</span> mv_category_dashboard <span class="kw">AS</span>
<span class="kw">SELECT</span>
  category,
  <span class="fn">COUNT</span>(*) <span class="kw">AS</span> total_skus,
  <span class="fn">COUNT</span>(*) <span class="kw">FILTER</span>(<span class="kw">WHERE</span> out_of_stock = <span class="kw">FALSE</span>) <span class="kw">AS</span> live_skus,
  <span class="fn">ROUND</span>(<span class="fn">AVG</span>(discount_percent), 1) <span class="kw">AS</span> avg_discount,
  <span class="fn">ROUND</span>(<span class="fn">AVG</span>(mrp) / 100.0, 2) <span class="kw">AS</span> avg_mrp_rs,
  <span class="fn">ROUND</span>(<span class="fn">AVG</span>(
    (mrp - discounted_selling_price) / 100.0
  ), 2) <span class="kw">AS</span> avg_saving_rs,
  <span class="fn">SUM</span>(available_quantity) <span class="kw">AS</span> total_stock_units,
  <span class="fn">ROUND</span>(<span class="fn">SUM</span>(discounted_selling_price * quantity) / 100.0, 0)
    <span class="kw">AS</span> potential_gmv_rs,
  <span class="fn">PERCENTILE_CONT</span>(0.5) <span class="kw">WITHIN GROUP</span>
    (<span class="kw">ORDER BY</span> discounted_selling_price / 100.0)
    <span class="kw">AS</span> median_price_rs
<span class="kw">FROM</span> zepto_products
<span class="kw">GROUP BY</span> category
<span class="kw">WITH DATA</span>;

<span class="cm">-- Refresh when data updates</span>
<span class="kw">REFRESH MATERIALIZED VIEW</span> mv_category_dashboard;

<span class="cm">-- Index for fast BI lookups</span>
<span class="kw">CREATE UNIQUE INDEX</span> ON mv_category_dashboard (category);`,
    insight: "PERCENTILE_CONT is an ordered-set aggregate — very rarely seen from junior analysts. Materialized views + index on top signals production-grade thinking."
  }
];

const container = document.getElementById('questions');
const tabs = document.querySelectorAll('.tab');

function render(level) {
  const filtered = level === 'all' ? qs : qs.filter(q => q.level === level);
  container.innerHTML = '';
  filtered.forEach(q => {
    const lvlClass = q.level === 'basic' ? 'lv-basic' : q.level === 'intermediate' ? 'lv-inter' : 'lv-adv';
    const lvlLabel = q.level.charAt(0).toUpperCase() + q.level.slice(1);
    const div = document.createElement('div');
    div.className = 'q-card';
    div.innerHTML = `
      <div class="q-header" data-id="${q.id}">
        <span class="level-badge ${lvlClass}">${lvlLabel}</span>
        <span class="q-title">${q.title}</span>
        <span class="q-arrow" id="arrow-${q.id}">&#9654;</span>
      </div>
      <div class="q-body" id="body-${q.id}">
        <p class="q-desc">${q.desc}</p>
        <pre>${q.sql}</pre>
        <div class="insight">${q.insight}</div>
      </div>`;
    container.appendChild(div);
  });

  document.querySelectorAll('.q-header').forEach(h => {
    h.addEventListener('click', () => {
      const id = h.dataset.id;
      const body = document.getElementById('body-' + id);
      const arrow = document.getElementById('arrow-' + id);
      const open = body.classList.toggle('show');
      arrow.classList.toggle('open', open);
    });
  });
}

tabs.forEach(tab => {
  tab.addEventListener('click', () => {
    tabs.forEach(t => t.classList.remove('active'));
    tab.classList.add('active');
    render(tab.dataset.level);
  });
});

render('all');
</script>


**Dataset overview** — The Zepto dataset has 3,732 grocery products across 14 categories (Cooking Essentials and Munchies dominate with 514 each), 9 columns with zero nulls, and 453 out-of-stock products (~12%). Prices are stored in paise so you divide by 100 to get ₹.

---

**The 11 questions are organized in three tiers:**

**Basic (Q1–Q3)** — Table creation with proper schema design, full data profiling using window functions inside aggregates, and a stockout rate analysis using `HAVING`. These establish you know SQL fundamentals and data quality thinking.

**Intermediate (Q4–Q7)** — Price tier segmentation with `CASE WHEN`, top-N per group using `RANK() OVER (PARTITION BY...)`, price-per-gram value analysis with `NULLIF` for safe division, and a revenue-at-risk calculation using the `FILTER` clause for conditional aggregation. These show business thinking and intermediate window function skill.

**Advanced (Q8–Q11)** — Discount quartile bucketing with `NTILE()`, a Pareto/80-20 analysis with running totals using proper frame clauses (`ROWS BETWEEN UNBOUNDED PRECEDING...`), a parameterized stored function with a custom urgency score, and finally a materialized view with `PERCENTILE_CONT` for a BI dashboard. These are the questions that make interviewers lean forward.

---

**What makes this resume-worthy:**
- It solves a real business problem (quick-commerce inventory, pricing, and discount strategy for a company like Zepto/Blinkit/Swiggy Instamart)
- Every query has a business interpretation you can narrate, not just technical syntax
- It covers the full stack: DDL → DML → aggregations → window functions → stored procedures → performance optimization

Click each question card to expand the SQL and the interview tip. Use the tabs to filter by difficulty level.






