--FOR UPDATE CLAUSE

--When you update a row it is locked to other users
--FOR UPDATE clause locks the selected rows and will unlocked them as soonas you commit or rollback
--If some other user locked the rows already, this clause behaviour is to WAIT until it is released, which may not be efficient
--NOWAIT option will terminate the execution if there is a lock. The defult option is WAIT
--FOR UPDATE OF clause locks only the selected tables

--Structure:
--CURSOR cursor_name(parameter_name DATATYPE,...) IS select_statement FOR UPDATE [OF columns] [NOWAIT | WAIT n]; 
--Where "n" is the number of seconds to wait.

grant create session to my_user;
grant select any table to my_user;
grant update on hr.employees_copy to my_user;
grant update on hr.departments to my_user;
UPDATE EMPLOYEES_COPY SET PHONE_NUMBER = '1' WHERE EMPLOYEE_ID = 100;
declare
  cursor c_emps is select employee_id,first_name,last_name,department_name
      from employees_copy join departments using (department_id)
      where employee_id in (100,101,102)
      for update;
begin
  /* for r_emps in c_emps loop
    update employees_copy set phone_number = 3
      where employee_id = r_emps.employee_id; 
  end loop; */
  open c_emps;
end;
--------------- example of wait with second
declare
  cursor c_emps is select employee_id,first_name,last_name,department_name
      from employees_copy join departments using (department_id)
      where employee_id in (100,101,102)
      for update of employees_copy.phone_number, 
      departments.location_id wait 5;
begin
  /* for r_emps in c_emps loop
    update employees_copy set phone_number = 3
      where employee_id = r_emps.employee_id; 
  end loop; */
  open c_emps;
end;
---------------example of nowait
declare
  cursor c_emps is select employee_id,first_name,last_name,department_name
      from employees_copy join departments using (department_id)
      where employee_id in (100,101,102)
      for update of employees_copy.phone_number, 
      departments.location_id nowait;
begin
  /* for r_emps in c_emps loop
    update employees_copy set phone_number = 3
      where employee_id = r_emps.employee_id; 
  end loop; */
  open c_emps;
end;
/
-------------Another Basic example (performing an update)
DECLARE
    CURSOR c_emps IS SELECT * FROM employees
                     WHERE department_id=30 FOR UPDATE;
BEGIN
    FOR r_emps IN c_emps LOOP
        UPDATE employees SET salary = salary + 60
        WHERE employee_id = r_emps.employee_id;
    END LOOP;
END;