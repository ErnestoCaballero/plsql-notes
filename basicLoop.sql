DECLARE
    v_counter NUMBER(2) := 1;
BEGIN
     LOOP
        dbms_output.put_line('My counter is: ' || v_counter);
        v_counter := v_counter+1;
        
        EXIT WHEN v_counter = 10;
    END LOOP;
END;