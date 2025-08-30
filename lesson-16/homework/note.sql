-----------------------------
-- EASY TASKS
-----------------------------

-- 1. Numbers table from 1 to 1000
WITH RECURSIVE Numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM Numbers WHERE n < 1000
)
SELECT * FROM Numbers;

-- 2. Total sales per employee (derived table)
SELECT e.EmployeeID, e.FirstName, e.LastName, s.total_sales
FROM Employees e
JOIN (
    SELECT EmployeeID, SUM(SalesAmount) AS total_sales
    FROM Sales
    GROUP BY EmployeeID
) s ON e.EmployeeID = s.EmployeeID;

-- 3. Average salary (CTE)
WITH AvgSalary AS (
    SELECT AVG(Salary) AS avg_sal FROM Employees
)
SELECT avg_sal FROM AvgSalary;

-- 4. Highest sales per product (derived table)
SELECT p.ProductID, p.ProductName, s.max_sale
FROM Products p
JOIN (
    SELECT ProductID, MAX(SalesAmount) AS max_sale
    FROM Sales
    GROUP BY ProductID
) s ON p.ProductID = s.ProductID;

-- 5. Doubling numbers until < 1,000,000
WITH RECURSIVE Doubles AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n * 2 FROM Doubles WHERE n * 2 < 1000000
)
SELECT * FROM Doubles;

-- 6. Employees with > 5 sales (CTE)
WITH SalesCount AS (
    SELECT EmployeeID, COUNT(*) AS cnt
    FROM Sales
    GROUP BY EmployeeID
)
SELECT e.EmployeeID, e.FirstName, e.LastName
FROM Employees e
JOIN SalesCount s ON e.EmployeeID = s.EmployeeID
WHERE s.cnt > 5;

-- 7. Products with total sales > 500 (CTE)
WITH ProductSales AS (
    SELECT ProductID, SUM(SalesAmount) AS total_sales
    FROM Sales
    GROUP BY ProductID
)
SELECT p.ProductID, p.ProductName, ps.total_sales
FROM Products p
JOIN ProductSales ps ON p.ProductID = ps.ProductID
WHERE ps.total_sales > 500;

-- 8. Employees with salary above avg (CTE)
WITH AvgSal AS (SELECT AVG(Salary) AS avg_sal FROM Employees)
SELECT * 
FROM Employees
WHERE Salary > (SELECT avg_sal FROM AvgSal);


-----------------------------
-- MEDIUM TASKS
-----------------------------

-- 1. Top 5 employees by orders (derived table)
SELECT *
FROM (
    SELECT EmployeeID, COUNT(*) AS order_count
    FROM Sales
    GROUP BY EmployeeID
    ORDER BY order_count DESC
    LIMIT 5
) t;

-- 2. Sales per product category (derived table)
SELECT p.CategoryID, SUM(s.SalesAmount) AS total_sales
FROM Products p
JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.CategoryID;

-- 3. Factorial for each number
WITH RECURSIVE Factorial(n, fact) AS (
    SELECT Number, 1 FROM Numbers1
    UNION ALL
    SELECT n, fact * (n - (ROW_NUMBER() OVER()) ) -- placeholder logic
    FROM Numbers1
)
-- Simplified factorial per row
SELECT n, EXP(SUM(LN(seq))) AS factorial
FROM (
    SELECT Number AS n, seq
    FROM Numbers1
    JOIN (
        SELECT 1 seq UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
        UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10
    ) nums
    ON seq <= Number
) t
GROUP BY n;

-- 4. Split string into rows (recursion)
WITH RECURSIVE Split AS (
    SELECT Id, String, 1 AS pos, SUBSTRING(String,1,1) AS ch
    FROM Example
    UNION ALL
    SELECT Id, String, pos+1, SUBSTRING(String,pos+1,1)
    FROM Split
    WHERE pos < LENGTH(String)
)
SELECT Id, ch FROM Split;

-- 5. Sales difference current vs prev month (CTE)
WITH MonthlySales AS (
    SELECT DATE_FORMAT(SaleDate, '%Y-%m') AS ym,
           SUM(SalesAmount) AS total_sales
    FROM Sales
    GROUP BY DATE_FORMAT(SaleDate, '%Y-%m')
),
Diffs AS (
    SELECT ym, total_sales,
           total_sales - LAG(total_sales) OVER (ORDER BY ym) AS diff
    FROM MonthlySales
)
SELECT * FROM Diffs;

-- 6. Employees with > 45000 sales per quarter (derived table)
SELECT EmployeeID, QUARTER(SaleDate) AS qtr, SUM(SalesAmount) AS total_sales
FROM Sales
GROUP BY EmployeeID, QUARTER(SaleDate)
HAVING SUM(SalesAmount) > 45000;


-----------------------------
-- DIFFICULT TASKS
-----------------------------

-- 1. Fibonacci numbers (recursion)
WITH RECURSIVE Fib(n, a, b) AS (
    SELECT 1, 0, 1
    UNION ALL
    SELECT n+1, b, a+b FROM Fib WHERE n < 20
)
SELECT n, a AS fib_value FROM Fib;

-- 2. Find strings with all same chars and length > 1
SELECT * 
FROM FindSameCharacters
WHERE Vals IS NOT NULL
  AND LENGTH(Vals) > 1
  AND LENGTH(Vals) = LENGTH(REPLACE(Vals, SUBSTRING(Vals,1,1), '') ) + LENGTH(SUBSTRING(Vals,1,1));

-- 3. Build numbers with sequence pattern (1, 12, 123…n)
WITH RECURSIVE Seq AS (
    SELECT 1 AS n, CAST('1' AS VARCHAR(50)) AS val
    UNION ALL
    SELECT n+1, CONCAT(val, n+1)
    FROM Seq
    WHERE n < 5
)
SELECT * FROM Seq;

-- 4. Employees with most sales in last 6 months
SELECT EmployeeID, SUM(SalesAmount) AS total_sales
FROM Sales
WHERE SaleDate >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY EmployeeID
ORDER BY total_sales DESC
LIMIT 1;

-- 5. Remove duplicate integer substrings (simplified regex version)
SELECT PawanName,
       REGEXP_REPLACE(Pawan_slug_name, '([0-9])\1+', '\1') AS cleaned
FROM RemoveDuplicateIntsFromNames;
