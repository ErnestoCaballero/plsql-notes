--Basic Nested Table
DECLARE
    TYPE e_list IS TABLE OF VARCHAR2(50);
    emps e_list;
BEGIN
    emps := e_list('Alex', 'Bruce','John');
    
    FOR i IN 1..emps.COUNT() LOOP
        dbms_output.put_line(emps(i));
    END LOOP;
END;
/

--But what if I want to add a new element to this unbounded data structure?
--I use the <<n_table_name>>.extend as in varrays
DECLARE
    TYPE e_list IS TABLE OF VARCHAR2(50);
    emps e_list;
BEGIN
    emps := e_list('Alex', 'Bruce','John');
    emps.extend;     --Here you can see the change from previous code
    emps(4) := 'Bob';
    
    FOR i IN 1..emps.COUNT() LOOP
        dbms_output.put_line(emps(i));
    END LOOP;
END;
/

--Another example
DECLARE
    TYPE e_list IS TABLE OF employees.first_name%type;
    emps e_list := e_list();  --Initialize the nested table
    idx PLS_INTEGER := 1;
    
BEGIN
    --Populate the nested tabled using the .extend property from info in employees table
    FOR i IN 100..110 LOOP
        emps.extend;
        SELECT first_name INTO emps(idx) FROM employees WHERE employee_id = i;
        idx := idx + 1;
    END LOOP;
    
    FOR i IN 1..emps.COUNT() LOOP
        dbms_output.put_line(emps(i));
    END LOOP;
END;
/

--In this last example we DELETE an element of the nested table
--Then we use the exists() method to check if the element exist
DECLARE
    TYPE e_list IS TABLE OF employees.first_name%type;
    emps e_list := e_list();
    idx PLS_INTEGER := 1;
    
BEGIN

    FOR i IN 100..110 LOOP
        emps.extend;
        SELECT first_name INTO emps(idx) FROM employees WHERE employee_id = i;
        idx := idx + 1;
    END LOOP;
    
    emps.delete(3); --delete third element of the nested table
    
    FOR i IN 1..emps.COUNT() LOOP
        IF emps.exists(i) THEN  --checks id the ith element exist so it can print it
            dbms_output.put_line(emps(i));
        END IF;
    END LOOP;
END;
/

