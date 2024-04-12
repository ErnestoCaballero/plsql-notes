BEGIN <<outer>>
    DECLARE
      v_text VARCHAR(50) := 'Out-text';
    BEGIN
      DECLARE
        v_text VARCHAR(30) := 'In-text';
      
      BEGIN
        dbms_output.put_line('inside_inner -> ' || v_text);
        dbms_output.put_line('inside_outer -> ' || outer.v_text);
      END;
      
      dbms_output.put_line(v_text);
    END;
END outer;