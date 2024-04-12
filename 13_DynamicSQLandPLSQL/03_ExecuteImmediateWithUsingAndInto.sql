--EXECUTE IMMEDIATE command with USING and INTO clauses

--First example
CREATE OR REPLACE FUNCTION get_count (table_name IN VARCHAR2) RETURN PLS_INTEGER IS
    v_count PLS_INTEGER;
BEGIN
    --See how we're using the INTO clause to populate the value of v_count variable
    EXECUTE IMMEDIATE 'SELECT count(*) FROM ' || table_name INTO v_count;
    RETURN v_count;
END;
/
--Now let's use the function
--**************************** IMPORTANT EXAMPLE **********************************
--This function will fetch all tables in schema and count how many rows it has
DECLARE
    v_table_name VARCHAR2(50);
BEGIN
    FOR r_table IN (SELECT table_name FROM user_tables) LOOP
        dbms_output.put_line('There are ' || get_count(r_table.table_name) || ' rows in the ' || r_table.table_name || ' table!');
    END LOOP;
END;
/

--Slightly different example
DECLARE
    v_table_name VARCHAR2(50);
BEGIN
    FOR r_table IN (SELECT table_name FROM user_tables) LOOP
        IF get_count(r_table.table_name) > 100 THEN
            dbms_output.put_line('There are ' || get_count(r_table.table_name) || ' rows in the ' || r_table.table_name || ' table!');
            dbms_output.put_line('It should be considered for partitioning');
        END IF;
    END LOOP;
END;
/


--SECOND EXAMPLE

--Let's create two tables
CREATE TABLE stock_managers AS SELECT * FROM employees WHERE job_id = 'ST_MAN';
CREATE TABLE stock_clerks AS SELECT * FROM employees WHERE job_id = 'ST_CLERK';

--Now let's create a FUNCTION 
CREATE OR REPLACE FUNCTION get_avg_sals (p_table IN VARCHAR2, p_dept_id IN NUMBER) RETURN PLS_INTEGER IS
    v_average PLS_INTEGER;
BEGIN
    EXECUTE IMMEDIATE 'SELECT AVG(salary) FROM ' || p_table || ' WHERE department_id=:2' INTO v_average USING p_dept_id;
    RETURN v_average;
END;
/
--Here is an IMPORTANT note. You may have noticed that we're not BINDING the table_name
--in the DYNAMIC SQL. This is because the BINDING comes AFTER the PARSING. We cannot use 
--BINDING for COLUMNS, TABLES, etc. To solve for that, we CONCATENATE

--Now we use our FUNCTION
SELECT get_avg_sals('stock_clerks', '50') FROM dual;
SELECT get_avg_sals('stock_managers', '50') FROM dual;