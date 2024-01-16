--FUNCTIONS
--Differences and Similarities between FUNCTIONS and PROCEDURES
--1. Procedures are executed within a BEGIN-END block or with EXEC/EXECUTE statement
--2. Functions are used within an SQL Query OR assigned to some variable
--3. We can pass IN & OUT parameters to both (but do in it in FUNCTIONS is not recommended)
--4.  MAIN DIFFERENCE: Procedures does not RETURN a value, but FUNCTIONS do

--Let's say I want to create a FUNCTION to get the average salary of an specific department
--We set as parametes de department_id and RETURN a NUMBER variable
--Also notice after the END keyword we write the name of the declared FUNCTION
CREATE OR REPLACE FUNCTION get_avg_sal(p_dept_id DEPARTMENTS.department_id%type) RETURN NUMBER AS v_avg_sal NUMBER;
BEGIN
    SELECT ROUND(AVG(salary),2) INTO v_avg_sal FROM employees WHERE department_id=p_dept_id;
    RETURN v_Avg_sal;
END get_avg_sal;
/

--A simple way to use it might be
DECLARE
    v_avg_salary NUMBER;
BEGIN
    v_avg_salary := GET_AVG_SAL(50);
    dbms_output.put_line(v_avg_salary);
END;
/

--But one of the most innovative ways of using the FUNCTION is in a QUERY as in
SELECT employee_id, first_name, salary, GET_AVG_SAL(department_id) avg_sal FROM employees;

--***********************************************************************************************************
--However, there is a restriction. If the function is performing DML operations or COMMIT, ROLLBACk or DDL, it can't be used this way
--***********************************************************************************************************

--And we can do more interesting stuff such as quering which employees earn more than the average salary for it's department
SELECT employee_id, first_name, salary, GET_AVG_SAL(department_id) avg_sal FROM employees
WHERE salary > GET_AVG_SAL(department_id);

SELECT department_id,GET_AVG_SAL(department_id) avg_sal 
FROM employees
WHERE salary > GET_AVG_SAL(department_id)
GROUP BY department_id,GET_AVG_SAL(department_id)
ORDER BY GET_AVG_SAL(department_id);

---There is a third way to RUN a FUNCTION. It is by using SQL Developer. 
--Right Click on the Functions options under your schema and click on RUN