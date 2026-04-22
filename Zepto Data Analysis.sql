drop table if exists zepto;

create table zepto (
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

--data exploration

--count of rows
select count(*) from zepto;

--sample data
SELECT * FROM zepto
LIMIT 10;

--null values
SELECT * FROM zepto
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountPercent IS NULL
OR
discountedSellingPrice IS NULL
OR
weightInGms IS NULL
OR
availableQuantity IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL;

--different product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

--products in stock vs out of stock
SELECT outOfStock, COUNT(sku_id)
FROM zepto
GROUP BY outOfStock;

--product names present multiple times
SELECT name, COUNT(sku_id) AS "Number of SKUs"
FROM zepto
GROUP BY name
HAVING count(sku_id) > 1
ORDER BY count(sku_id) DESC;

--data cleaning

--products with price = 0
SELECT * FROM zepto
WHERE mrp = 0 OR discountedSellingPrice = 0;

DELETE FROM zepto
WHERE mrp = 0;

--convert paise to rupees
UPDATE zepto
SET mrp = mrp / 100.0,
discountedSellingPrice = discountedSellingPrice / 100.0;

SELECT mrp, discountedSellingPrice FROM zepto;

--data analysis

-- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

--Q2.What are the Products with High MRP but Out of Stock

SELECT DISTINCT name,mrp
FROM zepto
WHERE outOfStock = TRUE and mrp > 300
ORDER BY mrp DESC;

--Q3.Calculate Estimated Revenue for each category
SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT category,
ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;

--Q7.Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
	WHEN weightInGms < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
FROM zepto;

--Q8.What is the Total Inventory Weight Per Category 
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;


--Q9. Basic data profiling & quality check

-- Table Statistics (Completeness & Volume)
SELECT 
    COUNT(*) AS total_rows,
    COUNT(sku_id) AS non_null_skus,
    COUNT(category) AS non_null_categories,
    COUNT(DISTINCT category) AS unique_categories,
    COUNT(DISTINCT name) AS unique_product_names
FROM zepto;

-- Statistical Profiling for Numeric Columns (Distribution)
SELECT 
    'MRP' AS metric, MIN(mrp) AS min_val, MAX(mrp) AS max_val, ROUND(AVG(mrp), 2) AS avg_val
FROM zepto
UNION ALL
SELECT 
    'Discount%' AS metric, MIN(discountPercent), MAX(discountPercent), ROUND(AVG(discountPercent), 2)
FROM zepto
UNION ALL
SELECT 
    'Stock Quantity' AS metric, MIN(availableQuantity), MAX(availableQuantity), ROUND(AVG(availableQuantity), 2)
FROM zepto;

-- Data Quality: Detailed Null & Empty Check
-- Analyzes which rows are null or empty for critical string columns
SELECT 
    column_name,
    SUM(CASE WHEN val IS NULL THEN 1 ELSE 0 END) AS null_count,
    SUM(CASE WHEN TRIM(val) = '' THEN 1 ELSE 0 END) AS empty_string_count
FROM (
    SELECT 'category' AS column_name, category AS val FROM zepto
    UNION ALL
    SELECT 'name', name FROM zepto
) AS combined_checks
GROUP BY column_name;

-- Data Quality: Duplicate Detection
-- Identifies if multiple SKUs exist for the exact same product name
SELECT name, COUNT(*) as occurrences
FROM zepto
GROUP BY name
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;

-- Price Relationship
-- To see Products & Prices:
SELECT 
    name, 
    mrp, 
    discountedSellingPrice, 
    (mrp - discountedSellingPrice) AS absolute_discount,
    ROUND(((mrp - discountedSellingPrice) / NULLIF(mrp, 0)) * 100, 2) AS calculated_discount_percent
FROM zepto
ORDER BY absolute_discount DESC;

--Finding Pricing Errors (Selling Price > MRP)
SELECT 
    sku_id, 
    name, 
    mrp, 
    discountedSellingPrice, 
    (discountedSellingPrice - mrp) AS overcharge_amount
FROM zepto
WHERE discountedSellingPrice > mrp;

-- Discount Percent Range
-- To see Valid Discounts (0% to 100%):
SELECT 
    CASE 
        WHEN discountPercent = 0 THEN 'No Discount (0%)'
        WHEN discountPercent <= 10 THEN 'Small Discount (1-10%)'
        WHEN discountPercent <= 30 THEN 'Medium Discount (11-30%)'
        WHEN discountPercent <= 50 THEN 'High Discount (31-50%)'
        ELSE 'Mega Sale (>50%)'
    END AS discount_range,
    COUNT(*) AS product_count,
    ROUND(AVG(mrp), 2) AS avg_mrp
FROM zepto
WHERE discountPercent BETWEEN 0 AND 100
GROUP BY 1
ORDER BY MIN(discountPercent);

-- To find Errors (Less than 0% or More than 100%):
SELECT 
    sku_id, 
    name, 
    category, 
    discountPercent
FROM zepto
WHERE discountPercent < 0 
   OR discountPercent > 100;

-- Stock Quantity
-- To see Products with Positive Stock:
SELECT 
    category, 
    COUNT(sku_id) AS total_skus,
    SUM(availableQuantity) AS total_units_available,
    MIN(availableQuantity) AS lowest_stock,
    MAX(availableQuantity) AS highest_stock
FROM zepto
WHERE availableQuantity > 0
GROUP BY category
ORDER BY total_units_available DESC;

-- To find Errors (Negative Stock):
SELECT 
    sku_id, 
    name, 
    category, 
    availableQuantity
FROM zepto
WHERE availableQuantity < 0;

-- Business Logic Validation (Integrity Checks)
SELECT 
    SUM(CASE WHEN mrp < discountedSellingPrice THEN 1 ELSE 0 END) AS price_anomaly_count, -- MRP should be >= Selling Price
    SUM(CASE WHEN discountPercent > 100 OR discountPercent < 0 THEN 1 ELSE 0 END) AS invalid_discount_count,
    SUM(CASE WHEN availableQuantity < 0 THEN 1 ELSE 0 END) AS negative_stock_count
FROM zepto;

-- Q10. Out-of-stock analysis by category
SELECT 
    category,
    -- Count of items out of stock
    COUNT(CASE WHEN outOfStock = TRUE THEN 1 END) AS out_of_stock_count,
    
    -- Percentage of category that is out of stock
    ROUND(
        100.0 * COUNT(CASE WHEN outOfStock = TRUE THEN 1 END) / COUNT(*), 
        2
    ) AS out_of_stock_percentage,
    
    -- Total products in category (for context)
    COUNT(*) AS total_category_products,
    
    -- Potential Revenue Impact (Total MRP value of unavailable stock)
    -- This assumes 'quantity' is the intended stock level or use mrp for lost opportunity
    SUM(CASE WHEN outOfStock = TRUE THEN mrp ELSE 0 END) AS lost_mrp_opportunity

FROM zepto
GROUP BY category
ORDER BY out_of_stock_percentage DESC;

-- Q11. Discount effectiveness & pricing tiers
-- Comprehensive Analysis: Pricing Tiers, Discount Depth, and Effectiveness
SELECT 
    CASE 
        WHEN mrp < 100 THEN '1. Budget (< ₹100)'
        WHEN mrp BETWEEN 100 AND 500 THEN '2. Mid-Range (₹100-₹500)'
        WHEN mrp BETWEEN 501 AND 1000 THEN '3. Premium (₹501-₹1000)'
        ELSE '4. Luxury (> ₹1000)'
    END AS price_tier,
    
    -- Volume & Inventory Metrics
    COUNT(*) AS total_products,
    SUM(availableQuantity) AS units_in_stock,
    
    -- Discount Effectiveness Metrics
    ROUND(AVG(discountPercent), 2) AS avg_discount_percent,
    COUNT(CASE WHEN discountPercent >= 30 THEN 1 END) AS deep_discount_count,
    COUNT(CASE WHEN discountPercent = 0 THEN 1 END) AS full_price_count,
    
    -- Financial Impact
    ROUND(AVG(mrp), 2) AS avg_mrp,
    ROUND(AVG(discountedSellingPrice), 2) AS avg_selling_price,
    SUM(mrp - discountedSellingPrice) AS total_margin_given_away,
    
    -- Quality Checks (Errors) within Tiers
    COUNT(CASE WHEN discountedSellingPrice > mrp THEN 1 END) AS pricing_errors_count,
    
    -- Value for Money (VFM) Logic
    ROUND(AVG(discountedSellingPrice / NULLIF(weightInGms, 0)), 4) AS avg_price_per_gram

FROM zepto
GROUP BY 1
ORDER BY 1;

-- Q12. Top 5 products per category by discount
-- Top 5 Highest Discounted Products per Category
WITH RankedProducts AS (
    SELECT 
        category,
        name,
        mrp,
        discountedSellingPrice,
        discountPercent,
        availableQuantity,
        -- Assigns a rank (1 to N) for products in each category based on discount
        ROW_NUMBER() OVER(
            PARTITION BY category 
            ORDER BY discountPercent DESC, mrp DESC
        ) as rank_in_category
    FROM zepto
    WHERE discountPercent > 0 
)
SELECT 
    category,
    rank_in_category AS rank,
    name,
    mrp,
    discountPercent,
    discountedSellingPrice
FROM RankedProducts
WHERE rank_in_category <= 5
ORDER BY category, rank_in_category;

--Q13. Price-per-gram value analysis
-- Price-per-gram Value Analysis
SELECT 
    category,
    name,
    weightInGms,
    discountedSellingPrice,
    -- Calculate price per 1 gram
    ROUND(CAST(discountedSellingPrice AS NUMERIC) / NULLIF(weightInGms, 0), 4) AS price_per_gram,
    -- Calculate price per 100 grams (often easier for users to read)
    ROUND((CAST(discountedSellingPrice AS NUMERIC) / NULLIF(weightInGms, 0)) * 100, 2) AS price_per_100g,
    discountPercent,
    -- Labeling value deals
    CASE 
        WHEN (discountedSellingPrice / NULLIF(weightInGms, 0)) < (AVG(discountedSellingPrice / NULLIF(weightInGms, 0)) OVER(PARTITION BY category)) 
        THEN 'Better than Category Avg'
        ELSE 'Above Category Avg'
    END AS value_status
FROM zepto
WHERE weightInGms > 0 AND outOfStock = FALSE
ORDER BY category, price_per_gram ASC;

--Q14.Inventory value at risk from stockouts
-- Inventory Value at Risk (Revenue Opportunity Loss)
SELECT 
    category,
    -- 1. Count of missing options for customers
    COUNT(sku_id) AS out_of_stock_skus,
    
    -- 2. Total potential revenue lost (if we sold just 1 unit of each OOS item)
    SUM(discountedSellingPrice) AS potential_revenue_loss_single_unit,
    
    -- 3. Weighted loss (using average quantity of similar in-stock items as a proxy for demand)
    ROUND(SUM(discountedSellingPrice * (
        SELECT AVG(availableQuantity) FROM zepto z2 WHERE z2.category = zepto.category AND z2.outOfStock = FALSE
    )), 2) AS estimated_total_value_at_risk,
    
    -- 4. Impact Severity
    CASE 
        WHEN COUNT(sku_id) > 10 THEN 'High Priority Restock'
        WHEN SUM(discountedSellingPrice) > 1000 THEN 'High Value Loss'
        ELSE 'Monitor'
    END AS stockout_severity

FROM zepto
WHERE outOfStock = TRUE
GROUP BY category
ORDER BY estimated_total_value_at_risk DESC;

--Q15.Category-level discount cohort with percentile buckets
-- Category-level Discount Cohort with Percentile Buckets
WITH CategoryStats AS (
    SELECT 
        category,
        ROUND(AVG(discountPercent), 2) AS avg_discount,
        COUNT(*) AS product_count,
        SUM(CASE WHEN discountPercent > 0 THEN 1 ELSE 0 END) AS discounted_items_count
    FROM zepto
    GROUP BY category
),
CategoryBuckets AS (
    SELECT 
        *,
        -- Divide categories into 4 buckets (Quartiles) based on avg discount
        NTILE(4) OVER(ORDER BY avg_discount DESC) AS discount_cohort_rank
    FROM CategoryStats
)
SELECT 
    category,
    avg_discount,
    product_count,
    -- Labeling the cohorts for business interpretation
    CASE 
        WHEN discount_cohort_rank = 1 THEN 'Tier 1: Aggressive Discounters (Top 25%)'
        WHEN discount_cohort_rank = 2 THEN 'Tier 2: Mid-High Promoters'
        WHEN discount_cohort_rank = 3 THEN 'Tier 3: Moderate Promoters'
        ELSE 'Tier 4: Conservative/Full-Price'
    END AS discount_strategy_cohort,
    -- Calculate what % of the category is actually on sale
    ROUND(100.0 * discounted_items_count / product_count, 2) AS percent_of_catalog_on_sale
FROM CategoryBuckets
ORDER BY avg_discount DESC;

-- Q16.Running total & cumulative inventory share
-- Running Total & Cumulative Inventory Share (by Product Value)
WITH InventoryValue AS (
    SELECT 
        category,
        name,
        (availableQuantity * discountedSellingPrice) AS stock_value
    FROM zepto
    WHERE availableQuantity > 0
),
CumulativeCalculation AS (
    SELECT 
        category,
        name,
        stock_value,
        -- Calculate the running total across all products
        SUM(stock_value) OVER(ORDER BY stock_value DESC) AS running_total,
        -- Calculate the grand total for percentage calculation
        SUM(stock_value) OVER() AS grand_total
    FROM InventoryValue
)
SELECT 
    category,
    name,
    stock_value,
    running_total,
    ROUND((running_total / grand_total) * 100, 2) AS cumulative_share_percent,
    -- Pareto Principle Check (80/20 Rule)
    CASE 
        WHEN (running_total / grand_total) <= 0.80 THEN 'A: Vital Few (Top 80%)'
        ELSE 'B/C: Trivial Many'
    END AS pareto_classification
FROM CumulativeCalculation
ORDER BY stock_value DESC;

--Q17.Stored procedure: restock alert generator
-- Create the Stored Procedure
CREATE OR REPLACE PROCEDURE generate_restock_alerts(threshold_limit INT)
LANGUAGE plpgsql
AS $$
BEGIN
    -- This procedure identifies items below the threshold and not yet flagged as Out of Stock
    -- We use a NOTICE here, but in a real system, you might insert this into an 'alerts' table
    RAISE NOTICE 'Restock Alert Report Generated for items with quantity < %', threshold_limit;

    -- Query to find critical items
    -- In a production environment, you would usually INSERT this into a 'restock_tasks' table
    -- For now, we will demonstrate the logic
END;
$$;

-- Create a View for the Restock Report (Optional, but helpful for the Procedure)
-- Since procedures don't "return" tables easily in some SQL dialects, 
-- we use a report query to fetch the data after calling the logic.
CREATE OR REPLACE VIEW v_urgent_restock_list AS
SELECT 
    sku_id,
    category,
    name,
    availableQuantity,
    mrp,
    (mrp * 50) AS restock_cost_estimate -- Estimating cost to bring stock back to 50 units
FROM zepto
WHERE availableQuantity < 10 -- Threshold
  OR outOfStock = TRUE
ORDER BY availableQuantity ASC;

-- How to execute the check
-- Set the threshold to 15 units
CALL generate_restock_alerts(15);

-- View the results
SELECT * FROM v_urgent_restock_list;

-- Q18.Create a materialized view for a BI dashboard
CREATE MATERIALIZED VIEW mv_zepto_dashboard_kpis AS
SELECT 
    category,
    COUNT(sku_id) AS total_skus,
    SUM(availableQuantity) AS total_inventory_units,
    -- Financial Health Metrics
    ROUND(SUM(availableQuantity * discountedSellingPrice), 2) AS total_stock_value,
    ROUND(AVG(discountPercent), 2) AS avg_category_discount,
    -- Out of Stock & Risk Metrics
    COUNT(CASE WHEN outOfStock = TRUE THEN 1 END) AS oos_count,
    ROUND(SUM(CASE WHEN outOfStock = TRUE THEN mrp ELSE 0 END), 2) AS revenue_at_risk,
    -- Pricing Insights
    ROUND(AVG(discountedSellingPrice / NULLIF(weightInGms, 0)), 4) AS avg_price_per_gram
FROM zepto
GROUP BY category
ORDER BY total_stock_value DESC;

-- Add an index to make querying even faster
CREATE UNIQUE INDEX idx_category_kpi ON mv_zepto_dashboard_kpis (category);

-- Refresh without blocking users (requires a unique index)
REFRESH MATERIALIZED VIEW CONCURRENTLY mv_zepto_dashboard_kpis;











