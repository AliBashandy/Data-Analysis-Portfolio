-- Case Statement

Select first_name, last_name, age,
CASE
	WHEN age <= 30 THEN 'Young'
    WHEN age BETWEEN 31 AND 50 THEN 'Mid Aged'
    WHEN age >= 50 THEN 'OLD'
END AS age_bracket    
FROM employee_demographics
;

/* Pay Increase and Bonus  
Salary < 50,000 increment = 5%
salary > 50,000 increment = 7%
Finanace has 10% bonus*/

select first_name, last_name, salary,
CASE
	WHEN salary < 50000 THEN salary * 1.05
	WHEN salary > 50000 THEN salary * 1.07
END AS 'new_salary',
CASE
	WHEN dept_id = 6 THEN salary * .10 
END AS 'bonus'
FROM employee_salary
;