--BULK COLLECT INTO clause 

--It is used when the DYNAMIC SQL fetches more than ONE row
--You'll have to collect the result in a COMPOSITE Data such as a Nested Table

--E.g.
DECLARE
    --Create a Nested Table to save the result of DYNAMIC SQL query
    TYPE t_name IS TABLE OF VARCHAR2(20);
    names t_name;
BEGIN
    --Here we understand that the query will fetch multiple values. We need to BULK them into the names nested table
    EXECUTE IMMEDIATE 'SELECT DISTINCT first_name FROM employees' BULK COLLECT INTO names;
    FOR i IN 1..names.COUNT LOOP
        dbms_output.put_line(names(i));
    END LOOP;
END;
/

--Now for a different example, what if we want to perform a BULK UPDATE
DECLARE
    TYPE t_name IS TABLE OF VARCHAR2(20);
    names t_name;
BEGIN
    EXECUTE IMMEDIATE 'UPDATE employees_copy SET salary = salary + 1000 WHERE department_id=30 RETURNING first_name INTO :a' 
        RETURNING BULK COLLECT INTO names;
    FOR i IN 1..names.COUNT LOOP
        dbms_output.put_line(names(i));
    END LOOP;
END;
/
--Here what's to notice is the RETURNING first_name INTO :a change in the DYNAMIC SQL
--and the RETURNING BULC COLELCT INTO names
