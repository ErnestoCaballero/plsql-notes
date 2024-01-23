--CONDITIONAL PREDICATES

--The main issue that they solve is to have one single trigger for each event (INSERT, UPDATE, DELETE)
--Instead of having to create one trigger for each one. 
--You should use the UPDATING, DELETING and INSERTING clauses inside an IF block

--Here is an example
CREATE OR REPLACE TRIGGER before_row_emp_cpy
BEFORE INSERT OR UPDATE OR DELETE ON employees_copy
REFERENCING OLD AS o NEW AS n
FOR EACH ROW
BEGIN
    dbms_output.put_line('Before Row Trigger is Fired!');
    dbms_output.put_line('The salary of the Employee ' || :o.employee_id 
     || ' -> Before: ' || :o.salary || ' After: ' || :n.salary);

    --Here is HOW to write the CASES for EACH DML operation
    IF INSERTING THEN
        dbms_output.put_line('An INSERT occurred on employees_copy table');
    ELSIF UPDATING THEN
        dbms_output.put_line('An UPDATE occurred on employees_copy table');
    ELSIF DELETING THEN
        dbms_output.put_line('A DELETE occurred on employees_copy table');
    END IF;
END;
/

--In case you would like to perform an operation JUST in case an SPECIFI column was modified
--You can use the IF UPDATING('column_name') syntax for that porpose:
--Let's modify previous example to illustrate it
create or replace TRIGGER before_row_emp_cpy
BEFORE INSERT OR UPDATE OR DELETE ON employees_copy
REFERENCING OLD AS o NEW AS n
FOR EACH ROW
BEGIN
    dbms_output.put_line('Before Row Trigger is Fired!');
    dbms_output.put_line('The salary of the Employee ' || :o.employee_id 
     || ' -> Before: ' || :o.salary || ' After: ' || :n.salary);

    IF INSERTING THEN
        dbms_output.put_line('An INSERT occurred on employees_copy table');
    --Here we're stating that in case an UPDATE is done in the salary column something will happen:
    ELSIF UPDATING('salary') THEN
        dbms_output.put_line('An UPDATE occurred on employees_copy table and salary column');
    ELSIF UPDATING THEN
        dbms_output.put_line('An UPDATE occurred on employees_copy table');
    ELSIF DELETING THEN
        dbms_output.put_line('A DELETE occurred on employees_copy table');
    END IF;
END;
/