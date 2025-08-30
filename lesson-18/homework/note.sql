------------------------------------------------
-- 1. Temp table MonthlySales (current month)
------------------------------------------------
IF OBJECT_ID('tempdb..#MonthlySales') IS NOT NULL DROP TABLE #MonthlySales;

SELECT 
    s.ProductID,
    SUM(s.Quantity) AS TotalQuantity,
    SUM(s.Quantity * p.Price) AS TotalRevenue
INTO #MonthlySales
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
WHERE MONTH(s.SaleDate) = MONTH(GETDATE())
  AND YEAR(s.SaleDate) = YEAR(GETDATE())
GROUP BY s.ProductID;

SELECT * FROM #MonthlySales;


------------------------------------------------
-- 2. View vw_ProductSalesSummary
------------------------------------------------
IF OBJECT_ID('vw_ProductSalesSummary') IS NOT NULL DROP VIEW vw_ProductSalesSummary;
GO
CREATE VIEW vw_ProductSalesSummary AS
SELECT 
    p.ProductID,
    p.ProductName,
    p.Category,
    ISNULL(SUM(s.Quantity),0) AS TotalQuantitySold
FROM Products p
LEFT JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.ProductID, p.ProductName, p.Category;
GO

SELECT * FROM vw_ProductSalesSummary;


------------------------------------------------
-- 3. Function fn_GetTotalRevenueForProduct
------------------------------------------------
IF OBJECT_ID('fn_GetTotalRevenueForProduct') IS NOT NULL DROP FUNCTION fn_GetTotalRevenueForProduct;
GO
CREATE FUNCTION fn_GetTotalRevenueForProduct(@ProductID INT)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @Revenue DECIMAL(18,2);

    SELECT @Revenue = SUM(s.Quantity * p.Price)
    FROM Sales s
    JOIN Products p ON s.ProductID = p.ProductID
    WHERE s.ProductID = @ProductID;

    RETURN ISNULL(@Revenue,0);
END;
GO

SELECT dbo.fn_GetTotalRevenueForProduct(1) AS RevenueForProduct1;


------------------------------------------------
-- 4. Function fn_GetSalesByCategory
------------------------------------------------
IF OBJECT_ID('fn_GetSalesByCategory') IS NOT NULL DROP FUNCTION fn_GetSalesByCategory;
GO
CREATE FUNCTION fn_GetSalesByCategory(@Category VARCHAR(50))
RETURNS TABLE
AS
RETURN
(
    SELECT 
        p.ProductName,
        SUM(s.Quantity) AS TotalQuantity,
        SUM(s.Quantity * p.Price) AS TotalRevenue
    FROM Products p
    LEFT JOIN Sales s ON p.ProductID = s.ProductID
    WHERE p.Category = @Category
    GROUP BY p.ProductName
);
GO

SELECT * FROM dbo.fn_GetSalesByCategory('Electronics');


------------------------------------------------
-- 5. Function fn_IsPrime
------------------------------------------------
IF OBJECT_ID('fn_IsPrime') IS NOT NULL DROP FUNCTION fn_IsPrime;
GO
CREATE FUNCTION fn_IsPrime(@Number INT)
RETURNS VARCHAR(3)
AS
BEGIN
    DECLARE @i INT = 2, @isPrime BIT = 1;

    IF @Number <= 1 SET @isPrime = 0;

    WHILE @i <= SQRT(@Number) AND @isPrime = 1
    BEGIN
        IF @Number % @i = 0 SET @isPrime = 0;
        SET @i += 1;
    END

    RETURN (CASE WHEN @isPrime=1 THEN 'Yes' ELSE 'No' END);
END;
GO

SELECT dbo.fn_IsPrime(17) AS TestPrime;


------------------------------------------------
-- 6. Function fn_GetNumbersBetween
------------------------------------------------
IF OBJECT_ID('fn_GetNumbersBetween') IS NOT NULL DROP FUNCTION fn_GetNumbersBetween;
GO
CREATE FUNCTION fn_GetNumbersBetween(@Start INT, @End INT)
RETURNS @Result TABLE(Number INT)
AS
BEGIN
    DECLARE @i INT = @Start;
    WHILE @i <= @End
    BEGIN
        INSERT INTO @Result VALUES(@i);
        SET @i += 1;
    END
    RETURN;
END;
GO

SELECT * FROM dbo.fn_GetNumbersBetween(5,10);


------------------------------------------------
-- 7. Nth Highest Distinct Salary
------------------------------------------------
-- Using parameter n=2 as example
DECLARE @N INT = 2;

SELECT
    CASE WHEN COUNT(DISTINCT salary) < @N 
         THEN NULL
         ELSE (SELECT DISTINCT salary 
               FROM Employee 
               ORDER BY salary DESC 
               OFFSET (@N-1) ROWS FETCH NEXT 1 ROWS ONLY)
    END AS HighestNSalary;


------------------------------------------------
-- 8. Most Friends
------------------------------------------------
SELECT id, COUNT(*) AS num
FROM (
    SELECT requester_id AS id, accepter_id AS friend FROM RequestAccepted
    UNION ALL
    SELECT accepter_id, requester_id FROM RequestAccepted
) t
GROUP BY id
ORDER BY num DESC
OFFSET 0 ROWS FETCH NEXT 1 ROW ONLY;


------------------------------------------------
-- 9. View vw_CustomerOrderSummary
------------------------------------------------
IF OBJECT_ID('vw_CustomerOrderSummary') IS NOT NULL DROP VIEW vw_CustomerOrderSummary;
GO
CREATE VIEW vw_CustomerOrderSummary AS
SELECT 
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS total_orders,
    ISNULL(SUM(o.amount),0) AS total_amount,
    MAX(o.order_date) AS last_order_date
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;
GO

SELECT * FROM vw_CustomerOrderSummary;


------------------------------------------------
-- 10. Fill missing Workflow gaps
------------------------------------------------
SELECT g.RowNumber,
       FIRST_VALUE(TestCase) OVER (
           PARTITION BY grp ORDER BY RowNumber
       ) AS Workflow
FROM (
    SELECT RowNumber, TestCase,
           COUNT(TestCase) OVER (ORDER BY RowNumber ROWS UNBOUNDED PRECEDING) AS grp
    FROM Gaps
) g;
