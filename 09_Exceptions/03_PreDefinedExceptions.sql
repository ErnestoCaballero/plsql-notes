--PreDefined Exceptions & Raising Exceptions
--Usually are used when you need to handle some exceptions about your business
--For instance a too high salary:
DECLARE
    too_high_salary EXCEPTION;
    v_salary_check PLS_INTEGER;
BEGIN
    SELECT salary INTO v_salary_check FROM employees WHERE employee_id = 100;
    IF v_salary_check > 20000 THEN
        RAISE too_high_salary;
    END IF;
    
    --we do our business here
    dbms_output.put_line('This salary is in an acceptable range.');
EXCEPTION
    WHEN too_high_salary THEN
        dbms_output.put_line('THIs salary is too high. YOu need to decrease it.');
END;
/