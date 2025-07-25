-- 1. Total number of products per category
SELECT category, COUNT(*) AS total_products
FROM Products
GROUP BY category;

-- 2. Average price of products in 'Electronics'
SELECT AVG(price) AS avg_price
FROM Products
WHERE category = 'Electronics';

-- 3. Customers from cities starting with 'L'
SELECT *
FROM Customers
WHERE city LIKE 'L%';

-- 4. Product names ending with 'er'
SELECT product_name
FROM Products
WHERE product_name LIKE '%er';

-- 5. Customers from countries ending with 'A'
SELECT *
FROM Customers
WHERE country LIKE '%A';

-- 6. Highest price among all products
SELECT MAX(price) AS highest_price
FROM Products;

-- 7. Stock level labeling
SELECT product_name,
       quantity,
       CASE WHEN quantity < 30 THEN 'Low Stock'
            ELSE 'Sufficient' END AS stock_status
FROM Products;

-- 8. Total customers per country
SELECT country, COUNT(*) AS total_customers
FROM Customers
GROUP BY country;

-- 9. Min and max quantity ordered
SELECT MIN(quantity) AS min_quantity,
       MAX(quantity) AS max_quantity
FROM Orders;

-- 10. Customer IDs with orders in Jan 2023 but no invoice
SELECT DISTINCT o.customer_id
FROM Orders o
LEFT JOIN Invoices i ON o.order_id = i.order_id
WHERE o.order_date BETWEEN '2023-01-01' AND '2023-01-31'
  AND i.invoice_id IS NULL;

-- 11. Combine product names with duplicates
SELECT product_name FROM Products
UNION ALL
SELECT product_name FROM Products_Discounted;

-- 12. Combine product names without duplicates
SELECT product_name FROM Products
UNION
SELECT product_name FROM Products_Discounted;

-- 13. Average order amount by year
SELECT YEAR(order_date) AS year, AVG(order_amount) AS avg_order_amount
FROM Orders
GROUP BY YEAR(order_date);

-- 14. Group products by price range
SELECT product_name,
       CASE WHEN price < 100 THEN 'Low'
            WHEN price BETWEEN 100 AND 500 THEN 'Mid'
            ELSE 'High' END AS price_group
FROM Products;

-- 15. Pivot year values to columns
SELECT * INTO Population_Each_Year
FROM (
    SELECT city, year, population
    FROM City_Population
) src
PIVOT (
    SUM(population)
    FOR year IN ([2012], [2013])
) AS pvt;

-- 16. Total sales per product
SELECT product_id, SUM(sales_amount) AS total_sales
FROM Sales
GROUP BY product_id;

-- 17. Product names containing 'oo'
SELECT product_name
FROM Products
WHERE product_name LIKE '%oo%';

-- 18. Pivot cities to columns
SELECT * INTO Population_Each_City
FROM (
    SELECT city, year, population
    FROM City_Population
) src
PIVOT (
    SUM(population)
    FOR city IN ([Bektemir], [Chilonzor], [Yakkasaroy])
) AS pvt;

-- 19. Top 3 customers by invoice amount
SELECT TOP 3 customer_id, SUM(amount) AS total_spent
FROM Invoices
GROUP BY customer_id
ORDER BY total_spent DESC;

-- 20. Unpivot Population_Each_Year to original format
SELECT city, '2012' AS year, [2012] AS population FROM Population_Each_Year
UNION ALL
SELECT city, '2013' AS year, [2013] AS population FROM Population_Each_Year;

-- 21. Product sales count using JOIN
SELECT p.product_name, COUNT(*) AS times_sold
FROM Sales s
JOIN Products p ON s.product_id = p.product_id
GROUP BY p.product_name;

-- 22. Unpivot Population_Each_City to original format
SELECT 'Yunsobod' AS city, year, [Bektemir] AS population FROM Population_Each_City
UNION ALL
SELECT 'UchTepa', year, [Chilonzor] FROM Population_Each_City
UNION ALL
SELECT 'Mirobod', year, [Yakkasaroy] FROM Population_Each_City;
