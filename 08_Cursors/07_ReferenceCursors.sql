--REFERENCE CURSORS

--To use reference CURSOR you should first declare a TYPE of REF CURSOR
--If you're going to loop through it, FOR is not a good option since you have to explicitly OPEN the cursor to use it
--See the following basic example
DECLARE
    --Create a TYPE REF CURSOR in this case is STRONG since it has a RETURN value
    TYPE t_emps IS REF CURSOR RETURN employees%rowtype;
    --Declare a variable to be of that CURSOR type
    rc_emps t_emps;
    --Create a variable to hold the values of the CURSOR
    r_emps employees%rowtype; --Or, since it's a Strong CURSOR type, we could r_emps rc_emps%rowtype.
BEGIN
    --OPEN the CURSOR explicitly WITH the query to point
    OPEN rc_emps FOR SELECT * FROM employees;
    LOOP
        FETCH rc_emps INTO r_emps;
        EXIT WHEN rc_emps%NOTFOUND; --Don't forget the EXIT statement using the %notfound attribute to break the loop
        dbms_output.put_line(r_emps.first_name || ' ' || r_Emps.last_name);
    END LOOP;
    CLOSE rc_emps;
END;
/

--Another example
--Here we first create a TYPE RECORD with just some columns of the employees table and the departments table named ty_emps (type employees)
--Then we create a CURSOR that will return the ty_emps type record
--We LOOP through the CURSOR storing the results into the r_emps variable for each iteration and print it
DECLARE
    TYPE ty_emps IS RECORD (e_id NUMBER,
                            first_name employees.first_name%type,
                            last_name employees.last_name%type,
                            department_name departments.department_name%type);
    r_emps ty_emps; --IN this variable I'll save the records from CURSOR
    
    TYPE t_emps IS REF CURSOR RETURN ty_emps; --Here I define the CURSOR TYPE
    rc_emps t_emps; --Here I "instantiate" the CURSOR. Initialize it. Declare it.
    
BEGIN
    OPEN rc_emps FOR SELECT employee_id,first_name,last_name, department_name 
                     FROM employees JOIN departments USING(department_id);
    
    LOOP
        FETCH rc_emps INTO r_emps;
        EXIT WHEN rc_emps%NOTFOUND; --Don't forget the EXIT clause using the %NOTFOUND attribute in the BASIC LOOP
        dbms_output.put_line(r_emps.first_name || ' ' || r_emps.last_name || ' is at the department of: ' || r_emps.department_name);
    END LOOP;
    CLOSE rc_emps;

END;
/

--To use queries dynamically, we should use WEAK CURSOR. In the previous case, we should delete the return statement
--Then we store the select_statement into a VARCHAR2 variable
--The rescritions of using weak cursors 
DECLARE
    TYPE ty_emps IS RECORD (e_id NUMBER,
                            first_name employees.first_name%type,
                            last_name employees.last_name%type,
                            department_name departments.department_name%type);
    r_emps ty_emps; --IN this variable I'll save the records from CURSOR
    
    TYPE t_emps IS REF CURSOR; --Delete the RETURN type
    rc_emps t_emps;
    
    --Declare the q variable to store the query
    q VARCHAR(200);
    
BEGIN
    --Assign the query to the q variable
    q := 'SELECT employee_id,first_name,last_name, department_name FROM employees JOIN departments USING(department_id)';
                     
    OPEN rc_emps FOR q; --Here use the q variable to open the CURSOR with it
    LOOP
        FETCH rc_emps INTO r_emps;
        EXIT WHEN rc_emps%NOTFOUND;
        dbms_output.put_line(r_emps.first_name || ' ' || r_emps.last_name || ' is at the department of: ' || r_emps.department_name);
    END LOOP;
    CLOSE rc_emps;
END;
/

--Now let's use the same CURSOR to loop through differnet query results
DECLARE
    TYPE ty_emps IS RECORD (e_id NUMBER,
                            first_name employees.first_name%type,
                            last_name employees.last_name%type,
                            department_name departments.department_name%type);
    r_emps ty_emps; 
    
    TYPE t_emps IS REF CURSOR;
    rc_emps t_emps; 
    
    r_depts departments%rowtype;
    
    q VARCHAR(200);
    
