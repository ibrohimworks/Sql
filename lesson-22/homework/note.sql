
-- EASY TASKS

-- Running Total Sales per Customer
SELECT customer_id, customer_name, order_date, total_amount,
       SUM(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS running_total
FROM sales_data;

-- Number of Orders per Product Category
SELECT DISTINCT product_category,
       COUNT(*) OVER (PARTITION BY product_category) AS orders_count
FROM sales_data;

-- Maximum Total Amount per Product Category
SELECT DISTINCT product_category,
       MAX(total_amount) OVER (PARTITION BY product_category) AS max_total
FROM sales_data;

-- Minimum Price of Products per Product Category
SELECT DISTINCT product_category,
       MIN(unit_price) OVER (PARTITION BY product_category) AS min_price
FROM sales_data;

-- Moving Average of Sales (3 days)
SELECT sale_id, order_date, total_amount,
       AVG(total_amount) OVER (ORDER BY order_date ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS moving_avg_3
FROM sales_data;

-- Total Sales per Region
SELECT DISTINCT region,
       SUM(total_amount) OVER (PARTITION BY region) AS region_sales
FROM sales_data;

-- Rank of Customers Based on Total Purchase
SELECT customer_id, customer_name,
       SUM(total_amount) AS total_spending,
       RANK() OVER (ORDER BY SUM(total_amount) DESC) AS rank_customers
FROM sales_data
GROUP BY customer_id, customer_name;

-- Difference Between Current and Previous Sale Amount per Customer
SELECT sale_id, customer_id, total_amount,
       total_amount - LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS diff_prev
FROM sales_data;

-- Top 3 Most Expensive Products in Each Category
SELECT *
FROM (
    SELECT product_category, product_name, unit_price,
           DENSE_RANK() OVER (PARTITION BY product_category ORDER BY unit_price DESC) AS rnk
    FROM sales_data
) t
WHERE rnk <= 3;

-- Cumulative Sum of Sales Per Region by Order Date
SELECT sale_id, region, order_date, total_amount,
       SUM(total_amount) OVER (PARTITION BY region ORDER BY order_date) AS cum_sum_region
FROM sales_data;


-- MEDIUM TASKS

-- Cumulative Revenue per Product Category
SELECT sale_id, product_category, order_date, total_amount,
       SUM(total_amount) OVER (PARTITION BY product_category ORDER BY order_date) AS cumulative_revenue
FROM sales_data;

-- Sum of Previous Values to Current Value
SELECT Value,
       SUM(Value) OVER (ORDER BY Value ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS SumPrevValues
FROM OneColumn;

-- Customers Who Purchased from More Than One Category
SELECT customer_id, customer_name
FROM sales_data
GROUP BY customer_id, customer_name
HAVING COUNT(DISTINCT product_category) > 1;

-- Customers with Above-Average Spending in Their Region
SELECT customer_id, customer_name, region,
       SUM(total_amount) AS total_spent,
       AVG(SUM(total_amount)) OVER (PARTITION BY region) AS avg_spent_region
FROM sales_data
GROUP BY customer_id, customer_name, region
HAVING SUM(total_amount) > AVG(SUM(total_amount)) OVER (PARTITION BY region);

-- Rank Customers Within Each Region
SELECT customer_id, customer_name, region,
       SUM(total_amount) AS total_spent,
       RANK() OVER (PARTITION BY region ORDER BY SUM(total_amount) DESC) AS region_rank
FROM sales_data
GROUP BY customer_id, customer_name, region;

-- Running Total per Customer
SELECT customer_id, customer_name, order_date, total_amount,
       SUM(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS cumulative_sales
FROM sales_data;

-- Monthly Sales Growth Rate
SELECT YEAR(order_date) AS yr, MONTH(order_date) AS mon,
       SUM(total_amount) AS monthly_sales,
       LAG(SUM(total_amount)) OVER (ORDER BY YEAR(order_date), MONTH(order_date)) AS prev_month,
       (SUM(total_amount) - LAG(SUM(total_amount)) OVER (ORDER BY YEAR(order_date), MONTH(order_date)))
       * 100.0 / NULLIF(LAG(SUM(total_amount)) OVER (ORDER BY YEAR(order_date), MONTH(order_date)),0) AS growth_rate
FROM sales_data
GROUP BY YEAR(order_date), MONTH(order_date);

-- Customers Whose Order is Greater than Their Previous One
SELECT sale_id, customer_id, total_amount
FROM (
    SELECT sale_id, customer_id, order_date, total_amount,
           LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_amt
    FROM sales_data
) t
WHERE total_amount > prev_amt;


-- HARD TASKS

-- Products Priced Above Average
SELECT DISTINCT product_name, unit_price
FROM sales_data
WHERE unit_price > (SELECT AVG(unit_price) FROM sales_data);

-- Puzzle: Group Totals (MyData)
SELECT Id, Grp, Val1, Val2,
       CASE WHEN ROW_NUMBER() OVER (PARTITION BY Grp ORDER BY Id) = 1
            THEN SUM(Val1+Val2) OVER (PARTITION BY Grp)
       END AS Tot
FROM MyData;

-- Puzzle: Summing Cost and Quantity (TheSumPuzzle)
SELECT Id,
       SUM(Cost) AS Cost,
       SUM(Quantity) AS Quantity
FROM TheSumPuzzle
GROUP BY Id;

-- Puzzle: Seat Gaps
SELECT (prev.SeatNumber + 1) AS GapStart,
       (curr.SeatNumber - 1) AS GapEnd
FROM Seats curr
LEFT JOIN Seats prev ON prev.SeatNumber = (
    SELECT MAX(s2.SeatNumber) FROM Seats s2 WHERE s2.SeatNumber < curr.SeatNumber
)
WHERE curr.SeatNumber - prev.SeatNumber > 1
UNION ALL
SELECT 1, MIN(SeatNumber)-1 FROM Seats
UNION ALL
SELECT MAX(SeatNumber)+1, 999999 FROM Seats  -- if you want open-ended future gaps
ORDER BY GapStart;
