## Window Functions 
/*
- It is an extension of Group Functions
- In Group we have seen 6 aggregate functions: sum(),min(),max(),count(),avg(),std()
- Row Level Function: will give one output for each row
- Group Function: will take a set of rows/records and give you one output for each group

 - When you write a Window Function, you can think of it like 
   "you are selecting data from two separate sources 
   i.e. one part selecting from Table and other part from Window
   In Window you can do Gouping of Records, Ordering of Records
   eg:
   emp_id  emp_name  salary  dep_id,  avg(sal) difference
   
   1st 4 columns selected from table, 
   avg() from window as in window we can do grouping/ordering
   
   dep_id  avg(salary)
     90      19333
      .			.
      .			.
      .			.
     110     10150 

eid  ename  sal	 	depid  avg(sal)  diff
1    Tom    20333	90		19333	 1000
2    Tim	19000	90		19333	 -333

- How to write window function?

SYNTAX OF WINDOW FUNCTION: 
function_name (expression)
OVER (
      PARTITION BY column_name
      ORDER BY column_name
     )

Where,
PARTITION BY → divides rows into groups (like GROUP BY, but keeps rows)
ORDER BY → defines row order inside each partition (sorting)
OVER() → mandatory keyword for window functions

*/
-- **********************************************************************


use learndb;

select * from myemp;

-- Display dept wise avg salary

select dep_id,avg(salary) from myemp group by dep_id order by dep_id;
-- Can we use first_name in above command? 

select FIRST_NAME,dep_id,avg(salary) from myemp group by dep_id order by dep_id;
-- will raise an error


-- So Let us write window function for that.
select emp_id,first_name,salary,dep_id,
avg(salary) OVER (PARTITION BY dep_id) as avg_salary
from myemp;

-- To Calculate difference between avg_sal and emp salary
/*
eid  ename  sal	 	depid  avg(sal)  diff
1    Tom    20333	90		19333	 1000
2    Tim	19000	90		19333	 -333*/
-- write CTE + Window function

with cte as 
(select emp_id,first_name,salary,dep_id,
avg(salary) OVER (PARTITION BY dep_id) as avg_salary
from myemp)
select *,
cte.salary-cte.avg_salary as difference from cte;


-- Q. Display emp_id,first_name,dep_id,salary,department wise max(salary)
-- in each dept only for those whose sal = max(salary)


with cte as
(select emp_id,first_name,dep_id,salary,
max(salary) OVER (PARTITION BY dep_id) as max_salary
from myemp)
select * from cte 
where
cte.salary = cte.max_salary;
-- ************************************************************************
/*
- Apart from aggregate functions, 
  there are certain functions which we can use specifically with Window Functions
- Those are: 
- rank() - will give ranks with gap in betewen if same values are present
  eg: maks 87-1st rank, 78-2nd,59-3rd,59-3rd instead of 4th,56-5th (expected was 4th),56-5th
  
- dense_rank() - will give ranks without gaps(1st 2nd 3rd 3rd 4th 4th

- lag() - It is widely used when you are calculating profits and all 
	eg. we have stock price table. Here suppose we are collecting stock price on a periodic basis
    TIME		STOCKPRICE	GAIN/LOSS			LAG(1)i.e.previous price
    JAN 2000	150			--					--
    FEB 2000	160			10 (160-150=10) 	150
    MAR 2000	140			-20 (140-160=-20)	160
    ..
    DEC 2000
  
Here, you can see as you go from 1 month to another month, how much % gain or loss is there
To calculate gain/loss we need previous month's data
Here, we can use lag() function
lag(1) -> lag of 1 period(month)
lag(2) -> lag of 2 months
  
- lead() - 
	TIME		STOCKPRICE	LEAD(1)i.e.next price
    JAN 2000	150			160			
    FEB 2000	160			148
    MAR 2000	148			152
    ..			152
    DEC 2000

- row_number() - It just gives a number to each record. 
				 Not much used in calculations
  */    

-- execute commands from employeesoffices script to create marks table in learndb

select * from marks;

select * from marks order by mark desc;

-- 1. RANK(): Same values get the same rank
--         Next rank is skipped (this is the key behavior)

select *,
RANK() OVER (ORDER BY mark desc) as rnk 
from marks;

-- 2. DENSE_RANK(): assigns a rank to rows without skipping numbers, 
--              even when there are ties
--              Same values → same rank
--              No gaps in ranking


select *,
DENSE_RANK() OVER (ORDER BY mark desc) as rnk 
from marks;

-- Refer myemp table
-- Q1. Find person who gets the 3rd highest salary in the company.

select *,
DENSE_RANK() OVER (ORDER BY salary desc) as rnk 
from myemp;

