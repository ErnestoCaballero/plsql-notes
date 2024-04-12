--First example. Skip multiples of three to print in the inner loop
DECLARE
    v_inner NUMBER := 1;
BEGIN
    FOR v_outer IN 1..10 LOOP
        dbms_output.put_line('My outer value is: ' || v_outer);
        v_inner := 1;
        
        WHILE v_inner * v_outer < 15 LOOP
            v_inner := v_inner + 1;
            CONTINUE WHEN MOD(v_inner * v_outer, 3) = 0;
            dbms_output.put_line('  My inner value is: ' || v_inner);
        END LOOP;
        
    END LOOP;
END;
/

--Another example by using labels
--SKIP the inner loop iteration when v_inner = 10 and go directly to next outer loop
DECLARE
    v_inner NUMBER := 1;
BEGIN
    <<outer_loop>>
    FOR v_outer IN 1..10 LOOP
        dbms_output.put_line('My outer value is: ' || v_outer);
        v_inner := 1;
        
        <<inner_loop>>
        WHILE v_inner * v_outer < 15 LOOP
            v_inner := v_inner + 1;
            CONTINUE outer_loop WHEN v_inner = 10; --SKIP the inner loop iteration when v_inner = 10 and go directly to next outer loop
            dbms_output.put_line('  My inner value is: ' || v_inner);
        END LOOP inner_loop;
        
    END LOOP outer_loop;
END;