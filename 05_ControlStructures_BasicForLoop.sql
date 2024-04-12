BEGIN
    FOR i IN 1..3 LOOP
        dbms_output.put_line('My counter is: ' || i);
    END LOOP;
END;

--You can use the REVERSE optional keyword to start from upper bound
BEGIN
    FOR i IN REVERSE 20..32 LOOP
        dbms_output.put_line('My counter is: ' || i);
    END LOOP;
END;