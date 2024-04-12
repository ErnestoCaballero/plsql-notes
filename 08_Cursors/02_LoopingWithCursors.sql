--Basic Loop
--The key element to undestand is the EXIT THEN c_emps%notfound condition
--if not added, it will create an infinit loop
DECLARE
    CURSOR c_emps IS SELECT * FROM employees WHERE DEPARTMENT_ID=30;
    v_emps c_emps%rowtype;
BEGIN
    OPEN c_emps;
    LOOP 
        FETCH c_emps INTO v_emps;
        EXIT WHEN c_emps%notfound; --Here is the condition to exit inside the loop
        dbms_output.put_line(v_emps.employee_id || ' ' || v_emps.first_name || ' ' || v_emps.last_name);
    END LOOP;
    CLOSE c_emps;
END;
/

--WHILE
--Nótese que para el WHILE, se usa la función %FOUND
--Esta función devuelve un booleano TRUE si la última operación de FETCH arrojó algún resultado
--Es por ese motivo también que ponemos un FETCH antes del while. Como para inicilizar el CURSOR
DECLARE
    CURSOR c_emps IS SELECT * FROM employees WHERE DEPARTMENT_ID=30;
    v_emps c_emps%rowtype;
BEGIN
    OPEN c_emps;
    FETCH c_emps INTO v_emps;

    WHILE c_emps%found LOOP 
        dbms_output.put_line(v_emps.employee_id || ' ' || v_emps.first_name || ' ' || v_emps.last_name);
        FETCH c_emps INTO v_emps;
    END LOOP;

    CLOSE c_emps;
END;
/

--FOR
--Using the FOR clause has it's advantaged
--For instance, you don't have to declare a variable%rowtype
--nor OPEN and CLOSE the CURSOS
--The FOR does that automatically
DECLARE
    CURSOR c_emps IS SELECT * FROM employees WHERE DEPARTMENT_ID=30;
BEGIN
    FOR i IN c_emps LOOP --we may say that each i is a record
        dbms_output.put_line(i.employee_id || ' ' || i.first_name || ' ' || i.last_name);
    END LOOP;
END;
/

--There is even a more straight forward approach. 
--Instead of declaring the CURSOR explicitly, just put the SELECT statement into the FOR
--This is recommended when you'll just use the SELECT once
--If you'll use the CURSOR multiple times it's better to declare the CURSOS explicitly
BEGIN
    FOR i IN (SELECT * FROM employees WHERE DEPARTMENT_ID=30) LOOP 
        dbms_output.put_line(i.employee_id || ' ' || i.first_name || ' ' || i.last_name);
    END LOOP;
END;
/