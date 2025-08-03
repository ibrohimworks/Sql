SELECT 
    P.firstName, 
    P.lastName, 
    A.city, 
    A.state
FROM 
    Person P
LEFT JOIN 
    Address A ON P.personId = A.personId;

SELECT 
    E.name AS Employee
FROM 
    Employee E
JOIN 
    Employee M ON E.managerId = M.id
WHERE 
    E.salary > M.salary;
-- 3. Найти дублирующиеся email
SELECT email
FROM Person
GROUP BY email
HAVING COUNT(*) > 1;

-- 4. Удалить дубликаты email, оставить строку с наименьшим id
DELETE FROM Person
WHERE id NOT IN (
    SELECT MIN(id)
    FROM Person
    GROUP BY email
);

-- 5. Родители, у которых только девочки
SELECT DISTINCT g.ParentName
FROM girls g
WHERE g.ParentName NOT IN (
    SELECT b.ParentName FROM boys b
);

-- 6. Общая сумма и минимальный вес заказов весом > 50 для каждого клиента
SELECT 
    custid, 
    SUM(orderamount) AS TotalAmount, 
    MIN(weight) AS MinWeight
FROM Sales.Orders
WHERE weight > 50
GROUP BY custid;

-- 7. Содержимое тележек
SELECT 
    COALESCE(c1.Item, '') AS [Item Cart 1], 
    COALESCE(c2.Item, '') AS [Item Cart 2]
FROM 
    (SELECT Item, ROW_NUMBER() OVER (ORDER BY Item) AS rn FROM Cart1) c1
FULL OUTER JOIN 
    (SELECT Item, ROW_NUMBER() OVER (ORDER BY Item) AS rn FROM Cart2) c2
ON c1.rn = c2.rn;

-- 8. Клиенты, которые никогда не заказывали
SELECT name AS Customers
FROM Customers
WHERE id NOT IN (
    SELECT customerId FROM Orders
);

-- 9. Количество посещений экзаменов студентами по всем предметам
SELECT 
    s.student_id, 
    s.student_name, 
    sub.subject_name, 
    COUNT(e.subject_name) AS attended_exams
FROM Students s
CROSS JOIN Subjects sub
LEFT JOIN Examinations e 
    ON s.student_id = e.student_id AND sub.subject_name = e.subject_name
GROUP BY s.student_id, s.student_name, sub.subject_name
ORDER BY s.student_id, sub.subject_name;
