--DYNAMIC PL/SQL BLOCKS

--First stablish a valid PL/SQL
BEGIN
    FOR r_emp IN (SELECT * FROM employees) LOOP
        dbms_output.put_line(r_emp.first_name || ' ' || r_emp.last_name);
    END LOOP;
END;
/

--Now, we will try to embedd that PL/SQL bloch into an Anonymous Block
DECLARE 
    v_dynamic_text VARCHAR2(1000);
BEGIN
    --Notice how we'll use the quote operator q'
    v_dynamic_text := q'[BEGIN
                            FOR r_emp IN (SELECT * FROM employees) LOOP
                                dbms_output.put_line(r_emp.first_name || ' ' || r_emp.last_name);
                            END LOOP;
                        END;]';
    EXECUTE IMMEDIATE v_dynamic_text;
END;
/

--Let's make an small change by adding a local variable to the PL/SQL block
DECLARE 
    v_dynamic_text VARCHAR2(1000);
    --v_department_id PLS_INTEGER := 30;
BEGIN
    v_dynamic_text := q'[
                        DECLARE
                            v_department_id PLS_INTEGER := 30;
                        BEGIN
                            FOR r_emp IN (SELECT * FROM employees WHERE department_id=v_department_id) LOOP
                                dbms_output.put_line(r_emp.first_name || ' ' || r_emp.last_name);
                            END LOOP;
                        END;]';
    EXECUTE IMMEDIATE v_dynamic_text;
END;
/
--The take away from this example should be that the global variable can't be reached by the DYNAMIC PL/SQL block
--That's why it is commented in the DECLARE section

--We can, nontheless, access GLOBAL variables in Schema. 
--For instance, let's create a PACKAGE containing one variable
CREATE PACKAGE pkg_temp AS
    v_department_id_pkg PLS_INTEGER := 50;
END;
/

--Now let's modify our previous Anonymous block for the DYNAMIC PL/SQL to call that PACKAGEs variable
DECLARE 
    v_dynamic_text VARCHAR2(1000);
BEGIN
    --Here you can see we''re using the pkg_temp.v_department_id_pkg variable from package
    v_dynamic_text := q'[
                        DECLARE
                            v_department_id PLS_INTEGER := 30;
                        BEGIN
                            FOR r_emp IN (SELECT * FROM employees WHERE department_id=pkg_temp.v_department_id_pkg) LOOP
                                dbms_output.put_line(r_emp.first_name || ' ' || r_emp.last_name);
                            END LOOP;
                        END;]';
    EXECUTE IMMEDIATE v_dynamic_text;
END;
/

--Now, we could use local variables instead of GLOBAL variables, if we BIND them. 
--Here's an example
--Instead of using the variable from the PACKAGE, we BIND the v_department_id variable
--by writing the USING clause after the EXECUTE IMMEDIATE statement
DECLARE 
    v_dynamic_text VARCHAR2(1000);
    v_department_id PLS_INTEGER := 30;
BEGIN
    v_dynamic_text := q'[
                        BEGIN
                            FOR r_emp IN (SELECT * FROM employees WHERE department_id = :1) LOOP
                                dbms_output.put_line(r_emp.first_name || ' ' || r_emp.last_name);
                            END LOOP;
                        END;]';
    EXECUTE IMMEDIATE v_dynamic_text USING v_department_id;
END;
/


--Also, we can fetch variable from the DYNAMIC PL/SQL Block by using the IN OUT clauses
DECLARE 
    v_dynamic_text VARCHAR2(1000);
    v_department_id PLS_INTEGER := 30;
    --Add variable to hold max salary
    v_max_salary PLS_INTEGER := 0;
BEGIN
    v_dynamic_text := q'[
                        BEGIN
                            FOR r_emp IN (SELECT * FROM employees WHERE department_id = :1) LOOP
                                dbms_output.put_line(r_emp.first_name || ' ' || r_emp.last_name);
                                IF r_emp.salary > :sal THEN
                                    :sal := r_emp.salary;
                                END IF;
                            END LOOP;
                        END;]';
    EXECUTE IMMEDIATE v_dynamic_text USING v_department_id, IN OUT v_max_salary;
    --Print the MAX salary from the result of the PL/SQL block
    dbms_output.put_line('The maximum salary of this department is: ' || v_max_salary);
END;
/


--We can handle the EXCEPTIONS that the DYNAMIC PL/SQL block thrown. Since we can not do it in the 
--DYNAMIC PL/SQL block itself

--We now intentionally put the wrong table name to the DYNAMIC PL/SQL block
DECLARE 
    v_dynamic_text VARCHAR2(1000);
    v_department_id PLS_INTEGER := 30;
    v_max_salary PLS_INTEGER := 0;
BEGIN
    v_dynamic_text := q'[
                        BEGIN
                            FOR r_emp IN (SELECT * FROM employeese WHERE department_id = :1) LOOP
                                dbms_output.put_line(r_emp.first_name || ' ' || r_emp.last_name);
                                IF r_emp.salary > :sal THEN
                                    :sal := r_emp.salary;
                                END IF;
                            END LOOP;
                        END;]';
    EXECUTE IMMEDIATE v_dynamic_text USING v_department_id, IN OUT v_max_salary;
    dbms_output.put_line('The maximum salary of this department is: ' || v_max_salary);
--And here we declare an EXCEPTION section to handle the "table or view does not exist" error
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('The error is: ' || sqlerrm);
END;
/