BEGIN
    q := 'SELECT employee_id,first_name,last_name, department_name FROM employees JOIN departments USING(department_id)';
                     
    OPEN rc_emps FOR q;
    LOOP
        FETCH rc_emps INTO r_emps;
        EXIT WHEN rc_emps%NOTFOUND;
        dbms_output.put_line(r_emps.first_name || ' ' || r_emps.last_name || ' is at the department of: ' || r_emps.department_name);
    END LOOP;
    CLOSE rc_emps;
    
    --Here we're using the same WEAK defined CURSOR to loop through the departments table
    OPEN rc_emps FOR SELECT * FROM departments;
    LOOP
        FETCH rc_emps INTO r_depts; --In this case, we FETCH into the r_depts RECORD
        EXIT WHEN rc_emps%NOTFOUND;
        dbms_output.put_line(r_depts.department_id || ' ' || r_depts.department_name); --Here we used the record to print some if it's values
    END LOOP;
    CLOSE rc_emps;
END;
/

--Also, we can use bind variables
DECLARE
    TYPE ty_emps IS RECORD (e_id NUMBER,
                            first_name employees.first_name%type,
                            last_name employees.last_name%type,
                            department_name departments.department_name%type);
    r_emps ty_emps;
    
    TYPE t_emps IS REF CURSOR;
    rc_emps t_emps;
    
    r_depts departments%rowtype;
    
    q VARCHAR(200);
    
BEGIN
    q := 'SELECT employee_id,first_name,last_name, department_name FROM employees JOIN departments USING(department_id) WHERE department_id = :b'; --Here we add the bind variable :b
                     
    OPEN rc_emps FOR q USING '50'; --To use the bind variable we use the USING clause at the end of the OPEN FOR clause
    LOOP
        FETCH rc_emps INTO r_emps;
        EXIT WHEN rc_emps%NOTFOUND;
        dbms_output.put_line(r_emps.first_name || ' ' || r_emps.last_name || ' is at the department of: ' || r_emps.department_name);
    END LOOP;
    CLOSE rc_emps;
    
    OPEN rc_emps FOR SELECT * FROM departments;
    LOOP
        FETCH rc_emps INTO r_depts;
        EXIT WHEN rc_emps%NOTFOUND;
        dbms_output.put_line(r_depts.department_id || ' ' || r_depts.department_name);
    END LOOP;
    CLOSE rc_emps;
END;
/

--There is a generic WEAK CURSOR that can be used called SYSREFCURSOR
--You can use it to instantiate your CURSOR
--It is also preferable to use it beacause all db have them. So it will work in other environments including Java for instance
--Modifying previous code
DECLARE
    TYPE ty_emps IS RECORD (e_id NUMBER,
                            first_name employees.first_name%type,
                            last_name employees.last_name%type,
                            department_name departments.department_name%type);
    r_emps ty_emps;
    
    --TYPE t_emps IS REF CURSOR;
    rc_emps SYS_REFCURSOR; --Here we use the SYS_REFCURSOR type as generic. No need to do the TYPE t_emps IS REF CURSOR
    
    r_depts departments%rowtype;
    
    q VARCHAR(200);
    
BEGIN
    q := 'SELECT employee_id,first_name,last_name, department_name FROM employees JOIN departments USING(department_id) WHERE department_id = :b';
                     
    OPEN rc_emps FOR q USING '50';
    LOOP
        FETCH rc_emps INTO r_emps;
        EXIT WHEN rc_emps%NOTFOUND;
        dbms_output.put_line(r_emps.first_name || ' ' || r_emps.last_name || ' is at the department of: ' || r_emps.department_name);
    END LOOP;
    CLOSE rc_emps;
    
    OPEN rc_emps FOR SELECT * FROM departments;
    LOOP
        FETCH rc_emps INTO r_depts;
        EXIT WHEN rc_emps%NOTFOUND;
        dbms_output.put_line(r_depts.department_id || ' ' || r_depts.department_name);
    END LOOP;
    CLOSE rc_emps;
END;
