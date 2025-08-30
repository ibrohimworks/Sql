

-- 1. Customers who purchased in March 2024 (EXISTS)
SELECT DISTINCT s1.CustomerName
FROM #Sales s1
WHERE EXISTS (
    SELECT 1
    FROM #Sales s2
    WHERE s2.CustomerName = s1.CustomerName
      AND MONTH(s2.SaleDate) = 3
      AND YEAR(s2.SaleDate) = 2024
);

-- 2. Product with highest total sales revenue
SELECT TOP 1 Product, SUM(Quantity*Price) AS TotalRevenue
FROM #Sales
GROUP BY Product
ORDER BY TotalRevenue DESC;

-- 3. Second highest sale amount
SELECT MAX(TotalAmount) AS SecondHighest
FROM (
    SELECT DISTINCT (Quantity*Price) AS TotalAmount
    FROM #Sales
) t
WHERE TotalAmount < (SELECT MAX(Quantity*Price) FROM #Sales);

-- 4. Total quantity sold per month
SELECT SaleMonth, SUM(Quantity) AS TotalQty
FROM (
    SELECT MONTH(SaleDate) AS SaleMonth, Quantity
    FROM #Sales
) t
GROUP BY SaleMonth;

-- 5. Customers who bought same products as another customer
SELECT DISTINCT s1.CustomerName
FROM #Sales s1
WHERE EXISTS (
    SELECT 1
    FROM #Sales s2
    WHERE s1.Product = s2.Product
      AND s1.CustomerName <> s2.CustomerName
);

-- 6. Fruits pivot
SELECT Name,
       SUM(CASE WHEN Fruit='Apple' THEN 1 ELSE 0 END) AS Apple,
       SUM(CASE WHEN Fruit='Orange' THEN 1 ELSE 0 END) AS Orange,
       SUM(CASE WHEN Fruit='Banana' THEN 1 ELSE 0 END) AS Banana
FROM Fruits
GROUP BY Name;

-- 7. Older people with younger ones (transitive closure)
WITH RecursiveFamily AS (
    SELECT ParentId, ChildID
    FROM Family
    UNION ALL
    SELECT f.ParentId, r.ChildID
    FROM Family f
    JOIN RecursiveFamily r ON f.ChildID = r.ParentId
)
SELECT DISTINCT ParentId AS PID, ChildID AS CHID
FROM RecursiveFamily
ORDER BY PID, CHID;

-- 8. Orders delivered to TX for customers with CA orders
SELECT o.*
FROM #Orders o
WHERE o.DeliveryState='TX'
  AND EXISTS (
      SELECT 1 FROM #Orders x
      WHERE x.CustomerID=o.CustomerID
        AND x.DeliveryState='CA'
);

-- 9. Insert missing names into #residents
UPDATE r
SET fullname = fullname + ' name=' +
               SUBSTRING(address, CHARINDEX('name=',address)+5, 
                         CHARINDEX('age=',address)-CHARINDEX('name=',address)-6)
FROM #residents r
WHERE fullname IS NULL OR fullname NOT LIKE '%name=%';

-- 10. Cheapest & Most Expensive routes Tashkent->Khorezm
WITH Paths AS (
    SELECT RouteID, DepartureCity, ArrivalCity, Cost, 
           CAST(DepartureCity + ' - ' + ArrivalCity AS VARCHAR(MAX)) AS Route
    FROM #Routes
    WHERE DepartureCity='Tashkent'
    UNION ALL
    SELECT r.RouteID, p.DepartureCity, r.ArrivalCity, p.Cost+r.Cost,
           p.Route + ' - ' + r.ArrivalCity
    FROM Paths p
    JOIN #Routes r ON p.ArrivalCity=r.DepartureCity
)
SELECT TOP 1 Route, Cost FROM Paths WHERE ArrivalCity='Khorezm' ORDER BY Cost ASC;
SELECT TOP 1 Route, Cost FROM Paths WHERE ArrivalCity='Khorezm' ORDER BY Cost DESC;

-- 11. Rank products by insertion (dense groups)
SELECT ID, Vals,
       SUM(CASE WHEN Vals='Product' THEN 1 ELSE 0 END) 
       OVER(ORDER BY ID) AS ProductGroup
FROM #RankingPuzzle;

-- 12. Employees whose sales > avg in dept
SELECT e.*
FROM #EmployeeSales e
WHERE e.SalesAmount >
      (SELECT AVG(SalesAmount)
       FROM #EmployeeSales
       WHERE Department=e.Department
         AND SalesMonth=e.SalesMonth
         AND SalesYear=e.SalesYear);

-- 13. Employees with highest sales in any month (EXISTS)
SELECT DISTINCT e.EmployeeName
FROM #EmployeeSales e
WHERE EXISTS (
    SELECT 1
    FROM #EmployeeSales x
    WHERE x.SalesMonth=e.SalesMonth
      AND x.SalesYear=e.SalesYear
    GROUP BY x.SalesMonth,x.SalesYear
    HAVING MAX(x.SalesAmount)=e.SalesAmount
);

-- 14. Employees with sales in every month (NOT EXISTS)
SELECT DISTINCT e.EmployeeName
FROM #EmployeeSales e
WHERE NOT EXISTS (
    SELECT DISTINCT SalesMonth
    FROM #EmployeeSales
    WHERE SalesYear=2024
    EXCEPT
    SELECT SalesMonth
    FROM #EmployeeSales es
    WHERE es.EmployeeName=e.EmployeeName AND SalesYear=2024
);

-- 15. Products more expensive than avg
SELECT Name
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products);

-- 16. Products stock lower than max stock
SELECT Name
FROM Products
WHERE Stock < (SELECT MAX(Stock) FROM Products);

-- 17. Products same category as Laptop
SELECT Name
FROM Products
WHERE Category = (SELECT Category FROM Products WHERE Name='Laptop');

-- 18. Products price > min price in Electronics
SELECT Name
FROM Products
WHERE Price > (SELECT MIN(Price) FROM Products WHERE Category='Electronics');

-- 19. Products price > avg in their category
SELECT Name
FROM Products p
WHERE Price > (SELECT AVG(Price) FROM Products WHERE Category=p.Category);

-- 20. Products ordered at least once
SELECT DISTINCT p.Name
FROM Products p
JOIN Orders o ON p.ProductID=o.ProductID;

-- 21. Products ordered more than avg quantity
SELECT p.Name
FROM Products p
JOIN Orders o ON p.ProductID=o.ProductID
GROUP BY p.Name
HAVING SUM(o.Quantity) > (SELECT AVG(Quantity) FROM Orders);

-- 22. Products never ordered
SELECT p.Name
FROM Products p
WHERE NOT EXISTS (SELECT 1 FROM Orders o WHERE o.ProductID=p.ProductID);

-- 23. Product with highest total qty ordered
SELECT TOP 1 p.Name, SUM(o.Quantity) AS TotalQty
FROM Products p
JOIN Orders o ON p.ProductID=o.ProductID
GROUP BY p.Name
ORDER BY TotalQty DESC;
