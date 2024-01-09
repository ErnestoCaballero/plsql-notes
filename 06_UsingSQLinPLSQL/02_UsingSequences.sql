--employees_copy table is re-created

DROP TABLE employees_copy;
CREATE TABLE employees_copy AS
SELECT * FROM employees;

--sequence is created in this fashion
CREATE SEQUENCE employee_id_seq
START WITH 207
INCREMENT BY 1;

--Use the sequence employee_id_seq to insert entries in table
DECLARE
    v_employee_id PLS_INTEGER := 0;
BEGIN
    FOR i IN 1..10 LOOP 
        INSERT INTO employees_copy
            (employee_id, first_name, last_name, email, hire_date, job_id, salary)
        VALUES
            (employee_id_seq.nextval, 'employee#' || employee_id_seq.nextval, 'temp_emp', 'abc@xmail.com',sysdate,'IT_PROG',1000);
    END LOOP;
END;
/

SELECT * FROM employees_copy;

--Print the nextval of employee_id_seq object usign dual table
DECLARE
    v_seq_num NUMBER;
BEGIN
    SELECT employee_id_seq.nextval INTO v_seq_num FROM dual;
    dbms_output.put_line(v_seq_num);
END;

--print directly the nextval
DECLARE
    v_seq_num NUMBER;
BEGIN
    --v_seq_num := employee_id_seq.nextval;
    dbms_output.put_line(employee_id_seq.nextval);
END;

--Use the .currval method to see always the current value of the employee_id_seq
DECLARE
    v_seq_num NUMBER;
BEGIN
    --v_seq_num := employee_id_seq.nextval;
    dbms_output.put_line(employee_id_seq.currval);
END;