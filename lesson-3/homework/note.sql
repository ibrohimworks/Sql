
-- Easy-Level Tasks

-- 1. BULK INSERT explanation (comment only)
-- BULK INSERT is used to quickly load data from a file into a SQL Server table.

-- 2. File formats supported: .csv, .txt, .xml, .json

-- 3. Create Products table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    Price DECIMAL(10,2)
);

-- 4. Insert three records into Products
INSERT INTO Products (ProductID, ProductName, Price)
VALUES
(1, 'Laptop', 1500.00),
(2, 'Mouse', 25.99),
(3, 'Keyboard', 45.50);

-- 5. NULL vs NOT NULL explained (comment)
-- NULL means no value, NOT NULL means value is required.

-- 6. Add UNIQUE constraint to ProductName
ALTER TABLE Products
ADD CONSTRAINT UQ_ProductName UNIQUE (ProductName);

-- 7. Comment in SQL
-- This query selects all products
SELECT * FROM Products;

-- 8. Add CategoryID column to Products
ALTER TABLE Products
ADD CategoryID INT;

-- 9. Create Categories table
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50) UNIQUE
);

-- 10. IDENTITY column purpose (example)
CREATE TABLE AutoProducts (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(50)
);

-- Medium-Level Tasks

-- 1. BULK INSERT from a file
BULK INSERT Products
FROM 'C:\Data\products.txt'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

-- 2. Add FOREIGN KEY to Products
ALTER TABLE Products
ADD CONSTRAINT FK_Products_Categories
FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID);

-- 3. PRIMARY KEY vs UNIQUE KEY explained (comment)
-- PRIMARY KEY = one per table, no NULLs
-- UNIQUE KEY = multiple per table, allows one NULL

-- 4. Add CHECK constraint for Price > 0
ALTER TABLE Products
ADD CONSTRAINT CHK_Price CHECK (Price > 0);

-- 5. Add Stock column
ALTER TABLE Products
ADD Stock INT NOT NULL DEFAULT 0;

-- 6. Use ISNULL function
SELECT ProductName, ISNULL(Price, 0) AS PriceWithZero
FROM Products;

-- 7. FOREIGN KEY purpose (comment)
-- FOREIGN KEY ensures referential integrity between tables.

-- Hard-Level Tasks

-- 1. Create Customers with Age >= 18
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(50),
    Age INT CHECK (Age >= 18)
);

-- 2. Table with IDENTITY starting at 100 and incrementing by 10
CREATE TABLE Orders (
    OrderID INT IDENTITY(100,10) PRIMARY KEY,
    OrderDate DATE
);

-- 3. Composite PRIMARY KEY
CREATE TABLE OrderDetails (
    OrderID INT,
    ProductID INT,
    Quantity INT,
    PRIMARY KEY (OrderID, ProductID)
);

-- 4. COALESCE and ISNULL explanation (comment)
-- COALESCE returns first non-NULL, ISNULL replaces NULL with specified value

-- 5. Employees table with PRIMARY KEY and UNIQUE Email
CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    Name VARCHAR(50),
    Email VARCHAR(100) UNIQUE
);

-- 6. FOREIGN KEY with ON DELETE and UPDATE CASCADE
ALTER TABLE Products
ADD CONSTRAINT FK_Products_Categories_Cascade
FOREIGN KEY (CategoryID)
REFERENCES Categories(CategoryID)
ON DELETE CASCADE
ON UPDATE CASCADE;
