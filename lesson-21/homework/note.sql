-- 1. Row number per sale ordered by date
SELECT SaleID, ProductName, SaleDate, 
       ROW_NUMBER() OVER (ORDER BY SaleDate) AS RowNum
FROM ProductSales;

-- 2. Rank products by total quantity sold (DENSE_RANK)
SELECT ProductName, SUM(Quantity) AS TotalQty,
       DENSE_RANK() OVER (ORDER BY SUM(Quantity) DESC) AS RankQty
FROM ProductSales
GROUP BY ProductName;

-- 3. Top sale for each customer
SELECT *
FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY SaleAmount DESC) AS rn
    FROM ProductSales
) t
WHERE rn=1;

-- 4. Each sale with NEXT sale amount
SELECT SaleID, SaleAmount,
       LEAD(SaleAmount) OVER (ORDER BY SaleDate) AS NextAmount
FROM ProductSales;

-- 5. Each sale with PREVIOUS sale amount
SELECT SaleID, SaleAmount,
       LAG(SaleAmount) OVER (ORDER BY SaleDate) AS PrevAmount
FROM ProductSales;

-- 6. Sales greater than previous sale
SELECT SaleID, SaleAmount
FROM (
    SELECT SaleID, SaleAmount,
           LAG(SaleAmount) OVER (ORDER BY SaleDate) AS PrevAmount
    FROM ProductSales
) t
WHERE SaleAmount > PrevAmount;

-- 7. Difference from previous sale per product
SELECT SaleID, ProductName, SaleAmount,
       SaleAmount - LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS DiffPrev
FROM ProductSales;

-- 8. % change vs next sale
SELECT SaleID, SaleAmount,
       LEAD(SaleAmount) OVER (ORDER BY SaleDate) AS NextAmount,
       CASE WHEN LEAD(SaleAmount) OVER (ORDER BY SaleDate)=0 THEN NULL
            ELSE ( (LEAD(SaleAmount) OVER (ORDER BY SaleDate) - SaleAmount) * 100.0 / SaleAmount )
       END AS PctChange
FROM ProductSales;

-- 9. Ratio current to previous sale within product
SELECT SaleID, ProductName, SaleAmount,
       CAST(SaleAmount AS DECIMAL(10,2)) / 
       NULLIF(LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate),0) AS RatioPrev
FROM ProductSales;

-- 10. Difference from first sale of product
SELECT SaleID, ProductName, SaleAmount,
       SaleAmount - FIRST_VALUE(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS DiffFromFirst
FROM ProductSales;

-- 11. Increasing sales per product
SELECT SaleID, ProductName, SaleAmount
FROM (
    SELECT *, 
           LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS PrevAmount
    FROM ProductSales
) t
WHERE SaleAmount > PrevAmount;

-- 12. Running total (closing balance)
SELECT SaleID, SaleAmount,
       SUM(SaleAmount) OVER (ORDER BY SaleDate ROWS UNBOUNDED PRECEDING) AS RunningTotal
FROM ProductSales;

-- 13. Moving average over last 3 sales
SELECT SaleID, SaleAmount,
       AVG(SaleAmount) OVER (ORDER BY SaleDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovAvg3
FROM ProductSales;

-- 14. Difference from average
SELECT SaleID, SaleAmount,
       SaleAmount - AVG(SaleAmount) OVER () AS DiffFromAvg
FROM ProductSales;




-- Employees1
-- 1. Employees with same salary rank
SELECT Name, Department, Salary,
       DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
FROM Employees1;

-- 2. Top 2 highest salaries in each dept
SELECT *
FROM (
    SELECT *, DENSE_RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS rnk
    FROM Employees1
) t
WHERE rnk <= 2;

-- 3. Lowest-paid employee in each dept
SELECT *
FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY Department ORDER BY Salary ASC) AS rn
    FROM Employees1
) t
WHERE rn=1;

-- 4. Running total of salaries per dept
SELECT Department, Name, Salary,
       SUM(Salary) OVER (PARTITION BY Department ORDER BY Salary ROWS UNBOUNDED PRECEDING) AS RunTotal
FROM Employees1;

-- 5. Total salary of each dept (no GROUP BY)
SELECT DISTINCT Department,
       SUM(Salary) OVER (PARTITION BY Department) AS TotalSalary
FROM Employees1;

-- 6. Avg salary per dept (no GROUP BY)
SELECT DISTINCT Department,
       AVG(Salary) OVER (PARTITION BY Department) AS AvgSalary
FROM Employees1;

-- 7. Salary difference vs dept avg
SELECT Name, Department, Salary,
       Salary - AVG(Salary) OVER (PARTITION BY Department) AS DiffDeptAvg
FROM Employees1;

-- 8. Moving avg salary over 3 employees
SELECT EmployeeID, Name, Salary,
       AVG(Salary) OVER (ORDER BY EmployeeID ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS MovAvg3
FROM Employees1;

-- 9. Sum of salaries for last 3 hired employees
SELECT SUM(Salary) AS SumLast3
FROM (
    SELECT Salary,
           ROW_NUMBER() OVER (ORDER BY HireDate DESC) AS rn
    FROM Employees1
) t
WHERE rn <= 3;
