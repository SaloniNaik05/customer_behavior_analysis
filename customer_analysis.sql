CREATE DATABASE customer_behavior;
USE customer_behavior;
-- Q1: Revenue by Gender
SELECT `Gender`, SUM(`Purchase_Amount_USD`) AS revenue
FROM customer
GROUP BY `Gender`;
SELECT 'Customer_ID', 'Purchase_Amount_USD'
FROM customer
WHERE Discount_Applied = 'Yes'
AND 'Purchase_Amount_USD' >= (
    SELECT AVG('Purchase_Amount_USD') FROM customer
);
-- Q2: Discount users spending above average
SELECT 'Customer_ID', 'Purchase_Amount_USD'
FROM customer
WHERE Discount_Applied = 'Yes'
AND Purchase_Amount_USD >= (
    SELECT AVG('Purchase_Amount_USD') FROM customer
);
-- Q3: Top 5 products by rating
SELECT Item_Purchased,
       ROUND(AVG(Review_Rating), 2) AS avg_product_rating
FROM customer
GROUP BY Item_Purchased
ORDER BY avg_product_rating DESC
LIMIT 5;
-- Q4: Avg purchase (Standard vs Express)
SELECT Shipping_Type,
       ROUND(AVG(Purchase_Amount_USD), 2) AS avg_purchase
FROM customer
WHERE Shipping_Type IN ('Standard','Express')
GROUP BY Shipping_Type;
-- Q5: Subscribers vs Non-subscribers
SELECT Subscription_Status,
       COUNT(*) AS total_customers,
       ROUND(AVG(Purchase_Amount_USD),2) AS avg_spend,
       ROUND(SUM(Purchase_Amount_USD),2) AS total_revenue
FROM customer
GROUP BY Subscription_Status
ORDER BY total_revenue DESC, avg_spend DESC;
-- Q6: Top 5 products by discount %
SELECT Item_Purchased,
       ROUND(100 * SUM(Discount_Applied = 'Yes') / COUNT(*), 2) AS discount_rate
FROM customer
GROUP BY Item_Purchased
ORDER BY discount_rate DESC
LIMIT 5;
-- Q7: Customer Segmentation
WITH customer_type AS (
    SELECT 'Customer_ID',
    CASE 
        WHEN Previous_Purchases = 1 THEN 'New'
        WHEN Previous_Purchases BETWEEN 2 AND 10 THEN 'Returning'
        ELSE 'Loyal'
    END AS customer_segment
    FROM customer
)
SELECT customer_segment, COUNT(*) AS number_of_customers
FROM customer_type
GROUP BY customer_segment;
-- Q8: Top 3 products per category
WITH item_counts AS (
    SELECT Category,
           Item_Purchased,
           COUNT(*) AS total_orders,
           ROW_NUMBER() OVER (
               PARTITION BY Category 
               ORDER BY COUNT(*) DESC
           ) AS item_rank
    FROM customer
    GROUP BY Category, Item_Purchased
)
SELECT item_rank, Category, Item_Purchased, total_orders
FROM item_counts
WHERE item_rank <= 3;


