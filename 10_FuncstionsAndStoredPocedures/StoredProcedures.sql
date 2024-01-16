--Let's start with a basic anonymous block
DECLARE
    CURSOR c_emps IS SELECT * FROM employees_copy FOR UPDATE;
    v_salary_increase PLS_INTEGER := 1.10;
    v_old_salary PLS_INTEGER;
BEGIN
    FOR r_emp IN c_emps LOOP    
        v_old_salary := r_emp.salary;
        r_emp.salary := r_emp.salary * v_salary_increase + r_emp.salary * NVL(r_emp.commission_pct,0);
        UPDATE employees_copy SET row=r_emp WHERE CURRENT OF c_emps;
        dbms_output.put_line('The salary of: ' || r_emp.employee_id || ' is increased from ' || v_old_salary || ' to ' || r_emp.salary);
    END LOOP;
END;
/

--To turn it into a Stored Procedure, we do
--Change the starting declaration of DECLAR to CREATE PROCEDURE, then the name and finally, the AS keyword
CREATE OR REPLACE PROCEDURE increase_salaries AS
    CURSOR c_emps IS SELECT * FROM employees_copy FOR UPDATE;
    v_salary_increase PLS_INTEGER := 1.10;
    v_old_salary PLS_INTEGER;
BEGIN
    FOR r_emp IN c_emps LOOP    
        v_old_salary := r_emp.salary;
        r_emp.salary := r_emp.salary * v_salary_increase + r_emp.salary * NVL(r_emp.commission_pct,0);
        UPDATE employees_copy SET row=r_emp WHERE CURRENT OF c_emps;
        dbms_output.put_line('The salary of: ' || r_emp.employee_id || ' is increased from ' || v_old_salary || ' to ' || r_emp.salary);
    END LOOP;
END;
/
--To call the procedure there are two ways
--Number 1
EXECUTE increase_salaries;
/

--The other way is with a BEGIN END block
BEGIN
    dbms_output.put_line('Incresing the salaries!...');
    increase_salaries;
    dbms_output.put_line('ALl the salaries were successfully increased!');
END;
/