--Assume I have the next Function 
create or replace FUNCTION get_emp(emp_num employees.employee_id%type) RETURN employees%rowtype IS
    emp employees%rowtype;
BEGIN
    SELECT * INTO emp FROM employees WHERE employee_id = emp_num;
    RETURN emp;

EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('There is no employee with the ID of : ' || emp_num);
        RETURN NULL;
END;
/
--If someone inputs a employee_id that has no records in the table, a data_not_found exception will be thrown 
--unless I handle the exception as shown. 

--Another possibility is to RAISE the exception explicitly
create or replace FUNCTION get_emp(emp_num employees.employee_id%type) RETURN employees%rowtype IS
    emp employees%rowtype;
BEGIN
    SELECT * INTO emp FROM employees WHERE employee_id = emp_num;
    RETURN emp;

EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('There is no employee with the ID of : ' || emp_num);
        RAISE no_data_found;
END;
/
--That will show the message of the missing ID, but then RAISE the data_not_found exception itself

--Finally. Your subprograms (Functions and Procedures) should handle all possible EXCEPTION,
--So you should make sure to at least use the WHEN OTHERS THEN clause
create or replace FUNCTION get_emp(emp_num employees.employee_id%type) RETURN employees%rowtype IS
    emp employees%rowtype;
BEGIN
    SELECT * INTO emp FROM employees WHERE employee_id = emp_num;
    RETURN emp;

EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('There is no employee with the ID of : ' || emp_num);
        RAISE no_data_found;
    WHEN OTHERS THEN
        dbms_output.put_line('Something unexpected happened!');
END;
/