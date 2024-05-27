-- jOINS

SELECT 
    *
FROM
    employee_demographics
;

SELECT 
    *
FROM
    employee_salary
;

SELECT 
    *
FROM
    employee_demographics AS A
INNER JOIN
		employee_salary AS B
	ON
       A.employee_id = B.employee_id
;

SELECT 
    A.employee_id, age, occupation
FROM
    employee_demographics AS A
INNER JOIN
		employee_salary AS B
	ON
       A.employee_id = B.employee_id
;

SELECT 
    A.employee_id, age, occupation
FROM
    employee_demographics AS A
LEFT JOIN
		employee_salary AS B
	ON
       A.employee_id = B.employee_id
;

SELECT 
    A.employee_id, age, occupation
FROM
    employee_demographics AS A
RIGHT JOIN
		employee_salary AS B
	ON
       A.employee_id = B.employee_id
;

-- SELF JOIN

SELECT 
    A.employee_id AS emp_santa,
    A.first_name AS first_name_santa,
    A.last_name AS last_name_santa,
    B.employee_id AS emp_name,
    B.first_name AS first_name_name,
    B.last_name AS last_name_name
FROM
    employee_salary AS A
JOIN
		employee_salary AS B
	ON
       A.employee_id + 1 = B.employee_id
;


-- Joining multiple tables

SELECT 
    *
FROM
    employee_demographics AS A
INNER JOIN
		employee_salary AS B
	ON
       A.employee_id = B.employee_id
INNER JOIN
		parks_departments AS C
    ON
    B.dept_id = C.department_id
;