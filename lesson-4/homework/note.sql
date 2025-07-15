create database MaabHome_4
go

create table Employees (
EmployeeId int primary key,
Firstname varchar(50),
Lastname varchar (50),
Department varchar (50),
Salary int,
Email varchar (100), 
)

create table Products (
ProductId int primary key,
Productname varchar (100),
category varchar (50),
Price decimal (10,2)
)
 
 create table Customers (
 CustomersId int primary key,
 Firstname varchar(50),
 Lastname varchar (50)
 )

 -- Данные в Employees
INSERT INTO Employees VALUES
(1, 'Ali', 'Karimov', 'HR', 65000, NULL),
(2, 'Vali', 'Nazarov', 'IT', 55000, 'vali@example.com'),
(3, 'Aziz', 'Ergashev', 'HR', 60000, NULL),
(4, 'Malika', 'Sharipova', 'Marketing', 70000, 'malika@example.com'),
(5, 'Dilshod', 'Yusupov', 'HR', 58000, NULL),
(6, 'Javlon', 'Turgunov', 'Finance', 62000, 'javlon@example.com')

-- Данные в Products
INSERT INTO Products VALUES
(1, 'Monitor', 'Electronics', 120.00),
(2, 'Mouse', 'Electronics', 25.00),
(3, 'Desk', 'Furniture', 80.00),
(4, 'Chair', 'Furniture', 100.00),
(5, 'Keyboard', 'Electronics', 50.00),
(6, 'Lamp', 'Home', 60.00),
(7, 'Notebook', 'Stationery', 10.00)

-- Данные в Customers
INSERT INTO Customers VALUES
(1, 'Azam', 'Sultonov'),
(2, 'Begzod', 'Rakhmatov'),
(3, 'Anvar', 'Ismoilov'),
(4, 'Alisher', 'Toirov'),
(5, 'Shahzod', 'Muminov')

select top 5 * from Employees

select distinct category from Products

select * from Products 
where Price>100

select * from Customers 
where Firstname like 'A%'

select * from Products 
order by  Price asc

select * from Employees 
where Salary >= 60000 and Department = 'HR'

select EmployeeId, Firstname, Lastname, Department,
Salary, ISNULL(Email, 'noemail@example.com') as Email
from Employees

select * from Products
where Price between 50 and 100

select distinct Category, ProductName from Products

select distinct Category, productName 
from Products
order by Productname desc








