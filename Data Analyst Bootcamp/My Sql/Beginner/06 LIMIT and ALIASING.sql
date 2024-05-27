-- LIMIT and ALIASING

SELECT *
FROM employee_demographics
ORDER BY age DESC
LIMIT 3
;


SELECT *
FROM employee_demographics
ORDER BY age DESC
LIMIT 2, 1  -- start at position 2 and selet 1 row after it
;


-- ALIASING is to give new name for aggregated colum using AS
SELECT gender, AVG(age) AS avg_age
FROM employee_demographics
GROUP BY gender
HAVING avg_age > 40;