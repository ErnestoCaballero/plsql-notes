--VARRAYS basic example
--It's important to remember that when the VARRAY is created as a TYPE and
--the upper bound size is specified, the varray it's not initialize. 
--To initialize you should either insert values explicitly or 
--use the <<varray_name>>.extend property
DECLARE
    --VARRAYS is a TYPE which is set as VARRAY alike a RECORD and specifing the size
    TYPE e_list IS VARRAY(5) OF VARCHAR2(50);
    --set employees variable as the VARRAY
    employees e_list;
BEGIN
    employees := e_list('Alex','Bruce','John','Bob','Richard'); --Initialize the VARRAY
    
    FOR i IN 1..employees.COUNT() LOOP  --check the use of the employees.COUNT() method to count up how many values the VARRAY actually has
        dbms_output.put_line(employees(i));
    END LOOP;
END;
/

--Show the employees.EXITST() function to check if the element exists for an index
--And the LIMIT() method. Which will show the specified size of the VARRAY when created
DECLARE
    TYPE e_list IS VARRAY(5) OF VARCHAR2(50);
    employees e_list;
BEGIN
    employees := e_list('Alex','Bruce','John','Bob'); --Initialize the VARRAY
    
    FOR i IN 1..5 LOOP
        IF employees.exists(i) THEN
            dbms_output.put_line(employees(i));
        END IF;
    END LOOP;
    dbms_output.put_line(employees.limit()); --Look at the use of the LIMIT() method. Which will show the specified size of the VARRAY when created
END;
/

--Another way of initilizing the VARRAY
--is in the DECLARE
DECLARE
    TYPE e_list IS VARRAY(5) OF VARCHAR2(50);
    employees e_list := e_list('Alex','Bruce','John','Bob');
BEGIN
    dbms_output.put_line(employees.limit());
END;
/

--Here is an example of creating a TYPE of VARRAY with upper bound 15
--which is not yet initialize, it has just specified the maximum amount of elements the array can hold
--then on the FOR LOOP it is EXTENDING from zero elements initialized
--So, to clarify, the VARRAY has a declared maximum size of 15, but its initial size is 0, and it can 
--dynamically grow during runtime using the EXTEND method
DECLARE
    TYPE e_list IS VARRAY(15) OF VARCHAR2(50);
    employees e_list := e_list();
    idx NUMBER := 1;
    
BEGIN
    FOR i IN 100..110 LOOP
        employees.extend;
        SELECT first_name INTO employees(idx) FROM employees WHERE employee_id = i;
        idx := idx + 1;
    END LOOP;
    
    FOR x IN 1..employees.COUNT() LOOP
        dbms_output.put_line(x || ' ' || employees(x));
    END LOOP;
    
END;
/

--You can create the types directly on the DB. 
--That way you can re-use then in other PL/SQL blocks
--In this examples TYPE e_list is created and then PL/SQL block use it
DROP TYPE e_list;
CREATE OR REPLACE TYPE e_list IS VARRAY(20) OF VARCHAR2(100);
/

DECLARE
    employees e_list := e_list();
    idx NUMBER := 1;
    
BEGIN
    FOR i IN 100..110 LOOP
        employees.extend;
        SELECT first_name INTO employees(idx) FROM employees WHERE employee_id = i;
        idx := idx + 1;
    END LOOP;
    
    FOR x IN 1..employees.COUNT() LOOP
        dbms_output.put_line(x || ' ' || employees(x));
    END LOOP;
    
END;