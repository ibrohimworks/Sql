-----------------------------
-- EASY TASKS
-----------------------------

SELECT emp_id || '-' || first_name || ' ' || last_name AS employee_info
FROM employees
WHERE emp_id = 100;

UPDATE employees
SET phone_number = REPLACE(phone_number, '124', '999');

SELECT first_name AS "First Name",
       LENGTH(first_name) AS "Name Length"
FROM employees
WHERE first_name LIKE 'A%' 
   OR first_name LIKE 'J%' 
   OR first_name LIKE 'M%'
ORDER BY first_name;

SELECT manager_id, SUM(salary) AS total_salary
FROM employees
GROUP BY manager_id;

SELECT year,
       GREATEST(Max1, Max2, Max3) AS max_value
FROM TestMax;

SELECT *
FROM cinema
WHERE MOD(id, 2) = 1
  AND description <> 'boring';

SELECT *
FROM SingleOrder
ORDER BY (id = 0), id;

SELECT COALESCE(col1, col2, col3, col4) AS first_not_null
FROM person;


-----------------------------
-- MEDIUM TASKS
-----------------------------

SELECT 
  SUBSTRING_INDEX(FullName, ' ', 1) AS FirstName,
  SUBSTRING_INDEX(SUBSTRING_INDEX(FullName, ' ', 2), ' ', -1) AS MiddleName,
  SUBSTRING_INDEX(FullName, ' ', -1) AS LastName
FROM Students;

SELECT *
FROM Orders
WHERE customer_id IN (
    SELECT customer_id
    FROM Orders
    WHERE state = 'California'
)
AND state = 'Texas';

SELECT GROUP_CONCAT(value_column ORDER BY value_column) AS concatenated_values
FROM DMLTable;

SELECT first_name, last_name
FROM employees
WHERE LENGTH(LOWER(first_name || last_name))
     - LENGTH(REPLACE(LOWER(first_name || last_name), 'a', '')) >= 3;

SELECT department_id,
       COUNT(*) AS total_employees,
       100.0 * SUM(CASE WHEN months_between(SYSDATE, hire_date)/12 > 3 THEN 1 ELSE 0 END) / COUNT(*) AS percent_over_3_years
FROM employees
GROUP BY department_id;

SELECT job_description,
       MIN(experience_years) AS least_experienced,
       MAX(experience_years) AS most_experienced
FROM Personal
WHERE job_description = 'Spaceman'
GROUP BY job_description;


-----------------------------
-- DIFFICULT TASKS
-----------------------------

SELECT 
  REGEXP_REPLACE('tf56sd#%OqH', '[^A-Z]', '') AS uppercase_letters,
  REGEXP_REPLACE('tf56sd#%OqH', '[^a-z]', '') AS lowercase_letters,
  REGEXP_REPLACE('tf56sd#%OqH', '[^0-9]', '') AS numbers,
  REGEXP_REPLACE('tf56sd#%OqH', '[A-Za-z0-9]', '') AS others;

SELECT id, value,
       SUM(value) OVER (ORDER BY id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_sum
FROM Students;

SELECT equation,
       (SELECT SUM(val) 
        FROM (SELECT CAST(value AS SIGNED) AS val 
              FROM JSON_TABLE(CONCAT('["', REPLACE(equation, '+', '","'), '"]'),
              '$[*]' COLUMNS(value VARCHAR(10) PATH '$')) t)
       ) AS result
FROM Equations;

SELECT birth_date, GROUP_CONCAT(student_id) AS students
FROM Student
GROUP BY birth_date
HAVING COUNT(*) > 1;

SELECT LEAST(playerA, playerB) AS player1,
       GREATEST(playerA, playerB) AS player2,
       SUM(score) AS total_score
FROM PlayerScores
GROUP BY LEAST(playerA, playerB), GREATEST(playerA, playerB);
