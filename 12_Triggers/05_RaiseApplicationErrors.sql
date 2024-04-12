--RAISE APPLICATION ERRORS

--It is a built-in procedure that returns an  ERROR to the user and causes PL/SQL code to fail
--The syntax of the function is raise_application_error(<<number between 20,000>>, <<ERROR_MESSAGE>>);

--It may enfore certain constraints to prevent invalid data entries or deletes.
CREATE OR REPLACE TRIGGER before_row_emp_cpy
BEFORE INSERT OR UPDATE OR DELETE ON employees_copy
REFERENCING OLD AS o NEW AS n
FOR EACH ROW
BEGIN
    dbms_output.put_line('Before Row Trigger is Fired!');
    dbms_output.put_line('The salary of the Employee ' || :o.employee_id 
     || ' -> Before: ' || :o.salary || ' After: ' || :n.salary);

    IF INSERTING THEN
        IF :n.hire_date > sysdate THEN
            --Here is the first example using it when trying to insert future employees
            raise_application_error(-20000,'You cannot enter a future hire...');
        END IF;
        dbms_output.put_line('An INSERT occurred on employees_copy table');
    ELSIF UPDATING('salary') THEN
        IF :n.salary > 50000 THEN
            --Here's another one when trying to update a salary for an amount higher than 50,000
            raise_application_error(-20002,'A salary cannot be higher than $50,000');
        END IF;
        dbms_output.put_line('An UPDATE occurred on employees_copy table and salary column');
    ELSIF UPDATING THEN
        dbms_output.put_line('An UPDATE occurred on employees_copy table');
    ELSIF DELETING THEN
        --This will stop the delete operation causing it to fail BEFORE doing it
        raise_application_error(-20001, 'You cannot delete from the employees_copy table..');
        dbms_output.put_line('A DELETE occurred on employees_copy table');
    END IF;

END;
/

--Another cool version to validate the user trying to update
create or replace TRIGGER before_row_emp_cpy
BEFORE INSERT OR UPDATE OR DELETE ON employees_copy
REFERENCING OLD AS o NEW AS n
FOR EACH ROW
BEGIN
    dbms_output.put_line('Before Row Trigger is Fired!');
    dbms_output.put_line('The salary of the Employee ' || :o.employee_id 
     || ' -> Before: ' || :o.salary || ' After: ' || :n.salary);

    IF INSERTING THEN
        IF :n.hire_date > sysdate THEN
            raise_application_error(-20000,'YOu cannot enter a future hire...');
        END IF;
        dbms_output.put_line('An INSERT occurred on employees_copy table');
    ELSIF UPDATING('salary') THEN
        IF :n.salary > 50000 THEN
            raise_application_error(-20002,'A salary cannot be higher than $50,000');
        END IF;
        dbms_output.put_line('An UPDATE occurred on employees_copy table and salary column');
    ELSIF UPDATING THEN
        dbms_output.put_line('An UPDATE occurred on employees_copy table');
    ELSIF DELETING THEN
        --Here in the DELETE case we validate the user attempting to DELETE
        dbms_output.put_line('The user attempting to DELETE is ' || user);
        IF user = 'SYS' THEN
            raise_application_error(-20006, 'Dont be naughty boy');
        END IF;
        raise_application_error(-20001, 'You cannot delete from the employees_copy table..');
        dbms_output.put_line('A DELETE occurred on employees_copy table');
    END IF;

END;
