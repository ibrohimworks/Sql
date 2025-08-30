-----------------------------
-- 1. Distributors sales by region (fill missing with 0)
-----------------------------
WITH Regions AS (
  SELECT DISTINCT Region FROM #RegionSales
),
Distributors AS (
  SELECT DISTINCT Distributor FROM #RegionSales
),
AllCombos AS (
  SELECT r.Region, d.Distributor
  FROM Regions r CROSS JOIN Distributors d
)
SELECT a.Region, a.Distributor, COALESCE(rs.Sales,0) AS Sales
FROM AllCombos a
LEFT JOIN #RegionSales rs
  ON a.Region = rs.Region AND a.Distributor = rs.Distributor
ORDER BY a.Distributor, a.Region;


-----------------------------
-- 2. Managers with at least 5 direct reports
-----------------------------
SELECT e1.name
FROM Employee e1
JOIN Employee e2 ON e1.id = e2.managerId
GROUP BY e1.id, e1.name
HAVING COUNT(e2.id) >= 5;


-----------------------------
-- 3. Products with ≥100 units in Feb 2020
-----------------------------
SELECT p.product_name, SUM(o.unit) AS unit
FROM Products p
JOIN Orders o ON p.product_id = o.product_id
WHERE o.order_date >= '2020-02-01' AND o.order_date < '2020-03-01'
GROUP BY p.product_name
HAVING SUM(o.unit) >= 100;


-----------------------------
-- 4. Vendor with most orders per customer
-----------------------------
SELECT CustomerID, Vendor
FROM (
  SELECT CustomerID, Vendor,
         RANK() OVER (PARTITION BY CustomerID ORDER BY SUM([Count]) DESC) AS rnk
  FROM Orders
  GROUP BY CustomerID, Vendor
) t
WHERE rnk = 1;


-----------------------------
-- 5. Check if number is prime (@Check_Prime)
-----------------------------
DECLARE @Check_Prime INT = 91;
DECLARE @i INT = 2, @isPrime BIT = 1;

WHILE @i <= SQRT(@Check_Prime)
BEGIN
    IF @Check_Prime % @i = 0
    BEGIN
        SET @isPrime = 0;
        BREAK;
    END
    SET @i = @i + 1;
END

IF @isPrime = 1 AND @Check_Prime > 1
    PRINT 'This number is prime';
ELSE
    PRINT 'This number is not prime';


-----------------------------
-- 6. Device locations & signals
-----------------------------
SELECT Device_id,
       COUNT(DISTINCT Locations) AS no_of_location,
       MAX(Locations) KEEP (DENSE_RANK FIRST ORDER BY cnt DESC) AS max_signal_location,
       COUNT(*) AS no_of_signals
FROM (
  SELECT Device_id, Locations, COUNT(*) AS cnt
  FROM Device
  GROUP BY Device_id, Locations
) t
GROUP BY Device_id;


-----------------------------
-- 7. Employees above dept avg
-----------------------------
SELECT e.EmpID, e.EmpName, e.Salary
FROM Employee e
JOIN (
  SELECT DeptID, AVG(Salary) AS avg_sal
  FROM Employee
  GROUP BY DeptID
) d ON e.DeptID = d.DeptID
WHERE e.Salary > d.avg_sal;


-----------------------------
-- 8. Lottery winnings
-----------------------------
WITH TicketMatch AS (
  SELECT t.TicketID, COUNT(DISTINCT t.Number) AS matched
  FROM Tickets t
  JOIN Numbers n ON t.Number = n.Number
  GROUP BY t.TicketID
),
Totals AS (
  SELECT TicketID,
         CASE WHEN matched = (SELECT COUNT(*) FROM Numbers) THEN 100
              WHEN matched > 0 THEN 10 ELSE 0 END AS prize
  FROM TicketMatch
)
SELECT SUM(prize) AS total_winnings FROM Totals;


-----------------------------
-- 9. Spending by platform per date
-----------------------------
WITH UserStats AS (
  SELECT User_id, Spend_date,
         SUM(CASE WHEN Platform='Mobile' THEN Amount ELSE 0 END) AS mob,
         SUM(CASE WHEN Platform='Desktop' THEN Amount ELSE 0 END) AS desk
  FROM Spending
  GROUP BY User_id, Spend_date
),
Expanded AS (
  SELECT Spend_date, 'Mobile' AS Platform, SUM(mob) AS Total_Amount, COUNT(DISTINCT User_id) AS Total_users
  FROM UserStats WHERE mob>0 AND desk=0 GROUP BY Spend_date
  UNION ALL
  SELECT Spend_date, 'Desktop', SUM(desk), COUNT(DISTINCT User_id)
  FROM UserStats WHERE desk>0 AND mob=0 GROUP BY Spend_date
  UNION ALL
  SELECT Spend_date, 'Both', SUM(mob+desk), COUNT(DISTINCT User_id)
  FROM UserStats WHERE mob>0 AND desk>0 GROUP BY Spend_date
)
SELECT ROW_NUMBER() OVER(ORDER BY Spend_date, Platform) AS Row,
       Spend_date, Platform, Total_Amount, Total_users
FROM Expanded;


-----------------------------
-- 10. De-group Grouped table
-----------------------------
WITH RECURSIVE cte AS (
  SELECT Product, Quantity, 1 AS q FROM Grouped
  UNION ALL
  SELECT Product, Quantity, q+1 FROM cte WHERE q+1 <= Quantity
)
SELECT Product, 1 AS Quantity FROM cte;
