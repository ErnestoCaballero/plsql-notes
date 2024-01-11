--Explicit Cursors
--Basic Example of Explicit Cursor
DECLARE 
    CURSOR c_emps IS SELECT first_name, last_name FROM employees;
    v_first_name employees.first_name%type;
    v_last_name employees.last_name%type;
BEGIN
    OPEN c_emps;
    FETCH c_emps INTO v_first_name, v_last_name;
    dbms_output.put_line(v_first_name || ' ' || v_last_name);
    CLOSE c_emps;
END;
/

--Note that every time the FETCH sentence is executed, the CURSOR moves to the next record

--It is important to state that any valid select statement is valid for a CURSOS
--In the next example we use a join
DECLARE 
    CURSOR c_emps IS SELECT first_name, last_name, department_name 
                        FROM employees 
                        JOIN departments USING (department_id)
                        WHERE department_id BETWEEN 30 AND 60;
    v_first_name employees.first_name%type;
    v_last_name employees.last_name%type;
    v_department_name departments.department_name%type;
BEGIN
    OPEN c_emps;
    FETCH c_emps INTO v_first_name, v_last_name, v_department_name;
    dbms_output.put_line(v_first_name || ' ' || v_last_name || ' in the department of ' || v_department_name);
    CLOSE c_emps;
END;

--Although possible, it is not recomended to use RECORDS to embedd into a CURSOR as shown here
DECLARE 
    --Declare a type that will use the desired variable types
    TYPE r_emp IS RECORD (v_first_name employees.first_name%type,
                    v_last_name employees.last_name%type);
                    
    v_emp r_emp;
    
    CURSOR c_emps IS SELECT first_name, last_name FROM employees;

BEGIN
    OPEN c_emps;
    FETCH c_emps INTO v_emp;
    dbms_output.put_line(v_emp.v_first_name || ' ' || v_emp.v_last_name);
    CLOSE c_emps;
END;
/

--The must common and easy way to use records with cursors is to 
--first create the cursor and then define a variable of the rowtype of the cursor
--That way you're using the same variable types in the order selected in the cursos:
DECLARE 
    CURSOR c_emps IS SELECT first_name, last_name FROM employees;
    v_emp c_emps%rowtype;

BEGIN
    OPEN c_emps;
    FETCH c_emps INTO v_emp;
    dbms_output.put_line(v_emp.first_name || ' ' || v_emp.last_name);
    CLOSE c_emps;
END;
/