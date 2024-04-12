--Initializing a Package

--What it means is that you can perform some operations before de Package is loaded into the Systems Global Area (SGA)
--For instance, you may want to initialize some variables values first
--Or insert some log recodrs into a log table

--Let's create a log table
CREATE TABLE logs (log_source VARCHAR2(100), log_message VARCHAR2(1000), Log_Sate date);
/
--Now change our EMP_PKG Package by adding a BEGIN clause
create or replace PACKAGE BODY emp_pkg AS

    v_sal_inc INT := 500;
    v_sal_inc2 INT := 500;

    PROCEDURE increase_salaries AS
    BEGIN
        FOR r1 IN cur_emps LOOP
            UPDATE employees_copy SET salary = salary +  v_salary_increase_rate;
        END LOOP;
    END increase_salaries;

    FUNCTION get_avg_sal(p_dept_id INT) RETURN NUMBER AS
        v_avg_sal NUMBER := 0;
    BEGIN
        SELECT AVG(salary) INTO v_avg_sal FROM employees_copy
        WHERE department_id = p_dept_id;
        
        RETURN v_avg_sal;
    END get_avg_sal;
--Here we ADD the BEGIN clause
BEGIN
    --We re-set the v_salary_rate variable to 5000
    v_salary_increase_rate := 5000;
    --And also insert a log into the created log table
    INSERT INTO logs VALUES ('EMP_PKG', 'Package initialized!', sysdate);
END emp_pkg;
/

--We can now verify the changes

EXEC dbms_output.put_line(emp_pkg.get_avg_sal(80));
/

SELECT * FROM logs;
/

EXEC dbms_output.put_line(emp_pkg.v_salary_increase_rate);
