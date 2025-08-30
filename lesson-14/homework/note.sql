-----------------------------
-- EASY TASKS
-----------------------------

SELECT SUBSTRING_INDEX(Name, ',', 1) AS Name,
       SUBSTRING_INDEX(Name, ',', -1) AS Surname
FROM TestMultipleColumns;

SELECT *
FROM TestPercent
WHERE col LIKE '%\%%';

SELECT SUBSTRING_INDEX(str, '.', 1) AS part1,
       SUBSTRING_INDEX(SUBSTRING_INDEX(str, '.', 2), '.', -1) AS part2,
       SUBSTRING_INDEX(str, '.', -1) AS partN
FROM Splitter;

SELECT REGEXP_REPLACE('1234ABC123456XYZ1234567890ADS', '[0-9]', 'X') AS masked_str;

SELECT *
FROM testDots
WHERE LENGTH(Vals) - LENGTH(REPLACE(Vals, '.', '')) > 2;

SELECT LENGTH(string_col) - LENGTH(REPLACE(string_col, ' ', '')) AS space_count
FROM CountSpaces;

SELECT e.employee_id, e.first_name, e.last_name
FROM Employee e
JOIN Employee m ON e.manager_id = m.employee_id
WHERE e.salary > m.salary;

SELECT employee_id, first_name, last_name, hire_date,
       FLOOR(MONTHS_BETWEEN(SYSDATE, hire_date)/12) AS years_of_service
FROM Employees
WHERE FLOOR(MONTHS_BETWEEN(SYSDATE, hire_date)/12) BETWEEN 10 AND 14;


-----------------------------
-- MEDIUM TASKS
-----------------------------

SELECT REGEXP_REPLACE('rtcfvty34redt', '[^0-9]', '') AS numbers,
       REGEXP_REPLACE('rtcfvty34redt', '[0-9]', '') AS letters;

SELECT id
FROM weather w1
WHERE temperature > (
    SELECT temperature FROM weather w2
    WHERE w2.record_date = w1.record_date - INTERVAL 1 DAY
);

SELECT player_id, MIN(event_date) AS first_login
FROM Activity
GROUP BY player_id;

SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(fruits, ',', 3), ',', -1) AS third_item
FROM fruits;

SELECT SUBSTRING(value, n, 1) AS ch
FROM (SELECT 'sdgfhsdgfhs@121313131' AS value) t
JOIN (SELECT 1 n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
      UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10
      UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14
      UNION ALL SELECT 15 UNION ALL SELECT 16 UNION ALL SELECT 17 UNION ALL SELECT 18
      UNION ALL SELECT 19 UNION ALL SELECT 20) nums
ON n <= LENGTH(value);

SELECT p1.id, COALESCE(NULLIF(p1.code, 0), p2.code) AS code
FROM p1
JOIN p2 ON p1.id = p2.id;

SELECT employee_id, first_name, last_name,
       CASE 
         WHEN MONTHS_BETWEEN(SYSDATE, hire_date)/12 < 1 THEN 'New Hire'
         WHEN MONTHS_BETWEEN(SYSDATE, hire_date)/12 < 5 THEN 'Junior'
         WHEN MONTHS_BETWEEN(SYSDATE, hire_date)/12 < 10 THEN 'Mid-Level'
         WHEN MONTHS_BETWEEN(SYSDATE, hire_date)/12 < 20 THEN 'Senior'
         ELSE 'Veteran'
       END AS Employment_Stage
FROM Employees;

SELECT CAST(REGEXP_SUBSTR(Vals, '^[0-9]+') AS UNSIGNED) AS leading_integer
FROM GetIntegers;


-----------------------------
-- DIFFICULT TASKS
-----------------------------

SELECT CONCAT(
         SUBSTRING_INDEX(SUBSTRING_INDEX(val, ',', 1), ',', 1, 1),
         SUBSTRING(SUBSTRING_INDEX(val, ',', 1), 2),
         ',', 
         CONCAT(SUBSTRING(SUBSTRING_INDEX(val, ',', -1), 2),
                SUBSTRING(SUBSTRING_INDEX(val, ',', -1), 1, 1))
       ) AS swapped
FROM MultipleVals;

SELECT player_id, device_id
FROM Activity a
WHERE event_date = (
    SELECT MIN(event_date)
    FROM Activity
    WHERE player_id = a.player_id
);

SELECT area, week, day,
       100.0 * SUM(sales) / SUM(SUM(sales)) OVER (PARTITION BY area, week) AS percentage_of_week
FROM WeekPercentagePuzzle
GROUP BY area, week, day;
