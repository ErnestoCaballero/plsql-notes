--INSTEAD OF TRIGGERS

--They are used to apply some DML statements on UN-Updateable views
--So, to take into account:
--Are used only with the views
--Generally used for the complex views
--If the view has a check option, it won't be enforced
CREATE OR REPLACE TRIGGER emp_datails_vw_dml
INSTEAD OF INSERT OR UPDATE OR DELETE ON vw_emp_details
FOR EACH ROW
DECLARE
    v_dept_id PLS_INTEGER;
BEGIN
    IF INSERTING THEN
        SELECT MAX(department_id) + 10 INTO v_dept_id FROM departments_copy;
        INSERT INTO departments_copy VALUES (v_dept_id, :NEW.dname, NULL, NULL);
    ELSIF DELETING THEN
        DELETE FROM departments_copy WHERE UPPER(department_name) = UPPER(:OLD.dname);
    ELSIF UPDATING('DNAME') THEN
        UPDATE departments_copy SET department_name = :NEW.dname
        WHERE UPPER(department_name) = UPPER(:OLD.dname);
    ELSE
        raise_application_error(-20007, 'You cannot update any data other than department_name!');
    END IF;
END;
/
--Same example but with one difference I still need to find which makes it compile haha

CREATE OR REPLACE TRIGGER EMP_DETAILS_VW_DML
  INSTEAD OF INSERT OR UPDATE OR DELETE ON VW_EMP_DETAILS
  FOR EACH ROW
  DECLARE
    V_DEPT_ID PLS_INTEGER;
  BEGIN
  
  IF INSERTING THEN
    SELECT MAX(DEPARTMENT_ID) + 10 INTO V_DEPT_ID FROM DEPARTMENTS_COPY;
    INSERT INTO DEPARTMENTS_COPY VALUES (V_DEPT_ID, :NEW.DNAME,NULL,NULL);
  ELSIF DELETING THEN
    DELETE FROM DEPARTMENTS_COPY WHERE UPPER(DEPARTMENT_NAME) = UPPER(:OLD.DNAME);
  ELSIF UPDATING('DNAME') THEN
    UPDATE DEPARTMENTS_COPY SET DEPARTMENT_NAME = :NEW.DNAME
      WHERE UPPER(DEPARTMENT_NAME) = UPPER(:OLD.DNAME);
  ELSE
    RAISE_APPLICATION_ERROR(-20007,'You cannot update any data other than department name!.');
  END IF;
END;
