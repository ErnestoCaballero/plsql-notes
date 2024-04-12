--In the next code, we explicitly generate the ORA-01403: no data found exception by quering an un-existing employee_id
declare
  v_name varchar2(6);
begin
  select first_name into v_name from employees where employee_id = 50;
  dbms_output.put_line('Hello');
end;
/

--To handle that exception, we need to add the EXCEPTION clause
DECLARE
  v_name varchar2(6);
BEGIN
  SELECT first_name INTO v_name FROM employees WHERE employee_id = 50;
  dbms_output.put_line('Hello');
  
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('There is no employee with the SELECTED id');
END;
/

--Let's see the case where we have multiple errors and how to handle them
--The 50 employee_id will trigger the WHEN no_data_found exception
--The 100 employee_id will trigger the WHEN too_many_rows exception
--The 103 employee_id will trigger the WHEN OTHERS exception
DECLARE
  v_name varchar2(6);
  v_department_id VARCHAR2(100);
BEGIN
  SELECT first_name INTO v_name FROM employees WHERE employee_id = 103;
  SELECT department_id INTO v_department_id FROM employees WHERE first_name = v_name;
  dbms_output.put_line('Hello ' || v_name || '. Your department id is: ' || v_department_id);
  
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('There is no employee with the SELECTED id');
    WHEN too_many_rows THEN
        dbms_output.put_line('There are more than one employees with the name ' || v_name);
        dbms_output.put_line('Try with a different employee');
    WHEN OTHERS THEN
        dbms_output.put_line('An unexpected ERROR happened.');
        dbms_output.put_line(sqlcode || ' --> ' || sqlerrm); --sqlcode and sqlerrm keywords will show the ORA error message
END;
/

--Every BEGIN block may have it's own EXCEPTION section
--Check the following example
DECLARE
  v_name varchar2(6);
  v_department_id VARCHAR2(100);
BEGIN
    SELECT first_name INTO v_name FROM employees WHERE employee_id = 100;
  
    --Here is a nested block with it's own EXCEPTION section
    BEGIN
        SELECT department_id INTO v_department_id FROM employees WHERE first_name = v_name;
    EXCEPTION
        WHEN too_many_rows THEN --If the SELECT query brings more than one value, assign v_department_id a hardcoded value
        v_department_id := 'Error in department name';
    END;
    
    dbms_output.put_line('Hello ' || v_name || '. Your department id is: ' || v_department_id);

EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('There is no employee with the SELECTED id');
    WHEN too_many_rows THEN
        dbms_output.put_line('There are more than one employees with the name ' || v_name);
        dbms_output.put_line('Try with a different employee');
    WHEN OTHERS THEN
        dbms_output.put_line('An unexpected ERROR happened.');
        dbms_output.put_line(sqlcode || ' --> ' || sqlerrm);
END;
/