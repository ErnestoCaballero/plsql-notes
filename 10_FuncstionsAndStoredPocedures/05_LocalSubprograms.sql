--LOCAL SUBPROGRAMS
--If we don't want to store Procedures or Functions in DB, and just once to use it once
--you can use Local Subprograms by simply specifing the FUNCTION or PROCEDURE with out the CREATE OR REPLACE statements
--Inside the DECLARE statemet of an Anonymous block or even INSIDE the creation of another FUNCTION or PROCEDURE
--which you indeed what to store

--Look at the following example
--First create a table to inserta data on. We want here the records of all employees earning over 15000
CREATE TABLE emps_high_paid AS SELECT * FROM employees WHERE 1=2;
/
--Inside the DECLARE statement of the anonymous block we define the FUNCTION and the PROCEDURE we're going to use
DECLARE
    --Since the PROCEDURE is going to use this function, we should define it first
    FUNCTION get_emp(emp_num employees.employee_id%type) RETURN employees%rowtype IS
        emp employees%rowtype;
    BEGIN
        SELECT * INTO emp FROM employees WHERE employee_id = emp_num;
        RETURN emp;
    END;

    PROCEDURE insert_high_paid_emp(emp_id employees.employee_id%type) IS 
        emp employees%rowtype;
    BEGIN
        emp := get_emp(emp_id);
        INSERT INTO emps_high_paid VALUES emp;
    END;
BEGIN
    FOR r_emp IN (SELECT * FROM employees) LOOP
        IF r_emp.salary > 15000 THEN
            insert_high_paid_emp(r_emp.employee_id);
        END IF;
    END LOOP;
END;
/
SELECT * FROM emps_high_paid;
/

--We could even declare the FUNCTION get_emp INSIDE the insert_high_paid_emp PROCEDURE
CREATE TABLE emps_high_paid AS SELECT * FROM employees WHERE 1=2;
/
DECLARE
    PROCEDURE insert_high_paid_emp(emp_id employees.employee_id%type) IS 
        --First variable of the PROCEDURE
        emp employees%rowtype;
        
        --We embed the FUNCTION inside the PROCEDURE
        FUNCTION get_emp(emp_num employees.employee_id%type) RETURN employees%rowtype IS
            emp employees%rowtype;
        BEGIN
            SELECT * INTO emp FROM employees WHERE employee_id = emp_num;
            RETURN emp;
        END;
    BEGIN
        emp := get_emp(emp_id);
        INSERT INTO emps_high_paid VALUES emp;
    END;
BEGIN
    FOR r_emp IN (SELECT * FROM employees) LOOP
        IF r_emp.salary > 15000 THEN
            insert_high_paid_emp(r_emp.employee_id);
        END IF;
    END LOOP;
END;
/
SELECT * FROM emps_high_paid;
    