--COMPUND TRIGGERS

--You can put all Triggers Types into one single trigger:
--BEFORE STATEMENT
--AFTER STATEMENT
--BEFORE EACH ROW
--AFTER EACH ROW

--The types that you can use are optional, but you should at least use one of them.

--Here is an example:
CREATE OR REPLACE TRIGGER trg_comp_emps
FOR INSERT OR UPDATE OR DELETE ON employees_copy
COMPOUND TRIGGER
    v_dml_type VARCHAR2(10);
    
    BEFORE STATEMENT IS
        BEGIN
            IF INSERTING THEN
                v_dml_type := 'INSERTING';
            ELSIF UPDATING THEN
                v_dml_type := 'UPDATE';
            ELSIF DELETING THEN
                v_dml_type := 'DELETE';
            END IF;
            
            dbms_output.put_line('Before Statement Section is executed with the ' || v_dml_type || ' event.');
    END BEFORE STATEMENT;
    
    BEFORE EACH ROW IS
        --Notice here we can have local variables
        X NUMBER;
        BEGIN
            dbms_output.put_line('Before Row Section is executed with the ' || v_dml_type || ' event.');
    END BEFORE EACH ROW;
    
    AFTER EACH ROW IS
        BEGIN
            dbms_output.put_line('After Row Section is executed with the ' || v_dml_type || ' event.');
    END AFTER EACH ROW;
    
    AFTER STATEMENT IS
        BEGIN
            dbms_output.put_line('After Statement Section is executed with the ' || v_dml_type || ' event.');
    END AFTER STATEMENT;
END;
/

--To be noticed that all types will be executed and can share variables. 
--Then the BEFORE STATEMENT is executed, the v_dml_type variable is populated for the other types as well

--Here is a more real world example of COMPUND TRIGGERS:
CREATE OR REPLACE TRIGGER trg_comp_emps
FOR INSERT OR UPDATE OR DELETE ON employees_copy
COMPOUND TRIGGER
    TYPE t_avg_dept_salaries IS TABLE OF employees_copy.salary%type INDEX BY PLS_INTEGER;
    avg_dept_salaries t_avg_dept_salaries;
    
    BEFORE STATEMENT IS
        BEGIN
            FOR avg_sal IN (SELECT AVG(salary) salary, NVL(department_id, 999) department_id
                            FROM employees_copy GROUP BY department_id) LOOP
                avg_dept_salaries(avg_sal.department_id) := avg_sal.salary;         
            END LOOP;
    END BEFORE STATEMENT;
    
    AFTER EACH ROW IS
        v_interval NUMBER := 15;
        
        BEGIN
            IF :new.salary > avg_dept_salaries(:new.department_id) + avg_dept_salaries(:new.department_id) * v_interval / 100 THEN
                raise_application_error(-20005, 'A raise cannot be ' || v_interval || ' percent higher than its department average!');
            END IF;
    END AFTER EACH ROW;
    
    AFTER STATEMENT IS
        BEGIN
            dbms_output.put_line('All the changes were done successfully');
    END AFTER STATEMENT;
END;
/
