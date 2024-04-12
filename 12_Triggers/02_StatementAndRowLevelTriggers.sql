--We can have TRIGGERS that are executed Before a statement
--After a Statement. Before an specific Row statement
--And After a specific Row statement

--Let's create a basic Trigger for each case in the employees_copy table
--Before Statement
CREATE OR REPLACE TRIGGER before_statement_emp_cpy
BEFORE INSERT OR UPDATE ON employees_copy
BEGIN
    dbms_output.put_line('Before Statement Trigger is Fired!');
END;
/

--After Statement
CREATE OR REPLACE TRIGGER after_statement_emp_cpy
AFTER INSERT OR UPDATE ON employees_copy
BEGIN
    dbms_output.put_line('After Statement Trigger is Fired!');
END;
/

--After Row Statement
--The differnece would be in the FOR EACH ROW statement
CREATE OR REPLACE TRIGGER after_row_emp_cpy
AFTER INSERT OR UPDATE ON employees_copy
FOR EACH ROW
BEGIN
    dbms_output.put_line('After Row Trigger is Fired!');
END;
/

--Before Row Statement
CREATE OR REPLACE TRIGGER before_row_emp_cpy
BEFORE INSERT OR UPDATE ON employees_copy
FOR EACH ROW
BEGIN
    dbms_output.put_line('Before Row Trigger is Fired!');
END;