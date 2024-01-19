--PACKAGES

--There are two main ideas behind packages
--Logically group DB objects such as tables, Functions, Procedures, Triggers, etc
--Performance (since it is loaded into the SGA (System Global Area) for every user in DB to be used)

--Creating a Package has two main parts
--Package Specification (which is kind of like an interface)
--Package Body (which is kind of like the implementation of the spec)

--Look at the following example.
--First we create the Spec
CREATE OR REPLACE PACKAGE EMP as 

  v_salary_increase_rate NUMBER := 1000;
  CURSOR cur_emps IS SELECT * FROM employees;
  PROCEDURE increase_salaries;
  FUNCTION get_avg_sal(p_dept_id INT) RETURN NUMBER;
  
END EMP;
/
--Now we create the Package Body
CREATE OR REPLACE
PACKAGE BODY emp AS
  --Implement the increase_salaries PROCEDURE
  PROCEDURE increase_salaries AS
  BEGIN
    FOR r1 IN cur_emps LOOP
        UPDATE employees_copy SET salary = salary +  v_salary_increase_rate;
    END LOOP;
  END increase_salaries;
  
  --Implement the get_avg_salary FUNCTION
  FUNCTION get_avg_sal(p_dept_id INT) RETURN NUMBER AS
    v_avg_sal NUMBER := 0; 
  BEGIN
    SELECT AVG(salary) INTO v_avg_sal FROM employees_copy
    WHERE department_id = p_dept_id;
    
    RETURN v_avg_sal;
  END get_avg_sal;
END emp;
/

--Now these is how we can call one of the PROCEDURES in the Package
EXEC increase_salaries;
/
--Or else we can do it inside a BEGIN END block
BEGIN
    --Execute the get_avg_sal FUNCTION inside the EMP Package for Departemend ID 50
    dbms_output.put_line(emp.get_avg_sal(50));

    --Fetch v_salary_increase_rate variable to print
    dbms_output.put_line(emp.v_salary_increase_rate);
END;