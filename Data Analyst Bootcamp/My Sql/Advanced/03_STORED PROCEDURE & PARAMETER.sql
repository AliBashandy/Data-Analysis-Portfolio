-- Stored Procedure

CREATE procedure procedure1()
SELECT *
FROM employee_demographics;

DELIMITER $$
CREATE PROCEDURE procedure2()
BEGIN
	SELECT *
    FROM employee_salary
    WHERE salary > 50000;
    SELECT *
    FROM employee_salary
    WHERE salary > 10000;
END $$
DELIMITER ;

CALL procedure2();

DELIMITER $$

-- creating parameter
CREATE PROCEDURE procedure3(p_employee_id INT)
BEGIN
	SELECT *
    FROM employee_salary
    WHERE employee_id = p_employee_id;
END $$
DELIMITER ;

CALL procedure3(1);
