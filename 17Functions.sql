/*
## FUNCTIONS

Functions are meant to be short and sweet. 
- Function should return a single value

eg: year() function (readymade function) is applied on all rows of myemp table. 
It extract only year from date
"select hire_date,year(hire_date) from myemp limit 10;"

- User defined Functions are created in the same way as procedures are created.
- Let us write experience() function.
 
Question 1:
How to calculate experience given any employee whose eid is known?
For given eid, take hire_date
From that extract year
Take today's date and extract year from today's date
Find difference of both dates [year(now()) - year(hire_date)]
						  OR  [year(current_date()) - year(hire_date)]
You will get experience

After creating function, while executing it you may get error.
So execute following code:

"SET GLOBAL log_bin_trust_function_creators = 1;"

This command is used: To relax the preceding conditions on function creation 
(that you must have the SUPER privilege and 
that a function must be declared deterministic or to not modify data), 
set the global log_bin_trust_function_creators system variable to 1.
*****************************************************************************************************

/*
CREATE FUNCTION `experience` (eid integer)
RETURNS INTEGER
BEGIN
declare exp integer default 0;
select year(now()) - year(hire_date) into exp
from myemp
where emp_id = eid;
RETURN exp;
END
*/

-- if Error: 
SET GLOBAL log_bin_trust_function_creators = 1;

-- Call experience() function in a query

select emp_id, first_name, hire_date,
experience(emp_id) as exp 
from myemp;


-- Display only those employees whose experience is less than 15 years

select emp_id, first_name, hire_date,
experience(emp_id) as exp 
from myemp
where experience(emp_id) < 15;


/*
DIFFERENCE BETWEEN STORED PROCEDURE AND FUNCTION

				STORED PROCEDURE					FUNCTION
1.How to call- call myproc()					1.Call it as part of command. It is not called separately
  if required pass parameter name in bracket	  select.....,experience(eid)...
2. You can write big code						2. You have to keep short and to the point code

*/

-- **************************************************************************************
-- Bonus Calculation. Myemp table
-- if sal>=15000 bonus is 20% on salary else 10%


/*
CREATE  FUNCTION `bonus_calc`(sal decimal(10,2)) RETURNS int
BEGIN
declare bonus decimal(10,2);
 IF sal >= 15000 THEN
        SET bonus = sal * 0.20;
ELSE
        SET bonus = sal * 0.10;
 END IF;

 RETURN bonus;
END
*/

SELECT
    first_name,
    salary,
    bonus_calc(salary) AS bonus
FROM myemp;