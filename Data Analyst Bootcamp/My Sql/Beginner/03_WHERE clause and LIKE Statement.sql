SELECT 
    *
FROM
    employee_salary
WHERE
    first_name = 'Leslie'
    ;
    
SELECT 
    *
FROM
    employee_salary
WHERE
    salary >= 50000
;

SELECT 
    *
FROM
    employee_salary
WHERE
    salary <= 50000
    ;
    
    SELECT 
    *
FROM
    employee_demographics
WHERE
    gender != 'Female'
;

-- AND OR NOT -- Logical Operators

SELECT 
    *
FROM
    employee_demographics
WHERE
    birth_date > '1985-01-01'
        AND gender = 'male'
        OR age = 36
;


 SELECT 
    *
FROM
    employee_demographics
WHERE
    (birth_date > '1985-01-01'
        AND gender = 'male')
        OR age > 55
;

-- LIKE statement
-- % and _
SELECT 
    *
FROM
    employee_demographics
    where first_name like 'Jer%'
    ;
    
    SELECT 
    *
FROM
    employee_demographics
    where first_name like '%a%'
    ;
    
    SELECT 
    *
FROM
    employee_demographics
    where first_name like 'a__'
    ;