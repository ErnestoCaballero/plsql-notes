--EXECUTE IMMEDIATE

--The power of this COMMAND allow us to perform DDL operations in FUNCTIONS, PROCEDURES and ANONYMOUS BLOCKS
--Which you cannot perform with regular SQL. This is DYNAMIC SQL

--Look at this first example of an Anonymous Block
BEGIN
    EXECUTE IMMEDIATE 'GRANT SELECT ON employees TO SYS';
END;
/
--This allow us to GRANT SELECT privilege to SYS user inside a BEGIN END block

--Now let's try with a PROCEDURE
CREATE OR REPLACE PROCEDURE prc_create_table_dynamic(p_table_name IN VARCHAR2, p_col_specs IN VARCHAR2) IS
BEGIN
    EXECUTE IMMEDIATE 'CREATE TABLE ' || p_table_name || ' (' || p_col_specs || ')';
END;
/
--Here we're creating a procedure that will allow us to create a table INSIDE a PROCEDURE!
--This is how we will use it
EXEC prc_create_table_dynamic('dynamic_temp_table', 'id NUMBER PRIMARY KEY, name VARCHAR2(100)');
SELECT * FROM dynamic_temp_table; --Now the table is created

--But we can make it more GENERIC. Let's create a procedure that will perform basically any SQL statement
CREATE OR REPLACE PROCEDURE prc_generic(p_dynamic_sql IN VARCHAR2) IS
BEGIN
    EXECUTE IMMEDIATE p_dynamic_sql;
END;
/
--This is how we'll use it:
--Perform a DROP operation for created table
EXEC prc_generic('DROP TABLE dynamic_temp_table');

--INSERT data into the created table
EXEC prc_generic('INSERT INTO dynamic_temp_table VALUES (1, ''Edgar'')');

--SELECT statement will not show the result
EXEC prc_generic('SELECT * FROM employees');