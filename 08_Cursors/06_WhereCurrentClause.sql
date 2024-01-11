
--WHERE CURRENT clause

--It needs to be used along with the FOR UPDATE clause
--The idea is to use the ROWID identifier (which is a unique identifier for every record in a table. More efficient than even primary_key)
--You can access that that ROWID using the CURSOR with the WHERE CURRENT clause
--When you're joining more than one table, the WHERE CURRENT clause should be replace with the WHERE rowid = cursor_name.rowid

--Let's see the following example where we're updating using a CURSOR
DECLARE
    CURSOR c_emps IS SELECT * FROM employees
                     WHERE department_id=30 FOR UPDATE;
BEGIN
    FOR r_emps IN c_emps LOOP
        UPDATE employees SET salary = salary + 60
        WHERE employee_id = r_emps.employee_id;
    END LOOP;
END;
/

--Now use the WHERE CURRENT clause inside the UPDATE clause
DECLARE
    CURSOR c_emps IS SELECT * FROM employees
                     WHERE department_id=30 FOR UPDATE;
BEGIN
    FOR r_emps IN c_emps LOOP
        UPDATE employees SET salary = salary + 60
        WHERE CURRENT OF c_emps;
    END LOOP;
END;
/

--This way you're accessing directly into the ROWID. This is useful because very often 
--a copied table, for instance, does not have a primary key or you may not even know which is the pk. 
--Using the WHERE CURRENT clause will access directly to the record ROWID to performe 
--UPDATE or DELETE operations FASTER.

--There is also the issue in which you can not use the WHERE CURRENT OF clause
--That's when you're JOINING tables. Since it does not know from which table use the ROWID
--For that case you should create your CURSOR to include the ROWID 
--And on the UPDATE statement use WHERE rowid = cursor_name.rowid
--As in the following example
DECLARE
    --Explicitly declare de e.rowid
    CURSOR c_emps IS SELECT e.rowid, e.salary FROM employees e, departments d
                     WHERE e.department_id=d.department_id
                     AND e.department_id=30 FOR UPDATE;
BEGIN
    FOR r_emps IN c_emps LOOP
        UPDATE employees SET salary = salary + 60
        WHERE rowid = r_emps.rowid; --Use the rowid to match the rowid in cursor
    END LOOP;
END;