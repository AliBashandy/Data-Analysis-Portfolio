-- Temporary Tables

-- First approach

CREATE temporary table tmp_tbl
(first_name varchar(50),
last_name varchar(50),
favorite_movie varchar(100)
);
INSERT INTO tmp_tbl
VALUES('Ali', 'Bashandy', 'The God Father') 
;
SELECT *
FROM tmp_tbl;

CREATE TEMPORARY TABLE salary_over_50k
(SELECT first_name, last_name, salary
	FROM employee_salary
    WHERE salary >= 50000
);
SELECT *
FROM salary_over_50k
;
