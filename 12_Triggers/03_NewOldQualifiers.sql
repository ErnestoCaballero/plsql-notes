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