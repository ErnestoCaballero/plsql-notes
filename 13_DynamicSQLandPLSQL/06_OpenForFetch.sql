--OPEN, FOR, FETCH

--Here is an example on how to create Dynamic SQL
DECLARE
    TYPE emp_cur_type IS REF CURSOR;
    emp_cursor emp_cur_type;
    emp_record employees%rowtype;
    v_table_name VARCHAR2(20);
BEGIN
    v_table_name := 'employees';
    OPEN emp_cursor FOR 'SELECT * FROM ' || v_table_name || ' WHERE job_id = :job_id' USING 'IT_PROG';
        LOOP
            FETCH emp_cursor INTO emp_record;
            EXIT WHEN emp_cursor%notfound;
            dbms_output.put_line(emp_record.first_name || ' ' || emp_record.last_name);
        END LOOP;
    CLOSE emp_cursor;
END;
/