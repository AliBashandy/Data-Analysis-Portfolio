-- UNIONS

SELECT 
    first_name, last_name
FROM
    employee_demographics 
UNION  #by default it it UNION DISTINCT
SELECT 
    first_name, last_name
FROM
    employee_salary
;

SELECT 
    first_name, last_name
FROM
    employee_demographics 
UNION ALL #to keep all values 
SELECT 
    first_name, last_name
FROM
    employee_salary
;

SELECT 
    first_name, last_name, 'OLD' AS label
FROM
    employee_demographics
WHERE
    age > 50 
UNION SELECT 
    first_name, last_name, 'HIGH PAID' AS label
FROM
    employee_salary
WHERE
    salary > 70000
;

SELECT 
    first_name, last_name, 'OLD Male' AS label
FROM
    employee_demographics
WHERE
    age > 40 AND gender = 'Male'
UNION
SELECT 
    first_name, last_name, 'OLD Lady' AS label
FROM
    employee_demographics
WHERE
age > 40 AND gender = 'Female'
UNION SELECT 
    first_name, last_name, 'HIGH PAID' AS label
FROM
    employee_salary
WHERE
    salary > 70000
ORDER BY
first_name, last_name    
;