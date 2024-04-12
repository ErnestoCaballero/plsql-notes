--EXECUTE IMMEDIATE command with USING clause

--Let's first create a table
CREATE TABLE names (id NUMBER PRIMARY KEY, name VARCHAR2(100));

--Now a function which will receive two parameters
--We want those two parametes to be BIND into the DYNAMIC SQL 
CREATE OR REPLACE FUNCTION insert_values (id IN VARCHAR2, name IN VARCHAR2) RETURN PLS_INTEGER IS
BEGIN
    --Here we can see how we're BINDING the parameters of the function into the DYNAMYC SQL
    --and use the USING clause
    EXECUTE IMMEDIATE 'INSERT INTO names VALUES (:a, :b)' USING id, name;
    RETURN SQL%ROWCOUNT; --The SQL%ROWCOUNT function fetches the count of rows affected by last SQL statement
END;
/
--Now let's use our function
DECLARE
    v_affected_rows PLS_INTEGER;
BEGIN
    v_affected_rows := insert_values(2, 'John');
    dbms_output.put_line(v_affected_rows || ' row inserted!');
END;
/
--Verify it was inserted
SELECT * FROM names;

--Let's add another column to the table
ALTER TABLE names ADD (last_name VARCHAR2(100));

--Whith that, we'll create another function to update the last_name
CREATE OR REPLACE FUNCTION update_names (id IN VARCHAR2, last_name IN VARCHAR2) RETURN PLS_INTEGER IS
    v_dynamic_sql VARCHAR2(200);
BEGIN
    --Observe how we're also BINDING the FUNCTION parameters to the DYNAMIC SQL
    v_dynamic_sql := 'UPDATE names SET last_name = :1 WHERE id = :2';
    --Here we use the USING clause
    EXECUTE IMMEDIATE v_dynamic_sql USING last_name, id;
    RETURN SQL%ROWCOUNT;
END;
/
--Let's execute this new function
DECLARE
    v_affected_rows PLS_INTEGER;
BEGIN
    v_affected_rows := update_names(2, 'Brown');
    dbms_output.put_line(v_affected_rows || ' row updated!');
END;
/
--And check if the insert was performed
SELECT * FROM names;

--FINALLY what if we want to get OUT a value from the DYNAMIC SQL
--We can use the RETURNING clause for the desired OUT parameters
CREATE OR REPLACE FUNCTION update_names (id IN VARCHAR2, last_name IN VARCHAR2, first_name OUT VARCHAR2) RETURN PLS_INTEGER IS
    v_dynamic_sql VARCHAR2(200);
BEGIN
    --Look at the use of the RETURNING clause. After the DML statment
    v_dynamic_sql := 'UPDATE names SET last_name = :1 WHERE id = :2 RETURNING name INTO :3';
    --In the EXECUTE IMMEDIATE you should use the RETURNING INTO clause
    EXECUTE IMMEDIATE v_dynamic_sql USING last_name, id RETURNING INTO first_name;
    RETURN SQL%ROWCOUNT;
END;
/

--This is how we would use the FUNCTION
DECLARE
    v_affected_rows PLS_INTEGER;
    v_first_name VARCHAR2(100);
BEGIN
    v_affected_rows := update_names(2, 'King', v_first_name);
    dbms_output.put_line(v_affected_rows || ' row updated!');
    dbms_output.put_line(v_first_name);
END;
/