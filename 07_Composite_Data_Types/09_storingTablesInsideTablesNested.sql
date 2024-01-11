CREATE OR REPLACE TYPE t_phone_number AS OBJECT (p_type VARCHAR2(10), p_number VARCHAR2(50));
/
CREATE OR REPLACE TYPE n_phone_numbers AS TABLE OF t_phone_number;
/
DROP TABLE emps_with_phones2;
CREATE TABLE emps_with_phones2 (employee_id NUMBER,
                                first_name VARCHAR2(50),
                                last_name VARCHAR2(50),
                                phone_number n_phone_numbers)
                                NESTED TABLE phone_number STORE AS phone_number_table;
/
SELECT * FROM emps_with_phones2;
/
INSERT INTO emps_with_phones2 VALUES (10, 'Alex', 'Brown', n_phone_numbers(
                                                            t_phone_number('HOME','111.111.1111'),
                                                            t_phone_number('WORK','222.222.2222'),
                                                            t_phone_number('MOBILE','333.333.3333')
                                                            ));
/                                                    
INSERT INTO emps_with_phones2 VALUES (11, 'Catherine', 'Johns', n_phone_numbers(
                                                            t_phone_number('HOME','000.000.0000'),
                                                            t_phone_number('WORK','444.444.4444')
                                                            ));
/
INSERT INTO emps_with_phones2 VALUES (12, 'Bruce', 'Lee', n_phone_numbers(
                                                            t_phone_number('HOME','000.000.0000'),
                                                            t_phone_number('WORK','444.444.4444'),
                                                            t_phone_number('WORK2','444.444.4444'),
                                                            t_phone_number('WORK3','444.444.4444'),
                                                            t_phone_number('WORK4','444.444.4444')
                                                            ));
/
UPDATE emps_with_phones2 SET phone_number = n_phone_numbers(t_phone_number('HOME','000.000.0000'),
                                                            t_phone_number('WORK','444.444.4444'),
                                                            t_phone_number('WORK6','444.444.4444'),
                                                            t_phone_number('WORK7','444.444.4444'),
                                                            t_phone_number('WORK8','444.444.4444')
                                                            )
                                                            WHERE employee_id=11
/
SELECT e.first_name, e.last_name, p.p_type, p.p_number FROM emps_with_phones2 e, TABLE(e.phone_number) p;
/
DECLARE
    p_num n_phone_numbers;
BEGIN
    SELECT phone_number INTO p_num FROM emps_with_phones2 WHERE employee_id = 11;
    p_num.extend;
    p_num(6) := t_phone_number('FAX','999.999.9999');
    UPDATE emps_with_phones2 SET phone_number = p_num WHERE employee_id=11;
END;
    