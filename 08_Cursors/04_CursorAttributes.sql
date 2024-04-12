--CURSOR ATTRIBUTES
--There are four:
--%FOUND: Returns TRUE if the most recent FETCH returned a row
--%NOTFOUND: Returns TRUE if the most recent FETCH DID NOT returned a row
--%ISOPEN: Returns TRUE if CURSOR is open
--%ROWCOUNT: Returns the number of FETCHED rows

--Here is a basic example
DECLARE
    CURSOR c_emps IS SELECT * FROM employees;
    v_emps c_emps%ROWTYPE;
BEGIN
    IF NOT c_emps%ISOPEN THEN --Check if CURSOR if open. If not, open it
        OPEN c_emps;
        dbms_output.put_line('Hello. c_emps CURSOS was OPENED');
    END IF;
    
    CLOSE c_emps; 
    
    OPEN c_emps;
        LOOP
            FETCH c_emps INTO v_emps;
            EXIT WHEN c_emps%NOTFOUND OR c_emps%rowcount > 100;  --Exit if there are no more rows to fetch or the number of rows fetched is greated than 100
            dbms_output.put_line(c_emps%rowcount || ' ' || v_emps.first_name || ' ' || v_emps.last_name);
        END LOOP;
    CLOSE c_emps;
    
END;
/

--Here's the same example but printing the number of fetched rows in the furst open CURSOR
DECLARE
    CURSOR c_emps IS SELECT * FROM employees WHERE department_id=50;
    v_emps c_emps%ROWTYPE;
BEGIN
    IF NOT c_emps%ISOPEN THEN
        OPEN c_emps;
        dbms_output.put_line('Hello. c_emps CURSOS was OPENED');
    END IF;
    
    dbms_output.put_line(c_emps%rowcount);
    FETCH c_emps INTO v_emps;
    dbms_output.put_line(c_emps%rowcount);
    dbms_output.put_line(c_emps%rowcount);
    FETCH c_emps INTO v_emps;
    dbms_output.put_line(c_emps%rowcount);
    CLOSE c_emps;
    
    OPEN c_emps;
        LOOP
            FETCH c_emps INTO v_emps;
            EXIT WHEN c_emps%NOTFOUND OR c_emps%rowcount > 5;
            dbms_output.put_line(c_emps%rowcount || ' ' || v_emps.first_name || ' ' || v_emps.last_name);
        END LOOP;
    CLOSE c_emps;
    
END;