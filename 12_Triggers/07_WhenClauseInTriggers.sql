--WHEN CLAUSE 

--Using the UPDATE OF statement will allow you to fire the trigger when an specify column is updated
--But what is there are some more contraints such as the salary being greater than 50k

--**********************  NOTE  *********************************
--If in the WHEN clause you need to use the old or new quelifiers, you should write them without the colon signs (:)

--The benefit of the WHEN clause is the increase in performance. Since the body is not going to be executed if the boolean of the when 
--is not true
--Here's an example
CREATE OR REPLACE TRIGGER prevent_high_salary
BEFORE INSERT OR UPDATE OF salary ON employees_copy
FOR EACH ROW
WHEN (new.salary > 50000)
BEGIN
    raise_application_error(-20006, 'A salary cannot be higher than $50,000!');
END;
/

--Notice this is applicable only to ROW LEVEL TRIGGERS (Using the FOR EACH ROW clause).