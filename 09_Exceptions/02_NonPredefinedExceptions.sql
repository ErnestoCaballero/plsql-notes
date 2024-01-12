--Here you can see how to define a variable as an exception

DECLARE
    --Here you can see how to define a variable as an exception
    cannot_update_to_null EXCEPTION;
    
    --Use the PRAGMA clause to talk to the compuler when error prompts
    PRAGMA EXCEPTION_INIT(cannot_update_to_null, -01407);

BEGIN
    UPDATE employees_copy SET email = NULL WHERE employee_id = 100;
    
EXCEPTION
    --Use defined exception
    WHEN cannot_update_to_null THEN
        dbms_output.put_line('You cannot update with a null value!');
END;
/