-- 🟢 1. Employees with salary > 50000 and their department
SELECT 
    e.Name AS EmployeeName,
    e.Salary,
    d.DepartmentName
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.Salary > 50000;

-- 🟢 2. Customers and orders from 2023
SELECT 
    c.FirstName,
    c.LastName,
    o.OrderDate
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE YEAR(o.OrderDate) = 2023;

-- 🟢 3. All employees with their department names (including those without department)
SELECT 
    e.Name AS EmployeeName,
    d.DepartmentName
FROM Employees e
LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- 🟢 4. All suppliers and products they supply (including suppliers without products)
SELECT 
    s.SupplierName,
    p.ProductName
FROM Suppliers s
LEFT JOIN Products p ON s.SupplierID = p.SupplierID;

-- 🟢 5. All orders and their corresponding payments (including orders without payments and payments without orders)
SELECT 
    o.OrderID,
    o.OrderDate,
    p.PaymentDate,
    p.Amount
FROM Orders o
FULL OUTER JOIN Payments p ON o.OrderID = p.OrderID;

-- 🟢 6. Employee name with manager name
SELECT 
    e.Name AS EmployeeName,
    ISNULL(m.Name, 'No Manager') AS ManagerName
FROM Employees e
LEFT JOIN Employees m ON e.ManagerID = m.EmployeeID;

-- 🟢 7. Students enrolled in "Math 101"
SELECT 
    s.StudentName,
    c.CourseName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
WHERE c.CourseName = 'Math 101';

-- 🟢 8. Customers who placed an order with more than 3 items
SELECT 
    c.FirstName,
    c.LastName,
    o.Quantity
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.Quantity > 3;

-- 🟢 9. Employees in "Human Resources" department
SELECT 
    e.Name AS EmployeeName,
    d.DepartmentName
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Human Resources';

-- 🟢 10. (Дополнительно) Students who are NOT enrolled in any course
SELECT 
    s.StudentName
FROM Students s
LEFT JOIN Enrollments e ON s.StudentID = e.StudentID
WHERE e.EnrollmentID IS NULL;

-- 🟠 1. Department names with more than 5 employees
SELECT 
    d.DepartmentName,
    COUNT(e.EmployeeID) AS EmployeeCount
FROM Departments d
JOIN Employees e ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName
HAVING COUNT(e.EmployeeID) > 5;

-- 🟠 2. Products that have never been sold
SELECT 
    p.ProductID,
    p.ProductName
FROM Products p
LEFT JOIN Sales s ON p.ProductID = s.ProductID
WHERE s.SaleID IS NULL;

-- 🟠 3. Customers who have placed at least one order
SELECT 
    c.FirstName,
    c.LastName,
    COUNT(o.OrderID) AS TotalOrders
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.FirstName, c.LastName;

-- 🟠 4. Employees and departments where both exist (no NULLs)
SELECT 
    e.Name AS EmployeeName,
    d.DepartmentName
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- 🟠 5. Pairs of employees who report to the same manager
SELECT 
    e1.Name AS Employee1,
    e2.Name AS Employee2,
    e1.ManagerID
FROM Employees e1
JOIN Employees e2 ON e1.ManagerID = e2.ManagerID
WHERE e1.EmployeeID < e2.EmployeeID AND e1.ManagerID IS NOT NULL;

-- 🟠 6. All orders placed in 2022 with customer names
SELECT 
    o.OrderID,
    o.OrderDate,
    c.FirstName,
    c.LastName
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE YEAR(o.OrderDate) = 2022;

-- 🟠 7. Employees in 'Sales' department with salary > 60000
SELECT 
    e.Name AS EmployeeName,
    e.Salary,
    d.DepartmentName
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Sales' AND e.Salary > 60000;

-- 🟠 8. Orders that have a corresponding payment
SELECT 
    o.OrderID,
    o.OrderDate,
    p.PaymentDate,
    p.Amount
FROM Orders o
JOIN Payments p ON o.OrderID = p.OrderID;

-- 🟠 9. Products that were never ordered
SELECT 
    p.ProductID,
    p.ProductName
FROM Products p
LEFT JOIN Orders o ON p.ProductID = o.ProductID
WHERE o.OrderID IS NULL;


-- 🔴 1. Employees earning more than the average salary in their department
SELECT 
    e.Name AS EmployeeName,
    e.Salary
FROM Employees e
JOIN (
    SELECT DepartmentID, AVG(Salary) AS AvgSalary
    FROM Employees
    GROUP BY DepartmentID
) dept_avg ON e.DepartmentID = dept_avg.DepartmentID
WHERE e.Salary > dept_avg.AvgSalary;

-- 🔴 2. Orders before 2020 without corresponding payment
SELECT 
    o.OrderID,
    o.OrderDate
FROM Orders o
LEFT JOIN Payments p ON o.OrderID = p.OrderID
WHERE p.PaymentID IS NULL AND o.OrderDate < '2020-01-01';

-- 🔴 3. Products with no matching category
SELECT 
    p.ProductID,
    p.ProductName
FROM Products p
LEFT JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE c.CategoryID IS NULL;

-- 🔴 4. Employees with same manager and salary > 60000
SELECT 
    e1.Name AS Employee1,
    e2.Name AS Employee2,
    e1.ManagerID,
    e1.Salary
FROM Employees e1
JOIN Employees e2 ON e1.ManagerID = e2.ManagerID AND e1.EmployeeID < e2.EmployeeID
WHERE e1.Salary > 60000 AND e2.Salary > 60000;

-- 🔴 5. Employees in departments starting with 'M'
SELECT 
    e.Name AS EmployeeName,
    d.DepartmentName
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName LIKE 'M%';

-- 🔴 6. Sales with amount > 500, including product names
SELECT 
    s.SaleID,
    p.ProductName,
    s.SaleAmount
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
WHERE s.SaleAmount > 500;

-- 🔴 7. Students not enrolled in 'Math 101'
SELECT 
    s.StudentID,
    s.StudentName
FROM Students s
WHERE s.StudentID NOT IN (
    SELECT e.StudentID
    FROM Enrollments e
    JOIN Courses c ON e.CourseID = c.CourseID
    WHERE c.CourseName = 'Math 101'
);

-- 🔴 8. Orders missing payment details
SELECT 
    o.OrderID,
    o.OrderDate,
    p.PaymentID
FROM Orders o
LEFT JOIN Payments p ON o.OrderID = p.OrderID
WHERE p.PaymentID IS NULL;

-- 🔴 9. Products in 'Electronics' or 'Furniture' category
SELECT 
    p.ProductID,
    p.ProductName,
    c.CategoryName
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE c.CategoryName IN ('Electronics', 'Furniture');
