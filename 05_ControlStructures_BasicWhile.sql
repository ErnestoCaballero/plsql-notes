DECLARE
    v_counter NUMBER(2) := 1;
BEGIN
    WHILE v_counter <= 10 LOOP
        dbms_output.put_line('My counter is: ' || v_counter);
        v_counter := v_counter+1;
        
        --EXIT WHEN v_counter > 7; --It works as a break in java when a condition is meet
        
        --This would also stop the execution:
        IF v_counter > 8 THEN
            EXIT;
        END IF;

    END LOOP;
END;


--How to create an infinite loop
DECLARE
    v_counter NUMBER := 1;
BEGIN
    WHILE TRUE LOOP
        dbms_output.put_line('My while counter is: ' || v_counter);
        v_counter := v_counter+1;
        
        IF v_counter = 10 THEN
            EXIT;
        END IF;
        
    END LOOP;
END;
       