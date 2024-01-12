DECLARE
    CURSOR c_rates IS SELECT * fROM tmp_rates_service_401315578 tmp;
    v_rates tmp_rates_service_401315578%rowtype;
    v_count NUMBER := 1;
    
BEGIN
    OPEN c_rates;
    LOOP 
        FETCH c_rates INTO v_rates;
        EXIT WHEN c_rates%NOTFOUND;
        dbms_output.put_line('Count ' || v_count || '. rc_rate_Seq_no: ' || v_rates.rc_rate_seq_no || ' | service_Receiver_id: ' 
                            || v_rates.service_Receiver_id || ' | charge_code: ' || v_rates.charge_code || ' | amount: ' || v_rates.amount);
        v_count := v_count + 1;
        
        --Transform or perform calculations
        IF v_rates.charge_code LIKE '%15' THEN
            v_rates.amount := 1;
        ELSIF v_rates.charge_code LIKE '%21' THEN
            v_rates.amount := 2;
        ELSE
            v_rates.amount := 0;
        END IF;
        
        UPDATE tmp_rates_service_401315578 SET amount=v_rates.amount WHERE rc_Rate_seq_no=v_rates.rc_rate_Seq_no;
    END LOOP;
    CLOSE c_rates;
    
    dbms_output.put_line(' - ');
    
    v_count := 0;
    FOR i IN c_rates LOOP
        dbms_output.put_line('Count ' || v_count || '. rc_rate_Seq_no: ' || i.rc_rate_seq_no || ' | service_Receiver_id: ' 
                    || i.service_Receiver_id || ' | charge_code: ' || i.charge_code || ' | amount: ' || i.amount);
        v_count := v_count - 1;
    END LOOP;
    
END;
/
