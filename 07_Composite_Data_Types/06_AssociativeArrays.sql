--Basic Associative array example
--Notice the declaration of the TYPE now includes INDEX BY which can hold PLS_INTEGER, BYNARY_INTEGER, VARCHAR2
--Also, no need of .extend method since it increases dynamically
DECLARE
    TYPE e_list IS TABLE OF employees.first_name%type INDEX BY PLS_INTEGER;
    emps e_list;
BEGIN
    FOR x IN 100..110 LOOP
        SELECT first_name INTO emps(x) FROM employees WHERE employee_id=x;
    END LOOP;
    
    FOR i IN emps.first..emps.last LOOP
        dbms_output.put_line(emps(i));
    END LOOP;
END;
/

--How to iterate over keys that are non-sequential?
--By using WHILE LOOPS mostly
--Example inserting manually two variables:
DECLARE
    TYPE e_list IS TABLE OF employees.first_name%type INDEX BY PLS_INTEGER;
    emps e_list;
    idx PLS_INTEGER;
BEGIN
    emps(100) := 'Bob';
    emps(120) := 'Sue';
    idx := emps.first;
    
    while idx IS NOT NULL LOOP
        dbms_output.put_line(emps(idx));
        idx := emps.next(idx);  --IMPORTANT: here the .next() method return the next index value from current position
    END LOOP;
END;
/

--Another examples using a SELECT
DECLARE
    TYPE e_list IS TABLE OF employees.first_name%type INDEX BY PLS_INTEGER;
    emps e_list;
    idx PLS_INTEGER;
BEGIN
    FOR x IN 100..110 LOOP
        SELECT first_name INTO emps(x) FROM employees WHERE employee_id = x;
    END LOOP;
    
    idx := emps.first;
    
    while idx IS NOT NULL LOOP
        dbms_output.put_line(emps(idx));
        idx := emps.next(idx);
    END LOOP;
END;
/

--*******************************************************************
--IMPORTANT
--*******************************************************************
--Here we create an Associative Array (a kind of HashMap) 
--That will hold the first_name as VALUE and email KEY
DECLARE
    TYPE e_list IS TABLE OF employees.first_name%type INDEX BY VARCHAR2(50);
    emps e_list;
    
    idx employees.email%type;
    
    v_email employees.email%type;
    v_first_name employees.first_name%type;
BEGIN
    FOR x IN 100..110 LOOP
        SELECT first_name, email INTO v_first_name, v_email FROM employees WHERE employee_id = x;
        emps(v_email) := v_first_name; --populate de associative array in each iteration
    END LOOP;
    
    idx := emps.first; --Set the first key value
    
    while idx IS NOT NULL LOOP
        dbms_output.put_line('The email of ' || emps(idx) || ' is: ' || idx || '@company.com');
        idx := emps.next(idx);  --Go to next key value
    END LOOP;
END;
/


--IMPORTANT
--Here we're using RECORDS into the Associative Array to fetch all columns of a record in the SELECT statement
DECLARE
    TYPE e_list IS TABLE OF employees%rowtype INDEX BY employees.email%type;
    emps e_list;
    
    idx employees.email%type;
BEGIN
    FOR x IN 100..110 LOOP
        SELECT * INTO emps(x) FROM employees WHERE employee_id = x; --Here with the INTO we are inserting into the associative array each record from db
    END LOOP;
    
    idx := emps.first;
    
    while idx IS NOT NULL LOOP
        dbms_output.put_line('The email of ' || emps(idx).first_name || ' ' || emps(idx).last_name || ' is: ' || emps(idx).email || '@company.com with index: ' || idx);
        idx := emps.next(idx);
    END LOOP;
END;
/

--You can even create your own TYPE for your specific needs
--Instead of fetching the whole columns of a table, just create a TYPE with the required columns
--as shown below
DECLARE
    TYPE e_type IS RECORD(first_name employees.first_name%type,
                            last_name employees.last_name%type,
                            email employees.email%type);  --Declare the TYPE of only three columns
                            
    TYPE e_list IS TABLE OF e_type INDEX BY employees.email%type; --Declare the e_list Associative Array as of newly created TYPE e_type
    
    emps e_list; --Declaro la variable tal cual de tipo e_list
    
    idx employees.email%type;
    
    v_email employees.email%type;
    v_first_name employees.first_name%type;
BEGIN
    FOR x IN 100..110 LOOP
        SELECT first_name, last_name, email INTO emps(x) FROM employees WHERE employee_id = x; --Select just those three columns to assign INTO emps
    END LOOP;

    emps.delete(100); --To delete an entry from an Associative Array use the .delete() method with the specified index
    --emps.delete(100,104); --You can also delete in an specified range of indexes
    
    idx := emps.first;
    
    while idx IS NOT NULL LOOP
        dbms_output.put_line('The email of ' || emps(idx).first_name || ' ' || emps(idx).last_name || ' is: ' || emps(idx).email || '@company.com with index: ' || idx);
        idx := emps.next(idx);
    END LOOP;

    --Now printing from last to first elements by using .prior() method
    dbms_output.put_line('');
    dbms_output.put_line('Now printing from last to first elements by using .prior() method');
    dbms_output.put_line('');
    
    idx := emps.last;
    
    while idx IS NOT NULL LOOP
        dbms_output.put_line('The email of ' || emps(idx).first_name || ' ' || emps(idx).last_name || ' is: ' || emps(idx).email || '@company.com with index: ' || idx);
        idx := emps.prior(idx);
    END LOOP;
END;
/