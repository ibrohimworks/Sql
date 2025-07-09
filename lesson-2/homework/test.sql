
CREATE TABLE Employees (
    EmpID INT,
    Name VARCHAR(50),
    Salary DECIMAL(10,2)
);

-- Insert records
INSERT INTO Employees (EmpID, Name, Salary)
VALUES (1, 'Ali', 6000.00);

INSERT INTO Employees (EmpID, Name, Salary)
VALUES 
(2, 'Laylo', 5500.00),
(3, 'Jasur', 4800.00);

-- Update salary
UPDATE Employees
SET Salary = 7000
WHERE EmpID = 1;

-- Delete record
DELETE FROM Employees
WHERE EmpID = 2;

-- Modify column Name
ALTER TABLE Employees
ALTER COLUMN Name VARCHAR(100);

-- Add column Department
ALTER TABLE Employees
ADD Department VARCHAR(50);

-- Change Salary to FLOAT
ALTER TABLE Employees
ALTER COLUMN Salary FLOAT;

-- Create Departments table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

-- Truncate Employees table
TRUNCATE TABLE Employees;

-- Intermediate-Level Tasks (6)
-- Insert into Departments using SELECT
INSERT INTO Departments (DepartmentID, DepartmentName)
SELECT 1, 'HR' UNION
SELECT 2, 'IT' UNION
SELECT 3, 'Sales' UNION
SELECT 4, 'Marketing' UNION
SELECT 5, 'Finance';

-- Update Department
UPDATE Employees
SET Department = 'Management'
WHERE Salary > 5000;

-- Delete all employees
DELETE FROM Employees;

-- Drop Department column
ALTER TABLE Employees
DROP COLUMN Department;

-- Rename Employees to StaffMembers
EXEC sp_rename 'Employees', 'StaffMembers';

-- Drop Departments table
DROP TABLE Departments;

-- Advanced-Level Tasks (9)
-- Create Products table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Description VARCHAR(255)
);

-- Add CHECK constraint
ALTER TABLE Products
ADD CONSTRAINT chk_Price CHECK (Price > 0);

-- Add StockQuantity with DEFAULT
ALTER TABLE Products
ADD StockQuantity INT DEFAULT 50;

-- Rename Category to ProductCategory
EXEC sp_rename 'Products.Category', 'ProductCategory', 'COLUMN';

-- Insert 5 records into Products
INSERT INTO Products (ProductID, ProductName, ProductCategory, Price, Description)
VALUES
(1, 'Laptop', 'Electronics', 1500.00, 'Gaming laptop'),
(2, 'Phone', 'Electronics', 800.00, 'Smartphone'),
(3, 'Chair', 'Furniture', 120.00, 'Office chair'),
(4, 'Table', 'Furniture', 200.00, 'Wooden table'),
(5, 'Mouse', 'Electronics', 25.00, 'Wireless mouse');

-- Create Products_Backup using SELECT INTO
SELECT * INTO Products_Backup
FROM Products;

-- Rename Products to Inventory
EXEC sp_rename 'Products', 'Inventory';

-- Change Price to FLOAT
ALTER TABLE Inventory
ALTER COLUMN Price FLOAT;

-- Add IDENTITY column ProductCode (need to recreate table)
CREATE TABLE Inventory_New (
    ProductCode INT IDENTITY(1000, 5) PRIMARY KEY,
    ProductID INT,
    ProductName VARCHAR(100),
    ProductCategory VARCHAR(50),
    Price FLOAT,
    Description VARCHAR(255),
    StockQuantity INT
);

-- Transfer data
INSERT INTO Inventory_New (ProductID, ProductName, ProductCategory, Price, Description, StockQuantity)
SELECT ProductID, ProductName, ProductCategory, Price, Description, StockQuantity
FROM Inventory;

-- Optionally drop old table and rename new one
-- DROP TABLE Inventory;
-- EXEC sp_rename 'Inventory_New', 'Inventory';