-- 3rd highest salary = all those whose rnk = 3
-- It can be solved using cte


with cte as 
(select *,DENSE_RANK() OVER (ORDER BY salary desc) as rnk from myemp)
select * from cte where rnk = 3;


-- Q2. Find 2nd person who joined company

with cte as 
(select *,DENSE_RANK() OVER (ORDER BY hire_date) as rnk from myemp)
select * from cte 
where rnk = 2;

-- Q3. Find employee who joined 1st in each department in company
-- Let us solve this in 2 parts
-- Part 1: Only do grouping and apply rank

select *,
DENSE_RANK() OVER (PARTITION BY dep_id ORDER BY hire_date) as rnk 
from myemp;

-- Now from this output we want all those records where rnk = 1

with cte as 
(select *,DENSE_RANK() OVER (PARTITION BY dep_id ORDER BY hire_date) as rnk from myemp)
select * from cte
where rnk = 1;


-- 3. ROW_NUMBER(): assigns a unique sequential number to each row.
--               Always increments by 1
--               Even if values are same, row numbers are different

-- Q4. Assign row numbers to all records of marks table

select *, 
ROW_NUMBER() OVER (ORDER BY mark) as rnk 
from marks;


-- 4.LEAD(): Lag() and Lead() let you access values from another row 
--          without using a self-join.
--          LEAD() → looks at a next row
-- Refer trains_learndb table on create trains table

select * from trains;

-- Q5. Find out journey time between stations.
-- eg. 110 train starts from San Francisco and reaches to Redwood City in 54 minutes and so on
-- use lead(time,1)
-- Required output is: 
-- Train_id  Station  Time  Nxt_StaTime
-- 110       SF       10:00  10:54
--           RC       10:54  11:02

select *, 
LEAD(time,1) OVER (PARTITION BY train_id ORDER BY time) as Nxt_StaTime 
from trains;

-- 5. LAG(): looks at a previous row

-- Q.6 To see previous time in the above command use lag()

 select *, 
LAG(time,1) OVER (PARTITION BY train_id ORDER BY time) as Prev_StaTime 
from trains;

-- Find next station time
select *,
LEAD(time,1) OVER (PARTITION BY train_id ORDER BY time) as Next_StaTime
from trains;


-- Q7. Find out journey time
-- Expected output is:
-- train_id  station  time  Nxt_StaTime Journey_time
-- 110       SF       10:00  10:54      54
-- 110       RC       10:54  11:02      08   and so on

-- use lead() and subtime() to find time difference

with cte as
(select *, LEAD(time,1) OVER (PARTITION BY train_id ORDER BY time) as Nxt_StaTime
from trains)
select *, subtime(Nxt_StaTime,time) as journey_time from cte;







## Value function/ Analytic function. Try as a home work
-- ntile() >> divides an ordered result set into n equal part
-- first_value() >> first row's value in window
-- Last_value() >> last  row's value in wondow, Need to create a frame
-- nth_value() >> nth row's value in window, Need to create a frame

-- ********************************************************************
-- NTILE(n): Divides ordered rows into n buckets
-- Divide rows in 3 parts, sort as per salary

select *,
ntile(3) over (order by salary desc) as salary_group
from myemp;

-- Find how many employees are there in salary_group no. 1


with cte as (SELECT first_name, salary,
       NTILE(3) OVER (ORDER BY salary DESC) AS salary_group
FROM myemp) select count(*) from cte where salary_group=1;

-- *************************************************************
-- FIRST_VALUE(): Returns first row’s value in the window in each row
-- Find Highest salary in each department and display with employee
SELECT first_name, dep_id, salary,
       FIRST_VALUE(salary) OVER (
           PARTITION BY dep_id
           ORDER BY salary DESC
       ) AS rnk
FROM myemp;

-- ********************************************************************
-- LAST_VALUE(): Returns last row’s value in the window in each row
-- Need to add following line to define a window frame
-- ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
-- It defines window frame i.e. it says:
-- For each row, look at all rows in this partition, from the very first row to the very last row.
-- Find Lowest salary in each department and display with employee


SELECT first_name, dep_id, salary,
       LAST_VALUE(salary) OVER (
           PARTITION BY dep_id
           ORDER BY salary DESC
           ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
       ) AS lowest_salary
FROM myemp;

-- ************************************************************************
-- NTH_VALUE(): Returns nth row’s value in the window (window is grouping)
-- Find 2nd highest salary in each department
-- Need to add following line to define a window frame
-- ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
-- Without CTE we can execute it


SELECT first_name, dep_id, salary,
       NTH_VALUE(salary, 2) OVER (
           PARTITION BY dep_id
           ORDER BY salary DESC
           ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
       ) AS second_highest_salary
FROM myemp;
