--The following code checks if a number is prime. 
--If the number is divisible of any number in between 2 and itself -1 then it's not a prime number
--The GOTO statement will jump to the end_point label in that case
--Note: The <<end_point>> label should have code underneath, or else an error may occur
DECLARE
    v_searched_number NUMBER := 32453;
    v_is_prime BOOLEAN := TRUE;
BEGIN
    FOR x IN 2..v_searched_number-1 LOOP
        IF v_searched_number MOD x = 0 THEN
            dbms_output.put_line(v_searched_number || ' is not a prime number..');
            v_is_prime := FALSE;
            GOTO  end_point; --The GOTO statement will jump to the end_point label in that case
        END IF;
    END LOOP;
    
    IF v_is_prime THEN
        dbms_output.put_line(v_searched_number || ' is a prime number.');
    END IF;
    
    <<end_point>>
    dbms_output.put_line('Check complete..');
END;
/

--You can kind of create a loop using GOTO statement
--In this case, you label <<start_point>>, <<prime_point>> and <<end_point>>
--If the number is divisible by any number in between two and itself will GOTO <<end_point>>
--If the x reached the v_searched_number, it means there are no divisible numbers in between 2 and itself-1. So GOTO <<prime_point>>
DECLARE
    v_searched_number NUMBER := 32453;
    v_is_prime BOOLEAN := TRUE;
    x NUMBER := 2;
BEGIN
    <<start_point>>
    IF v_searched_number MOD x = 0 THEN
        dbms_output.put_line(v_searched_number || ' is not a prime number..');
        v_is_prime := FALSE;
        GOTO  end_point; --If the number is divisible by any number in between two and itself will GOTO <<end_point>>
    END IF;
    
    x := x + 1;
    
    IF x = v_searched_number THEN
        GOTO prime_point; --If the x reached the v_searched_number, it means there are no divisible numbers in between 2 and itself-1. So GOTO <<prime_point>>
    END IF;
    
    GOTO start_point;
    
    <<prime_point>>
    IF v_is_prime THEN
        dbms_output.put_line(v_searched_number || ' is a prime number.');
    END IF;
        
    <<end_point>>
    dbms_output.put_line('Check complete..');
END;