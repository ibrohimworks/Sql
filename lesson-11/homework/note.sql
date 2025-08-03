-- 🟢 Easy-Level Tasks

-- 1. Заказы после 2022 года с именами клиентов
SELECT 
    O.OrderID, 
    C.CustomerName, 
    O.OrderDate
FROM 
    Orders O
JOIN 
    Customers C ON O.CustomerID = C.CustomerID
WHERE 
    YEAR(O.OrderDate) > 2022;

-- 2. Сотрудники из отделов Sales или Marketing
SELECT 
    E.EmployeeName, 
    D.DepartmentName
FROM 
    Employees E
JOIN 
    Departments D ON E.DepartmentID = D.DepartmentID
WHERE 
    D.DepartmentName IN ('Sales', 'Marketing');

-- 3. Максимальная зарплата в каждом отделе
SELECT 
    D.DepartmentName, 
    MAX(E.Salary) AS MaxSalary
FROM 
    Departments D
JOIN 
    Employees E ON D.DepartmentID = E.DepartmentID
GROUP BY 
    D.DepartmentName;

-- 4. Клиенты из США, сделавшие заказы в 2023
SELECT 
    C.CustomerName, 
    O.OrderID, 
    O.OrderDate
FROM 
    Customers C
JOIN 
    Orders O ON C.CustomerID = O.CustomerID
WHERE 
    C.Country = 'USA' AND YEAR(O.OrderDate) = 2023;

-- 5. Количество заказов по каждому клиенту
SELECT 
    C.CustomerName, 
    COUNT(O.OrderID) AS TotalOrders
FROM 
    Customers C
LEFT JOIN 
    Orders O ON C.CustomerID = O.CustomerID
GROUP BY 
    C.CustomerName;

-- 6. Продукты от указанных поставщиков
SELECT 
    P.ProductName, 
    S.SupplierName
FROM 
    Products P
JOIN 
    Suppliers S ON P.SupplierID = S.SupplierID
WHERE 
    S.SupplierName IN ('Gadget Supplies', 'Clothing Mart');

-- 7. Самая последняя дата заказа для каждого клиента
SELECT 
    C.CustomerName, 
    MAX(O.OrderDate) AS MostRecentOrderDate
FROM 
    Customers C
LEFT JOIN 
    Orders O ON C.CustomerID = O.CustomerID
GROUP BY 
    C.CustomerName;

-- 🟠 Medium-Level Tasks

-- 1. Клиенты, заказавшие на сумму больше 500
SELECT 
    C.CustomerName, 
    O.TotalAmount AS OrderTotal
FROM 
    Orders O
JOIN 
    Customers C ON O.CustomerID = C.CustomerID
WHERE 
    O.TotalAmount > 500;

-- 2. Продажи за 2022 год или свыше 400
SELECT 
    P.ProductName, 
    S.SaleDate, 
    S.SaleAmount
FROM 
    Sales S
JOIN 
    Products P ON S.ProductID = P.ProductID
WHERE 
    YEAR(S.SaleDate) = 2022 OR S.SaleAmount > 400;

-- 3. Общая сумма продаж по каждому товару
SELECT 
    P.ProductName, 
    SUM(S.SaleAmount) AS TotalSalesAmount
FROM 
    Sales S
JOIN 
    Products P ON S.ProductID = P.ProductID
GROUP BY 
    P.ProductName;

-- 4. Сотрудники из HR с зарплатой более 60000
SELECT 
    E.EmployeeName, 
    D.DepartmentName, 
    E.Salary
FROM 
    Employees E
JOIN 
    Departments D ON E.DepartmentID = D.DepartmentID
WHERE 
    D.DepartmentName = 'HR' AND E.Salary > 60000;

-- 5. Продажи 2023 года и запас больше 100
SELECT 
    P.ProductName, 
    S.SaleDate, 
    P.StockQuantity
FROM 
    Sales S
JOIN 
    Products P ON S.ProductID = P.ProductID
WHERE 
    YEAR(S.SaleDate) = 2023 AND P.StockQuantity > 100;

-- 6. Сотрудники в Sales или нанятые после 2020
SELECT 
    E.EmployeeName, 
    D.DepartmentName, 
    E.HireDate
FROM 
    Employees E
JOIN 
    Departments D ON E.DepartmentID = D.DepartmentID
WHERE 
    D.DepartmentName = 'Sales' OR E.HireDate > '2020-12-31';

-- 🔴 Hard-Level Tasks

-- 1. Заказы от клиентов из США, адрес начинается с 4 цифр
SELECT 
    C.CustomerName, 
    O.OrderID, 
    C.Address, 
    O.OrderDate
FROM 
    Customers C
JOIN 
    Orders O ON C.CustomerID = O.CustomerID
WHERE 
    C.Country = 'USA' AND C.Address LIKE '[0-9][0-9][0-9][0-9]%';

-- 2. Продажи по категории Electronics или суммой > 350
SELECT 
    P.ProductName, 
    P.Category, 
    S.SaleAmount
FROM 
    Sales S
JOIN 
    Products P ON S.ProductID = P.ProductID
WHERE 
    P.Category = 'Electronics' OR S.SaleAmount > 350;

-- 3. Количество товаров по каждой категории
SELECT 
    C.CategoryName, 
    COUNT(P.ProductID) AS ProductCount
FROM 
    Categories C
JOIN 
    Products P ON C.CategoryID = P.CategoryID
GROUP BY 
    C.CategoryName;

-- 4. Заказы от клиентов из Лос-Анджелеса на сумму более 300
SELECT 
    C.CustomerName, 
    C.City, 
    O.OrderID, 
    O.TotalAmount AS Amount
FROM 
    Customers C
JOIN 
    Orders O ON C.CustomerID = O.CustomerID
WHERE 
    C.City = 'Los Angeles' AND O.TotalAmount > 300;

-- 5. Сотрудники из HR/Finance или имя с ≥ 4 гласными
SELECT 
    E.EmployeeName, 
    D.DepartmentName
FROM 
    Employees E
JOIN 
    Departments D ON E.DepartmentID = D.DepartmentID
WHERE 
    D.DepartmentName IN ('HR', 'Finance') 
    OR 
    LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(E.EmployeeName, 'a',''), 'e',''), 'i',''), 'o',''), 'u','')) <= LEN(E.EmployeeName) - 4;

-- 6. Сотрудники из Sales/Marketing и зарплата > 60000
SELECT 
    E.EmployeeName, 
    D.DepartmentName, 
    E.Salary
FROM 
    Employees E
JOIN 
    Departments D ON E.DepartmentID = D.DepartmentID
WHERE 
    D.DepartmentName IN ('Sales', 'Marketing') AND E.Salary > 60000;
