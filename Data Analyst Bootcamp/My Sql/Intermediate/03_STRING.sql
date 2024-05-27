-- STRING Function

SELECT length ('SKYfall');

SELECT 
    first_name, LENGTH(first_name) AS length
FROM
    employee_demographics
ORDER BY length;

SELECT UPPER('sky');
SELECT LOWER('SKY');

SELECT 
    first_name, UPPER(first_name) AS standard_first_name
FROM
    employee_demographics
ORDER BY standard_first_name;

SELECT TRIM('         SKY        ');
SELECT LTRIM('         SKY        ');
SELECT RTRIM('         SKY        ');

SELECT 
    first_name, 
    LEFT(first_name, 4),
    RIGHT(first_name, 3),
    substring(first_name, 3,2), #Start from 3rd position and then take 2 char
    birth_date,
    substring(birth_date,6,2) AS birth_month
FROM
    employee_demographics;
    
SELECT first_name, replace(first_name, 'a','z')
from employee_demographics;    

SELECT LOCATE('A', 'Ali Bashandy');

SELECT first_name, last_name,
concat(first_name,' ', last_name) AS full_name
FROM employee_demographics;
