-- Group By

SELECT 
    gender, AVG(age), MAX(age), MIN(age), COUNT(age)
FROM
    employee_demographics
GROUP BY gender
;

-- Order By ASC or DESC
SELECT 
    *
FROM
    employee_demographics
ORDER BY  employee_id
;

