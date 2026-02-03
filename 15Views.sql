/*
DATABASE OBJECT: VIEWS
View is a virtual table. It takes minimal space in memory.
Think of it as a saved SELECT statement.
Suppose myemp table has 15 columns and you want randomly any 3 columns from it, you can create a view
having only those 3 columns. So view is called 'Window on data'.
Then you don't need to write qurey everytime by selecting those 3 column names.
Instead you can write: select * from viewname;    

SYNTAX: 
CREATE VIEW view_name AS
SELECT column1, column2
FROM table_name
WHERE condition;        */

use learndb;
show tables;
select * from myemp limit 10;
-- now select 1st 3 columns, job_id and salary,dep_id in a view


create view myview as 
select emp_id,first_name,last_name,job_id,salary,dep_id
from myemp;

select * from myview;

select * from myview limit 10;


-- When there is a very big query or complex query, 
-- then instead of typing it again & again we can create a view.
-- OR when you need to extract particular columns frequently, create a view of those columns

-- Let us write a big left join query
select * from movies;
select * from members;

select mv.title,mm.first_name,mm.last_name 
from movies as mv left join members as mm
on mv.id = mm.movieid;

-- Suppose in this output I want to do some formatting
-- Put '--' in place of NULL in the output
-- For this we have a function called 'ifnull()'

select mv.title,ifnull(mm.first_name,'----'),ifnull(mm.last_name,'----')
from movies as mv left join members as mm
ON mv.id = mm.movieid;

-- check last 2 column names. Change it to fname and lname



select mv.title,
ifnull(mm.first_name,'--') as fname,
ifnull(mm.last_name,'--') as lname
from movies as mv left join members as mm
ON mv.id = mm.movieid;


-- Now for the above query write a view named 'rentals'


create view rentals as
select mv.title,
ifnull(mm.first_name,'--') as fname,
ifnull(mm.last_name,'--') as lname
from movies as mv left join members as mm
ON mv.id = mm.movieid;

select * from rentals;

-- Thus view is just a convenience feature which makes your life easier
-- Query becomes compact and clean
-- Let us create a simple view

select * from authors;
-- put all the records in a view with authorid <15



create view aview as 
select * from authors where authorid<15;

select * from aview; 

-- You can execute all queries(delete,update,etc.) on view that you can execute on a table.
-- One more reason to create a view:
-- If you want to restrict access to data.

-- Suppose we have emp table where you see details of emloyees from all the departments
-- Here we can create a view
-- eg. we will create a view say 'dep60' 
-- where I will select details from employees who belong to department 60 only.

-- Then permission will be given to dept 60 employees  to the view 'dep60' only 
-- They will not be able to see or modify data from other departments

-- Let us try to insert a record through the view

select * from aview;
-- If I try to insert authorid=20 will it allow?

-- check columns of authors table

select * from authors;

-- Actually it should not allow as condition for view is given as authorid<15
insert into aview values(20,'John Hamm');


select * from aview; -- only 6 records

select * from authors; -- new record is inserted in authors and not in aview


-- Table is a room and view is a window
-- Record will be stored in room and not in window
-- Here insertion was possible but actually it is not a good thing

-- Why view was created?
-- Because only dept 60 employees should extract or update data
-- Here, in aview what is happening?
-- It is allowingexperienceexperience you to insert records even if it violates the condition (authorid<15)
-- Based on that condition only view is created
-- i.e. people from other department can't see data 
-- but they can insert, delete or update data from dept60

-- Delete the record from authors table where authoid = 20 through a view 

delete from aview where authorid = 20;

select * from aview;

select * from authors;
delete from authors where authorid = 20;
select * from authors;

-- Record is not deleted as: A view can only DELETE rows that are visible through the view

-- Can we insert a record where autorid is < 15

insert into aview values(9,'Amit');

select * from aview;

select * from authors;

-- TO PREVENT INSERTION of VIOLATED RECORDS:
-- While creating view, give 'WITH CHECK OPTION'
-- Then view will not allow to insert, update or delete anything if it violates the view condition
-- i.e. we can not add any record whose authorid>=15

-- Drop aview first and then recreate it 

drop view aview;

create view aview as
select * from authors where authorid<15 WITH CHECK OPTION;

select * from aview;


insert into aview values(20,'John Hamm'); -- can't add

insert into aview values(14,'Tom Cruise'); -- added
select * from authors;
select * from aview;

insert into aview values(13,'John Hamm'); -- query ok
select * from aview;
select * from authors;

delete from authors where authorid=13;
select * from aview; 
select * from authors;

delete from authors where authorid=1;
delete from authors where authorid=14;

select * from aview; 
select * from authors;

/* Updatable View

As long as you create a view by taking columns directly from table as it is,
your view will be an updatable view i.e. insert, update, delete is possible through view.
But if you have anything special in your select command, you can create view 
but you can't insert data using view. 
i.e. if you have derived columns, distinct, having, group by, aggregate functions, joins in
your view command you can't insert/update/delete using view. You can only create view to visualize it.
*/

-- *************************************************************************************

use learndb;
select * from myemp;


create view dep_90 as (
select * from myemp
where dep_id= 90);

select * from dep_90;

-- updateable view
-- change depid 90 to 1000 through view


update dep_90 set dep_id = 1000
where dep_id = 90;

set sql_safe_updates = 0;

update dep_90 set dep_id = 1000
where dep_id = 90;

select * from dep_90;

select * from myemp;

-- change depid 1000 to 90 again through myemp table

update myemp set dep_id = 90
where dep_id = 1000;

select * from myemp;
select * from dep_90;

-- non updateable view
create view dep_80 as (select * from myemp
where dep_id= 80) with check option;

select * from dep_80;

update dept_80 set dep_id= 8000
where dep_id= 80;

--  Error Code: 1369. CHECK OPTION failed 'learndb.dept_80'

-- drop views
drop view dep_90;

drop view dep_80;
