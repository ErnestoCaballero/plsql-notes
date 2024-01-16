--We had out PRINT procedure as follow:
CREATE OR REPLACE PROCEDURE PRINT(text IN VARCHAR2) IS
BEGIN
    dbms_output.put_line(text);
END;
/

--However, like that it would fetch an error when trying to use it without a parameter

BEGIN
    print(); --will provoke an exception PLS-00306: wrong number or types of arguments in call to 'PRINT'
END;
/

--To solve for that case, we should add a DEFAULT value for when there are no parameters added
CREATE OR REPLACE PROCEDURE PRINT(text IN VARCHAR2 DEFAULT 'This is the print procedure!') IS
BEGIN
    dbms_output.put_line(text);
END;
/

--Not let's create a procedure to add a new job to the jobs table
CREATE OR REPLACE PROCEDURE add_job(job_id VARCHAR2, job_title VARCHAR2,
                                    min_salary NUMBER DEFAULT 1000, max_salary NUMBER DEFAULT NULL) IS
BEGIN
    INSERT INTO jobs VALUES (job_id,job_title, min_salary, max_salary);
    print('The job: ' || job_title || ' is inserted!');
END;
/

--We would execute it, for instance, like this:
EXEC add_job('IT_DIR','IT Director',5000,20000);
/

--Notice that we made the max_salary to not be mandatory and have a DEFAULT value of null, which will allow us
--to insert jobs with no max salary as in using just the first three parameters
EXEC add_job('IT_DIR2','IT Director',5000);
/

--We did the same for the min salary, but instead of null we defaulted to 1000. That will allow us to use only two parameters as in:
EXEC add_job('IT_DIR3','IT Director');
/

--To not rely on the position parameter to assing to a procedure, you can use named notation. 
--That is to specify to which parameter name is the value going to be set. Example:
EXEC add_job('IT_DIR5','IT Director', max_salary => 10000);
--Use the max_salary => <<amount>> notation
/


