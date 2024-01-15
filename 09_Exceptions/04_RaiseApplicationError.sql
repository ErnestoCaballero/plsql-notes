DECLARE
    too_high_salary EXCEPTION;
    v_salary_check PLS_INTEGER;
BEGIN
    SELECT salary INTO v_salary_check FROM employees WHERE employee_id = 100;
    IF v_salary_check > 20000 THEN
        
        RAISE_APPLICATION_ERROR(-20243, 'The salary of the selected employee is too high!');
    END IF;
    
    --we do our business here
    dbms_output.put_line('This salary is in an acceptable range.');
    
EXCEPTION
    WHEN too_high_salary THEN
        dbms_output.put_line('This salary is too high. YOu need to decrease it.');
END;
/