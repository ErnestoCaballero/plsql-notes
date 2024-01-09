--Example of a nested loop (a Basic LOOP inside a FOR)
DECLARE
    v_inner NUMBER := 1;
BEGIN
    FOR v_outer IN 1..5 LOOP
        dbms_output.put_line('My outer values is: ' || v_outer);
        v_inner := 1;
        
        LOOP
            v_inner := v_inner + 1;
            dbms_output.put_line('  My inner value is: ' || v_inner);
            
            EXIT WHEN v_inner * v_outer >= 15;
        END LOOP;
    END LOOP;
END;
/

--Now use the same example but using labels. 
--Those are put before the LOOP statement (WHILE, LOOP, FOR) in between <<>>
--At the end of the loop write which loop is being ended
DECLARE
    v_inner NUMBER := 1;
BEGIN
    <<outer_loop>> --First label
    FOR v_outer IN 1..5 LOOP
        dbms_output.put_line('My outer values is: ' || v_outer);
        v_inner := 1;
        
        <<inner_loop>> --Second label
        LOOP
            v_inner := v_inner + 1;
            dbms_output.put_line('  My inner value is: ' || v_inner);
            
            EXIT outer_loop WHEN v_inner * v_outer >= 16; --IMPORTANT: See how the outer loop is ended from the INNER loop
            EXIT WHEN v_inner * v_outer >= 15;
        END LOOP inner_loop; --write which loop is endind
        
    END LOOP outer_loop; --write which loop is endind
END;