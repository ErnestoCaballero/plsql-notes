--:NEW & :OLD Qualifiers in TRIGGERS

--Are use ONLY in ROW LEVEL TRIGGERS (that means they have the FOR EACH ROW sentence)

--****************** NOTE ***************************
--All Triggers of a table may be disabled with one command
ALTER TABLE <<table_name>> DISABLE ALL TRIGGERS;

--Here is an example of a :new and :old variables
CREATE OR REPLACE TRIGGER after_row_emp_cpy
AFTER INSERT OR UPDATE ON employees_copy
FOR EACH ROW
BEGIN
    dbms_output.put_line('After Row Trigger is Fired!');
    dbms_output.put_line('The salary of the Employee ' || :old.employee_id || ' -> Before: ' || :old.salary || ' After: ' || :new.salary);
END;
/
--NOTICE that the :new and :old variables only work before we added the FOR EACH ROW sentence

--You should take into account that INSERT triggers will no have :old values since there were not old valyes
--Same as DELETE triggers will not return :new variables since the records do not exist anymore

--You can change the alias for old and new qualifiers by writing the REFERENCING OLD AS <<alias_old>> NEW AS <<alias_new>>
--BEFORE the FOR EACH ROW sentence
create or replace TRIGGER before_row_emp_cpy
BEFORE INSERT OR UPDATE ON employees_copy
REFERENCING OLD AS o NEW AS n
FOR EACH ROW
BEGIN
    dbms_output.put_line('Before Row Trigger is Fired!');
    dbms_output.put_line('The salary of the Employee ' || :o.employee_id 
     || ' -> Before: ' || :o.salary || ' After: ' || :n.salary);
END;
/
