-- HAVING vs WHERE

/*
SELECT gender, AVG(age)
FROM employee_demographics
WHERE AVG(age) > 40
GROUP BY gender
*/
-- the filter by where will not work in this case 

SELECT gender, AVG(age)
FROM employee_demographics
GROUP BY gender
HAVING AVG(age) > 40
;

SELECT occupation, AVG(salary)
FROM employee_salary
WHERE occupation LIKE '%man%'
GROUP BY occupation
HAVING AVG(salary) > 75000
;