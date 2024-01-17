--Same as in Java, you can Overload your subprograms.
--Look at the next example

DECLARE
    PROCEDURE insert_high_paid_emp(p_emp employees%rowtype) IS 
        emp employees%rowtype;
        
        --First Function get_emp with one parameter employee_id
        FUNCTION get_emp(emp_num employees.employee_id%type) RETURN employees%rowtype IS
        BEGIN
            SELECT * INTO emp FROM employees WHERE employee_id = emp_num;
            RETURN emp;
        END;

        --Second Function get_emp with one parameter email
        FUNCTION get_emp(emp_email employees.email%type) RETURN employees%rowtype IS
        BEGIN
            SELECT * INTO emp FROM employees WHERE email = emp_email;
            RETURN emp;
        END;
        
        --Third Function get_emp with two parameters first_name and last_name
        FUNCTION get_emp(emp_first_name employees.first_name%type, emp_last_name employees.last_name%type) RETURN employees%rowtype IS
        BEGIN
            SELECT * INTO emp FROM employees WHERE first_name = emp_first_name AND last_name = emp_last_name;
            RETURN emp;
        END;
    BEGIN
        --Use of first get_emp subprogram with employee_id parameter
        emp := get_emp(p_emp.employee_id);
        INSERT INTO emps_high_paid VALUES emp;

        --Use of second get_emp subprogram with email parameter
        emp := get_emp(p_emp.email);
        INSERT INTO emps_high_paid VALUES emp;

        --Use of third get_emp subprogram with first_name and last_name
        emp := get_emp(p_emp.first_name, p_emp.last_name);
        INSERT INTO emps_high_paid VALUES emp;
    END;
BEGIN
    FOR r_emp IN (SELECT * FROM employees) LOOP
        IF r_emp.salary > 15000 THEN
            insert_high_paid_emp(r_emp);
        END IF;
    END LOOP;
END;
/