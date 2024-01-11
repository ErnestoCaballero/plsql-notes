CREATE OR REPLACE TYPE t_phone_number AS OBJECT (p_type VARCHAR2(10), p_number VARCHAR2(50));
/
CREATE OR REPLACE TYPE v_phone_numbers AS VARRAY(3) OF t_phone_number;
/
CREATE TABLE emps_with_phones (employee_id NUMBER,
                                first_name VARCHAR2(50),
                                last_name VARCHAR2(50),
                                phone_number v_phone_numbers);
/
SELECT * FROM emps_with_phones;
/
INSERT INTO emps_with_phones VALUES (10, 'Alex', 'Brown', v_phone_numbers(
                                                            t_phone_number('HOME','111.111.1111'),
                                                            t_phone_number('WORK','222.222.2222'),
                                                            t_phone_number('MOBILE','333.333.3333')
                                                            ));
/                                                    
INSERT INTO emps_with_phones VALUES (10, 'Catherine', 'Johns', v_phone_numbers(
                                                            t_phone_number('HOME','000.000.0000'),
                                                            t_phone_number('WORK','444.444.4444')
                                                            ));
/
SELECT e.first_name, e.last_name, p.p_type, p.p_number FROM emps_with_phones e, TABLE(e.phone_number) p;

