--CURSORS WITH PARAMETERS

DECLARE
    --When declaring the parameter specify it will recive a NUMBER parameter named p_dept_id
    CURSOR c_emps (p_dept_id NUMBER) IS SELECT first_name, last_name, department_name
                                        FROM employees JOIN departments USING (department_id)
                                        WHERE department_id = p_dept_id;
    --Create a RECORD that will hold the values in the CURSOR
    v_emps c_emps%rowtype;
BEGIN
    --OPEN anc CLOSE the CURSOR to print the department name
    OPEN c_emps(20);
    FETCH c_emps INTO v_emps;
    dbms_output.put_line('The employees in department of ' || v_emps.department_name || ' are: ' );
    CLOSE c_emps;
    
    --OPEN and CLOSE the CURSOR to iterate into the names of the people in the department
    OPEN c_emps(20);
        LOOP
            FETCH c_emps INTO v_emps;
            EXIT WHEN c_emps%NOTFOUND;
            dbms_output.put_line(v_emps.first_name || ' ' || v_emps.last_name);
        END LOOP;
    CLOSE c_emps;
END;
/

--Bind variables can be used as parameters as well
DECLARE
    CURSOR c_emps (p_dept_id NUMBER) IS SELECT first_name, last_name, department_name
                                        FROM employees JOIN departments USING (department_id)
                                        WHERE department_id = p_dept_id;
    v_emps c_emps%rowtype;
BEGIN
    OPEN c_emps(:b_dept_id);
    FETCH c_emps INTO v_emps;
    dbms_output.put_line('The employees in department of ' || v_emps.department_name || ' are: ' );
    CLOSE c_emps;
    
    OPEN c_emps(:b_dept_id);
        LOOP
            FETCH c_emps INTO v_emps;
            EXIT WHEN c_emps%NOTFOUND;
            dbms_output.put_line(v_emps.first_name || ' ' || v_emps.last_name);
        END LOOP;
    CLOSE c_emps;
END;
/

--Now let's use the same code, but print two diferent departments:
--Notice that the second department printing use the FOR LOOP to iterate with all it's benefits
DECLARE
    CURSOR c_emps (p_dept_id NUMBER) IS SELECT first_name, last_name, department_name
                                        FROM employees JOIN departments USING (department_id)
                                        WHERE department_id = p_dept_id;
    v_emps c_emps%rowtype;
BEGIN
    --Print first department logic
    OPEN c_emps(:b_dept_id);
    FETCH c_emps INTO v_emps;
    dbms_output.put_line('The employees in department of ' || v_emps.department_name || ' are: ' );
    CLOSE c_emps;
    
    OPEN c_emps(:b_dept_id);
        LOOP
            FETCH c_emps INTO v_emps;
            EXIT WHEN c_emps%NOTFOUND;
            dbms_output.put_line(v_emps.first_name || ' ' || v_emps.last_name);
        END LOOP;
    CLOSE c_emps;
    
    --Print second department logic
    OPEN c_emps(:b_dept_id2);
    FETCH c_emps INTO v_emps;
    dbms_output.put_line('The employees in department of ' || v_emps.department_name || ' are: ' );
    CLOSE c_emps;
    
    --When iterating we now use FOR LOOP to save us using OPEN, CLOSE and EXIT. Compared with the Basic LOOP used before.
    FOR i IN c_emps(:b_dept_id2) LOOP
        dbms_output.put_line(i.first_name || ' ' || i.last_name);
    END LOOP;
END;
/

--Now make an example with multiple parameters for the CURSOR:
DECLARE
    CURSOR c_emps (p_dept_id NUMBER, p_job_id VARCHAR2) IS SELECT first_name, last_name, job_id, department_name
                                        FROM employees JOIN departments USING (department_id)
                                        WHERE department_id = p_dept_id
                                        AND job_id = p_job_id;
    v_emps c_emps%rowtype;
BEGIN
   
    FOR i IN c_emps(50, 'ST_MAN') LOOP
        dbms_output.put_line(i.first_name || ' ' || i.last_name || ' - ' || i.job_id);
    END LOOP;
    
    dbms_output.put_line('-');
    
    FOR i IN c_emps(80, 'SA_MAN') LOOP
        dbms_output.put_line(i.first_name || ' ' || i.last_name || ' - ' || i.job_id);
    END LOOP;
END;