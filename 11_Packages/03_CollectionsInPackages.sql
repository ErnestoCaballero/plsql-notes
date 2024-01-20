--COLLECTIONS IN PACKAGES

--Lets use the following example

--First define the Package Specs
create or replace PACKAGE EMP_PKG as 

    TYPE emp_table_type IS TABLE OF employees%rowtype INDEX BY pls_integer;
    v_salary_increase_rate NUMBER := 1000;
    v_min_employee_salary NUMBER := 5000;
    CURSOR cur_emps IS SELECT * FROM employees;
    PROCEDURE increase_salaries;
    FUNCTION get_avg_sal(p_dept_id INT) RETURN NUMBER;
    
    /* 
        This function return all employees of the employees table in an ASsociative Array 
    */
    FUNCTION get_employees RETURN emp_table_type;
    
    /*
        This procedure increases the salary of the employees who has a lower salary than
        the company standard
    */
    PROCEDURE increase_low_salaries;
  
END EMP_PKG;
/

--There are many FUNCTIONS, PROCEDURES and CURSORS, VARIABLES and TYPES
--Now we have to implement them. 
--Notice that get_employees and get_employees_tobe_incremented RETURN the Associative Array declared at the beginning

--Here is the Body of the Package (Implementation)
create or replace PACKAGE BODY emp_pkg AS

    v_sal_inc INT := 500;
    v_sal_inc2 INT := 500;
    
    FUNCTION get_sal(e_id employees.employee_id%type) RETURN employees.salary%type;

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
    
    FUNCTION get_sal(e_id employees.employee_id%type) RETURN employees.salary%type IS
        v_sal employees.salary%type;
    BEGIN
        SELECT salary INTO v_sal FROM employees WHERE employee_id=e_id;
        RETURN v_sal;
    END;
    
    /* 
        This function return all employees of the employees table in an ASsociative Array 
    */
    FUNCTION get_employees RETURN emp_table_type IS
        v_emps emp_table_type;
    BEGIN
        FOR cur_emps IN (SELECT * FROM employees_copy) LOOP
            v_emps(cur_emps.employee_id) := cur_emps;
        END LOOP;
        RETURN v_emps;
    END;
    
    /*
        This PRIVATE function returns the employees whose salaries are under the minimum
        salary of the company standard
    */
    FUNCTION get_employees_tobe_incremented RETURN emp_table_type IS
        v_emps emp_table_type;
        i employees.employee_id%type;
    BEGIN
        v_emps := get_employees;
        i := v_emps.first;
        
        WHILE i IS NOT NULL LOOP
            IF v_emps(i).salary > v_min_employee_salary THEN
                v_emps.delete(i);
            END IF;
            i := v_emps.next(i);
        END LOOP;
        RETURN v_emps;
    END;
    
    /*
        This PRIVATE function returns the employee by arranging the salary based on the
        company standard
    */
    FUNCTION arrange_for_min_salary(v_emp IN OUT employees%rowtype) RETURN employees%rowtype IS
    BEGIN
        v_emp.salary := v_emp.salary + v_salary_increase_rate;
        IF v_emp.salary < v_min_employee_salary THEN
            v_emp.salary := v_min_employee_salary;
        END IF;
        RETURN v_emp;
    END;
    
    /*
        This procedure increases the salary of the employees who has a lower salary than
        the company standard
    */
    PROCEDURE increase_low_salaries AS
        v_emps emp_table_type;
        v_emp employees%rowtype;
        i employees.employee_id%type;
    BEGIN
        v_emps := get_employees_tobe_incremented;
        i := v_emps.first;
        WHILE i IS NOT NULL LOOP
            v_emp := arrange_for_min_salary(v_emps(i));
            UPDATE employees_copy SET row = v_emp
            WHERE employee_id = i;
            i := v_emps.next(i);
        END LOOP;
    END;
    
BEGIN
    v_salary_increase_rate := 500;
    INSERT INTO logs VALUES ('EMP_PKG', 'Package initialized!', sysdate);

END emp_pkg;
/