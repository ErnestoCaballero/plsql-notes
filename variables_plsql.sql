VARIABLE var_sql NUMBER;

BEGIN
  :var_sql := '100';
  dbms_output.put_line('valor de var_sql: ' || :var_sql);
END;
/
SELECT * FROM employees WHERE employee_id = :var_sql;


VARIABLE var_text VARCHAR2(30);

DECLARE
  v_text VARCHAR2(30);
BEGIN
  v_text := 'Hello PL/SQL';
  :var_text := v_text;
  dbms_output.put_line(v_text);
  dbms_output.put_line(:var_text || ' binded');

END;
/
print var_text;

SET SERVEROUTPUT ON;
SET AUTOPRINT OFF;

variable var_text VARCHAR2(30);
VARIABLE var_number NUMBER(30);

DECLARE
  v_text VARCHAR2(30);
BEGIN
  :var_text := 'Hello PL/SQL';
  :var_number := 20;
  v_text := :var_text;
  --dbms_output.put_line(v_text);
  --dbms_output.put_line(:var_text);
END;
/
print var_text;