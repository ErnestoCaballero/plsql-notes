--First basic example
--Notice the INTO statement which embed the values from sql into plsql variables
DECLARE
    v_name VARCHAR2(50);
    v_salary employees.salary%type;
BEGIN
    SELECT last_name, salary 
    INTO v_name, v_salary
    FROM employees 
    WHERE employee_id=100;
    
    dbms_output.put_line('The salary of ' || v_name || ' is: ' || v_salary);
END;
/

--Same code with minor change. The first variable v_name is the concatenation of first_name and last_name
DECLARE
    v_name VARCHAR2(50);
    v_salary employees.salary%type;
BEGIN
    SELECT first_name || ' ' || last_name, salary 
    INTO v_name, v_salary
    FROM employees 
    WHERE employee_id=100;
    
    dbms_output.put_line('The salary of ' || v_name || ' is: ' || v_salary);
END;