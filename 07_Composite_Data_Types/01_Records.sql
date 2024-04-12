--Records

--Using basic example of records by creating a record using the syntax r_emp employees%rowtype

DECLARE
    r_emp employees%rowtype;
BEGIN
    SELECT * INTO r_emp
    FROM employees
    WHERE employee_id = '101';
    
    dbms_output.put_line(r_emp.first_name || ' ' || r_emp.last_name || ' earns ' || r_emp.salary || ' and was hired at: ' || r_emp.hire_date);
END;
/

--Assume that now I just want a few of the columns in the employees table
--I would first create a TYPE
--with that TYPE I'll create a RECORD to use in the block

DECLARE
    TYPE t_emp IS RECORD (first_name VARCHAR2(50),
                        last_name employees.last_name%type,
                        salary employees.salary%type,
                        hire_date date);
                        
    r_emp t_emp; --IMPORTANT (once you have the TYPE (t_emp), you need to create de RECORD (r_emp) in order to use it in the block) whici is like saying my_var NUMBER / r_emp t_emp
BEGIN
    SELECT first_name, last_name, salary, hire_date INTO r_emp FROM employees WHERE employee_id = '101';
    
    dbms_output.put_line(r_emp.first_name || ' ' || r_emp.last_name || ' earns ' || r_emp.salary || ' and was hired at: ' || r_emp.hire_date);
END;
/

--RECORDS AND TYPES
--More complex example. For creating a complex RECORD you can create a Complex TYPE
--Here I create the TYPE t_edu that holds VARCHARS
--Then I create the TYPE t_emp that would have also the t_edu TYPE
--It is also worth mentioning that t_emp holds a department RECORD as well. department departments%rowtype
DECLARE

    TYPE t_edu IS RECORD (primary_school VARCHAR2(100),
                        high_school VARCHAR2(100),
                        university VARCHAR2(100),
                        uni_graduate_date DATE
                        );
                        
    TYPE t_emp IS RECORD (first_name VARCHAR2(50),
                        last_name employees.last_name%type,
                        salary employees.salary%type NOT NULL DEFAULT 1000,
                        hire_date DATE,
                        dept_id employees.department_id%type,
                        department departments%rowtype,
                        education t_edu
                        );
                        
    r_emp t_emp; --Initialize the RECORD with the TYPE

BEGIN

    --Populate the t_emp record up to the dep_id value
    SELECT first_name, last_name, salary, hire_date, department_id --select just the columns in the t_emp RECORD
    INTO r_emp.first_name, r_emp.last_name, r_emp.salary, r_emp.hire_date, r_emp.dept_id
    FROM employees
    WHERE employee_id = '146';
    
    --populate the department record inside the t_emp record
    SELECT * INTO r_emp.department
    FROM departments 
    WHERE department_id = r_emp.dept_id;
    
    --assign manually values for education RECORD of TYPE t_edu
    r_emp.education.high_school := 'Beverly Hills';
    r_emp.education.university := 'Oxford';
    r_emp.education.uni_graduate_date := '01-JAN-13';

    --Accessing the values with print
    dbms_output.put_line(r_emp.first_name || ' ' || r_emp.last_name || ' earns ' || r_emp.salary ||
                        ' and hired at: ' || r_emp.hire_date);
    
    dbms_output.put_line('She graduated from ' || r_emp.education.university || ' at ' || r_emp.education.uni_graduate_date);
    
    dbms_output.put_line('Her department name is: ' || r_emp.department.department_name);
END;
/


