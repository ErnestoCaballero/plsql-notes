--FIRST CASE:
--Triggers are often used to assign a sequence for a primary key in a table
--So that someone who inserts a value will always get a new incremented primary_key for the record

--First let's create the SEQUENCE object
DROP SEQUENCE seq_dep_cpy;
CREATE SEQUENCE seq_dep_cpy
START WITH 290
INCREMENT BY 10;
/
--We checked last value in departments_copy table, so we START WITH 290
--Now we create a TRIGGER using the sequence
CREATE OR REPLACE TRIGGER trg_before_insert_dept_cpy
BEFORE INSERT ON departments_copy
FOR EACH ROW
BEGIN
    --SELECT seq_dep_cpy.NEXTVAL INTO :new.department_id FROM dual;
    :new.department_id := seq_dep_cpy.NEXTVAL;
END;
/

--When inserting a value, the department_id will be filled automatically by the TRIGGER
INSERT INTO departments_copy (department_name, manager_id, location_id)
VALUES ('Security',200, 1700);


--SECOND CASE:
--Create a Log table to track al DML operations

--Let's say I want to track the DMLs in departments_copy table. I first want to know the types it is composed
DESCRIBE departments_copy;
/

--Now create the logging table
CREATE TABLE log_departments_copy (
    --Include the user which made the DML
    LOG_USER VARCHAR2(30),
    --The date the DML was performed
    log_date DATE,
    --What operation was performed
    DML_TYPE VARCHAR2(10),
    old_department_id NUMBER(4),
    new_department_id NUMBER(4),
    old_department_name varchar2(30),
    new_department_name VARCHAR2(30),
    old_manager_id NUMBER(6), 
    new_manager_id NUMBER(6),
    old_location_id NUMBER(4),
    new_location_id NUMBER(4)
);
/

--Now we create the trigger which will keep track
CREATE OR REPLACE TRIGGER trg_departments_copy_log
AFTER INSERT OR UPDATE OR DELETE ON departments_copy
FOR EACH ROW
DECLARE
    v_dml_type VARCHAR2(10);
BEGIN
    --Defining the DML operation that was executed and putting it into the v_dml_type variable declared
    IF INSERTING THEN
        v_dml_type := 'INSERT';
    ELSIF UPDATING THEN
        v_dml_type := 'UPDATE';
    ELSIF DELETING THEN
        v_dml_type := 'DELETE';
    END IF;
    
    INSERT INTO log_departments_copy VALUES
        (USER, SYSDATE, v_dml_type,
        :old.department_id, :new.department_id,
        :old.department_name, :new.department_name,
        :old.manager_id, :new.manager_id,
        :old.location_id, :new.location_id);
END;
/

--Finally perform some dml operations 
INSERT INTO departments_copy (department_name, manager_id, location_id) VALUES ('Cyber SEcurity', 100, 1700);
/
UPDATE departments_copy SET manager_id=200 WHERE department_name='Cyber SEcurity';
/
DELETE FROM departments_copy WHERE department_name='Cyber SEcurity';
/

--And query the log table to see the results
SELECT * FROM log_departments_copy;
/