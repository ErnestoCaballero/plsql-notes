--DML TRIGGERS

--TRIGGERS are PL/SQL blocks that executed before or after or instead of a specific event
--This events may be:
--DML (Insert, Update, Delete, etc)
--DDL (Create, Alter, Drop, etc)
--DB Operations (logon, startup, servererror, etc)

--Let's say I want to print when ANY UPDATE is executed on the employees table
--This would be one of the most basic examples
CREATE OR REPLACE TRIGGER first_trigger 
BEFORE INSERT OR UPDATE ON employees_copy
BEGIN 
  dbms_output.put_line('An insert or update occurred in the employees_copy table!');
END;
/
--We would see the output when executing for instance:
UPDATE employees_copy SET salary = salary + 100;
/



