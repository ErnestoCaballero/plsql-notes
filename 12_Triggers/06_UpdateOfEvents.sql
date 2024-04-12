--UPDATE OF events

--It is used when you want to create a Trigger that fires when a set of columns in a table are updated

--The first most common case would be to do it for just one column in a table. For instance:
CREATE OR REPLACE TRIGGER prevent_updates_of_constant_columns
BEFORE UPDATE OF hire_date ON employees_copy
FOR EACH ROW
BEGIN
    raise_application_error(-20005, 'You cannot modify the hire_date!');
END;
/

--To use multiple columns, just separate by commas:
CREATE OR REPLACE TRIGGER prevent_updates_of_constant_columns
BEFORE UPDATE OF hire_date, salary ON employees_copy
FOR EACH ROW
BEGIN
    raise_application_error(-20005, 'You cannot modify the hire_date and salary!');
END;
/
