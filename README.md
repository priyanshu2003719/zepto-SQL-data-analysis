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



Now I have a thorough understanding of the dataset. Let me build a comprehensive, impressive PostgreSQL project document.Here's the complete breakdown of everything in the interactive guide above:

---

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






