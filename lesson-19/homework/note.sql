

-- Task 1: Employee Bonus with Temp Table
IF OBJECT_ID('sp_GetEmployeeBonus') IS NOT NULL DROP PROC sp_GetEmployeeBonus;
GO
CREATE PROC sp_GetEmployeeBonus
AS
BEGIN
    CREATE TABLE #EmployeeBonus (
        EmployeeID INT,
        FullName NVARCHAR(100),
        Department NVARCHAR(50),
        Salary DECIMAL(10,2),
        BonusAmount DECIMAL(10,2)
    );

    INSERT INTO #EmployeeBonus
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS FullName,
        e.Department,
        e.Salary,
        e.Salary * db.BonusPercentage / 100.0 AS BonusAmount
    FROM Employees e
    JOIN DepartmentBonus db ON e.Department = db.Department;

    SELECT * FROM #EmployeeBonus;
END;
GO

EXEC sp_GetEmployeeBonus;


-- Task 2: Update salary by department %
IF OBJECT_ID('sp_UpdateDepartmentSalary') IS NOT NULL DROP PROC sp_UpdateDepartmentSalary;
GO
CREATE PROC sp_UpdateDepartmentSalary
    @Dept NVARCHAR(50),
    @Percent DECIMAL(5,2)
AS
BEGIN
    UPDATE Employees
    SET Salary = Salary * (1 + @Percent/100.0)
    WHERE Department = @Dept;

    SELECT * FROM Employees WHERE Department = @Dept;
END;
GO

EXEC sp_UpdateDepartmentSalary 'Sales', 5;




-- Task 3: MERGE Products
MERGE INTO Products_Current AS tgt
USING Products_New AS src
ON tgt.ProductID = src.ProductID
WHEN MATCHED THEN
    UPDATE SET tgt.ProductName = src.ProductName,
               tgt.Price = src.Price
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ProductID, ProductName, Price)
    VALUES (src.ProductID, src.ProductName, src.Price)
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;

SELECT * FROM Products_Current;


-- Task 4: Tree Node classification
SELECT 
    t.id,
    CASE 
        WHEN t.p_id IS NULL THEN 'Root'
        WHEN EXISTS (SELECT 1 FROM Tree c WHERE c.p_id = t.id) THEN 'Inner'
        ELSE 'Leaf'
    END AS type
FROM Tree t;


-- Task 5: Confirmation Rate
SELECT 
    s.user_id,
    ROUND(
        ISNULL(SUM(CASE WHEN c.action='confirmed' THEN 1.0 ELSE 0 END) / 
               NULLIF(COUNT(c.user_id),0),0),2
    ) AS confirmation_rate
FROM Signups s
LEFT JOIN Confirmations c ON s.user_id = c.user_id
GROUP BY s.user_id;


-- Task 6: Employees with lowest salary
SELECT *
FROM employees e
WHERE e.salary = (SELECT MIN(salary) FROM employees);


-- Task 7: Stored Proc GetProductSalesSummary
IF OBJECT_ID('GetProductSalesSummary') IS NOT NULL DROP PROC GetProductSalesSummary;
GO
CREATE PROC GetProductSalesSummary
    @ProductID INT
AS
BEGIN
    SELECT 
        p.ProductName,
        SUM(s.Quantity) AS TotalQuantity,
        SUM(s.Quantity * p.Price) AS TotalSalesAmount,
        MIN(s.SaleDate) AS FirstSaleDate,
        MAX(s.SaleDate) AS LastSaleDate
    FROM Products p
    LEFT JOIN Sales s ON p.ProductID = s.ProductID
    WHERE p.ProductID = @ProductID
    GROUP BY p.ProductName;
END;
GO

EXEC GetProductSalesSummary 1;
EXEC GetProductSalesSummary 20;  -- продукт без продаж
