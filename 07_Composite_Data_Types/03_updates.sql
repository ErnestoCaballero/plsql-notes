--Create an empty table to insert data
DROP TABLE retired_employees;
CREATE TABLE retired_employees
AS SELECT * FROM employees WHERE 1=2;  
SELECT * FROM retired_employees;
/

--When updating a row, make a chenge on the desired column in the RECORD r_emp
--Then use the ROW keyword to update all related columns of the record
DECLARE
    r_emp employees%rowtype;
BEGIN
    SELECT * 
    INTO r_emp
    FROM employees
    WHERE employee_id = 104;
    
    r_emp.salary := 10;
    r_emp.commission_pct := 0;
    
    --INSERT INTO retired_employees VALUES r_emp;
    UPDATE retired_employees SET ROW = r_emp WHERE employee_id = 104; --Here you use the ROW keyword to match all columns of the table to the record
END;
/
SELECT * FROM retired_employees;