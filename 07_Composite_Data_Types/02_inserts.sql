--Create an empty table to insert data
DROP TABLE retired_employees;
CREATE TABLE retired_employees
AS SELECT * FROM employees WHERE 1=2;  
SELECT * FROM retired_employees;
/

--insert values from a RECORD and modify some values before inserting
DECLARE
    r_emp employees%rowtype;
BEGIN
    SELECT * 
    INTO r_emp
    FROM employees
    WHERE employee_id = 104;
    
    r_emp.salary := 0;
    r_emp.commission_pct := 0;
    
    INSERT INTO retired_employees VALUES r_emp;
END;
/

--Check result
SELECT * FROM retired_employees;