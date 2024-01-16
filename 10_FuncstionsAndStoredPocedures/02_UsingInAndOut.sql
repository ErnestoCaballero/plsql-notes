--Let's assume we want the salary_increase and the department_id to be passed as parameters:
create or replace PROCEDURE increase_salaries(v_salary_increase IN NUMBER, v_department_id PLS_INTEGER) AS
    CURSOR c_emps IS SELECT * FROM employees_copy WHERE department_id=v_department_id FOR UPDATE;
    v_old_salary PLS_INTEGER;
BEGIN
    FOR r_emp IN c_emps LOOP    
        v_old_salary := r_emp.salary;
        r_emp.salary := r_emp.salary * v_salary_increase + r_emp.salary * NVL(r_emp.commission_pct,0);
        UPDATE employees_copy SET row=r_emp WHERE CURRENT OF c_emps;
        dbms_output.put_line('The salary of: ' || r_emp.employee_id || ' is increased from ' || v_old_salary || ' to ' || r_emp.salary);
    END LOOP;
    dbms_output.put_line('PROCEDURE FINISHED EXECUTING!...');
END;
/

--You can even do it for simpler stuff like the dbms_output.put_line() procedure
CREATE OR REPLACE PROCEDURE PRINT(text IN VARCHAR2) IS
BEGIN
    dbms_output.put_line(text);
END;
/

--The you can just use it in various block codes in the schema

--Now let's modify it so that
--1) The v_salary_increase also return a value which would be the average increase
--2) Add a new parameter which will OUT the count of employees affected
create or replace PROCEDURE increase_salaries
    --When declaring parameters, v_salary_increase has IN OUT mode and add v_affected_employee_count with OUT mode
    (v_salary_increase IN OUT NUMBER, v_department_id PLS_INTEGER, v_affected_employee_count OUT NUMBER) AS
    
    CURSOR c_emps IS SELECT * FROM employees_copy WHERE department_id=v_department_id FOR UPDATE;
    v_old_salary PLS_INTEGER;
    v_sal_inc NUMBER := 0;
BEGIN
    v_affected_employee_count := 0;
    FOR r_emp IN c_emps LOOP    
        v_old_salary := r_emp.salary;
        r_emp.salary := r_emp.salary * v_salary_increase + r_emp.salary * NVL(r_emp.commission_pct,0);
        UPDATE employees_copy SET row=r_emp WHERE CURRENT OF c_emps;
        dbms_output.put_line('The salary of: ' || r_emp.employee_id || ' is increased from ' || v_old_salary || ' to ' || r_emp.salary);
        v_affected_employee_count := v_affected_employee_count + 1;
        v_sal_inc := v_sal_inc + v_salary_increase + NVL(r_emp.commission_pct,0);
    END LOOP;
    v_salary_increase := v_sal_inc / v_affected_employee_count;
    dbms_output.put_line('PROCEDURE FINISHED EXECUTING!...');
END;
/

---We can use the procedure by declaring the variables in an anonymous block, for example:
DECLARE
    --This would be at the same time the IN value for the increase_salaries procedure as well as the "catch" variable for the OUT mode
    v_sal_inc NUMBER := 1.2;
    --This variable will "catch" the OUT value of the parameter v_affected_employee_count in the increase_salaries procedure
    v_aff_emp_count NUMBER;
BEGIN
    print('salary_increase_started');
    increase_salaries(v_sal_inc, 90, v_aff_emp_count);
    print('The affected empoloyee count is : ' || v_aff_emp_count);
    print('The average salary increase is: ' || v_sal_inc || ' percent!..');
    print('salary_increase finished');
END;
