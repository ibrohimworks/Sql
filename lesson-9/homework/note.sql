-- 1. List all combinations of product names and supplier names
SELECT p.product_name, s.supplier_name
FROM Products p
CROSS JOIN Suppliers s;

-- 2. Get all combinations of departments and employees
SELECT d.DeptName, e.EmpName
FROM Departments d
CROSS JOIN Employees e;

-- 3. List only the combinations where the supplier actually supplies the product
SELECT s.supplier_name, p.product_name
FROM Products p
JOIN Suppliers s ON p.supplier_id = s.supplier_id;

-- 4. List customer names and their orders ID
SELECT c.customer_name, o.order_id
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id;

-- 5. Get all combinations of students and courses
SELECT s.student_name, c.course_name
FROM Students s
CROSS JOIN Courses c;

-- 6. Get product names and orders where product IDs match
SELECT p.product_name, o.order_id
FROM Orders o
JOIN Products p ON o.product_id = p.product_id;

-- 7. List employees whose DepartmentID matches the department
SELECT e.EmpName, d.DeptName
FROM Employees e
JOIN Departments d ON e.DeptID = d.DeptID;

-- 8. List student names and their enrolled course IDs
SELECT s.student_name, e.course_id
FROM Enrollments e
JOIN Students s ON e.student_id = s.student_id;

-- 9. List all orders that have matching payments
SELECT o.order_id, p.payment_id
FROM Orders o
JOIN Payments p ON o.order_id = p.order_id;

-- 10. Show orders where product price is more than 100
SELECT o.order_id, p.product_name, p.price
FROM Orders o
JOIN Products p ON o.product_id = p.product_id
WHERE p.price > 100;

-- 11. Show all mismatched employee-department combinations
SELECT e.EmpName, d.DeptName
FROM Employees e
CROSS JOIN Departments d
WHERE e.DeptID != d.DeptID;

-- 12. Show orders where ordered quantity is greater than stock quantity
SELECT o.order_id, p.product_name, o.quantity, p.stock_quantity
FROM Orders o
JOIN Products p ON o.product_id = p.product_id
WHERE o.quantity > p.stock_quantity;

-- 13. List customer names and product IDs where sale amount is 500 or more
SELECT c.customer_name, s.product_id
FROM Sales s
JOIN Customers c ON s.customer_id = c.customer_id
WHERE s.amount >= 500;

-- 14. List student names and course names they’re enrolled in
SELECT s.student_name, c.course_name
FROM Enrollments e
JOIN Students s ON e.student_id = s.student_id
JOIN Courses c ON e.course_id = c.course_id;

-- 15. List product and supplier names where supplier name contains “Tech”
SELECT p.product_name, s.supplier_name
FROM Products p
JOIN Suppliers s ON p.supplier_id = s.supplier_id
WHERE s.supplier_name LIKE '%Tech%';

-- 16. Show orders where payment amount is less than total amount
SELECT o.order_id, p.payment_amount, o.total_amount
FROM Orders o
JOIN Payments p ON o.order_id = p.order_id
WHERE p.payment_amount < o.total_amount;

-- 17. Get the Department Name for each employee
SELECT e.EmpName, d.DeptName
FROM Employees e
JOIN Departments d ON e.DeptID = d.DeptID;

-- 18. Show products where category is either 'Electronics' or 'Furniture'
SELECT p.product_name, c.category_name
FROM Products p
JOIN Categories c ON p.category_id = c.category_id
WHERE c.category_name IN ('Electronics', 'Furniture');

-- 19. Show all sales from customers who are from 'USA'
SELECT s.*
FROM Sales s
JOIN Customers c ON s.customer_id = c.customer_id
WHERE c.country = 'USA';

-- 20. List orders made by customers from 'Germany' and order total > 100
SELECT o.order_id, c.customer_name, o.total_amount
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
WHERE c.country = 'Germany' AND o.total_amount > 100;

-- 21. List all pairs of employees from different departments
SELECT e1.EmpName AS Employee1, e2.EmpName AS Employee2
FROM Employees e1
JOIN Employees e2 ON e1.EmpID < e2.EmpID
WHERE e1.DeptID != e2.DeptID;

-- 22. List payment details where the paid amount is not equal to (Quantity × Product Price)
SELECT p.payment_id, o.order_id, p.amount_paid, o.quantity * pr.price AS expected_amount
FROM Payments p
JOIN Orders o ON p.order_id = o.order_id
JOIN Products pr ON o.product_id = pr.product_id
WHERE p.amount_paid != o.quantity * pr.price;

-- 23. Find students who are not enrolled in any course
SELECT s.student_name
FROM Students s
LEFT JOIN Enrollments e ON s.student_id = e.student_id
WHERE e.course_id IS NULL;

-- 24. List employees who are managers of someone, but their salary is less than or equal to the person they manage
SELECT m.EmpName AS Manager, e.EmpName AS Employee
FROM Employees m
JOIN Employees e ON m.EmpID = e.manager_id
WHERE m.salary <= e.salary;

-- 25. List customers who have made an order, but no payment has been recorded for it
SELECT c.customer_name, o.order_id
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
LEFT JOIN Payments p ON o.order_id = p.order_id
WHERE p.payment_id IS NULL;
