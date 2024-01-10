--This was intender to be a business case example on using Associative Arrays

--First create a table
CREATE TABLE employees_salary_history AS
SELECT * FROM employees WHERE 1=2;

--add another column to the created table holding a date
ALTER TABLE employees_salary_history ADD insert_date DATE;
SELECT * fROM employees_salary_history;
/

DECLARE 
    --Create an Associative Array of the type of the row of the newly created table
    TYPE e_list IS TABLE OF employees_salary_history%rowtype INDEX BY PLS_INTEGER;
    
    emps e_list;
    idx PLS_INTEGER;
BEGIN
    FOR x IN 100..110 LOOP
        --Insert into de associative array the elemens from db
        SELECT e.*, '01-JUN-20' INTO emps(x) FROM employees e WHERE employee_id=x;
    END LOOP;
    
    IDX := emps.first;
    
    --Iterate over the associative array to insert into the created table employees_salary_history
    WHILE idx IS NOT NULL LOOP
        emps(idx).salary := emps(idx).salary + emps(idx).salary * 0.2;
        INSERT INTO employees_salary_history VALUES emps(idx);
        dbms_output.put_line('THe employee ' || emps(idx).first_name
                                || ' is inserted into the history table');
        
        idx := emps.next(idx);
    END LOOP;
END;
/
SELECT * FROM employees_salary_history;