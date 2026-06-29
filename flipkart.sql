CREATE DATABASE FlipkartDB;
USE FlipkartDB;
 
 
SELECT name
FROM sys.tables
WHERE name LIKE '%Flipkart%';

-- 1) CATEGORY WISE REVENUE 

SELECT TOP 10 Category,
    COUNT(*) AS total_products,
    SUM(units_sold) AS total_units,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(AVG(discount_pct), 2) AS avg_discount,
    ROUND(AVG(CASE WHEN product_rating_clean > 0 THEN product_rating_clean END), 2) AS avg_rating
FROM flipkart_cleaned
GROUP BY Category
ORDER BY total_revenue DESC;



-- 2) TOP SELLING PRODUCTS

SELECT TOP 10
    product_name,
    brand,
    Category,
    units_sold,
    ROUND(revenue, 2) AS revenue,
    CASE WHEN product_rating_clean > 0 THEN product_rating_clean ELSE NULL END AS product_rating,
    discount_pct
FROM flipkart_cleaned
ORDER BY revenue DESC;
 

 

-- 3) DISCOUNT IMPACT ON SALES

SELECT
    CASE
        WHEN discount_pct = 0 THEN 'No Discount'
        WHEN discount_pct BETWEEN 1 AND 20 THEN '1-20%'
        WHEN discount_pct BETWEEN 21 AND 40 THEN '21-40%'
        ELSE '40%+'
    END AS discount_bucket,
    COUNT(*) AS total_products,
    ROUND(AVG(units_sold), 1) AS avg_units_sold,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM flipkart_cleaned
GROUP BY
    CASE
        WHEN discount_pct = 0 THEN 'No Discount'
        WHEN discount_pct BETWEEN 1 AND 20  THEN '1-20%'
        WHEN discount_pct BETWEEN 21 AND 40 THEN '21-40%'
        ELSE '40%+'
    END
ORDER BY MIN(discount_pct);
 
 

-- 4) RATING VS SALES

SELECT
    CASE
        WHEN product_rating_clean BETWEEN 0.1 AND 2.9 THEN '1-2.9 Poor'
        WHEN product_rating_clean BETWEEN 3   AND 3.9 THEN '3-3.9 Average'
        WHEN product_rating_clean BETWEEN 4   AND 4.4 THEN '4-4.4 Good'
        WHEN product_rating_clean >= 4.5 THEN '4.5+ Excellent'
    END AS rating_band,
    COUNT(*) AS total_products,
    ROUND(AVG(units_sold), 1) AS avg_units_sold,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM flipkart_cleaned
WHERE product_rating_clean > 0
GROUP BY
    CASE
        WHEN product_rating_clean BETWEEN 0.1 AND 2.9 THEN '1-2.9 Poor'
        WHEN product_rating_clean BETWEEN 3   AND 3.9 THEN '3-3.9 Average'
        WHEN product_rating_clean BETWEEN 4   AND 4.4 THEN '4-4.4 Good'
        WHEN product_rating_clean >= 4.5  THEN '4.5+ Excellent'
    END
ORDER BY MIN(product_rating_clean);
 
 
-- 5) MONTHLY REVENUE TRENDS

SELECT
    FORMAT(order_date, 'yyyy-MM') AS month,
    SUM(units_sold) AS total_units,
    ROUND(SUM(revenue), 2) AS monthly_revenue,
    ROUND(AVG(discounted_price), 2) AS avg_order_value
FROM flipkart_cleaned
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy-MM')
ORDER BY month;
 
 
-- 6) CITY WISE DEMAND

SELECT
    city,
    COUNT(*) AS total_orders,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(AVG(discounted_price), 2) AS avg_order_value,
    CASE
        WHEN AVG(discounted_price) > 5000 THEN 'Premium'
        WHEN AVG(discounted_price) > 2000 THEN 'Mid-Range'
        ELSE 'Value'
    END AS market_segment
FROM flipkart_cleaned
GROUP BY city
ORDER BY total_revenue DESC;
 
 

-- 7) BONUS — DATA QUALITY CHECK QUERY

SELECT
    CASE WHEN product_rating_clean = 0 THEN 'Not Rated' ELSE 'Rated' END AS rating_status,
    COUNT(*) AS num_products,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM flipkart_cleaned), 2) AS pct_of_dataset
FROM flipkart_cleaned
GROUP BY CASE WHEN product_rating_clean = 0 THEN 'Not Rated' ELSE 'Rated' END;




