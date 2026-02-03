/*

STORED PROCEDURE
- 2 Types of variables:
  Parameters or arguments: used to pass values to stored procudures, functions
  Local Variable: It is the one that you declare within BEGIN and END
  It is available within that block only
  When procedure ends, variable also dies
  Local variables need to be declared
  SYNTAX to declaring a local variable:
  
  "Declare x integer default 0;"
  
- Why do we need local variables?
  To store intermediate results
  eg. def avg(x1 x2 x3):
         total=x1 + x2 + x3
         avg = total/3 
  Local variables are: total,avg
  
 - Main reason of local variable is: 
-  you can not take out value of a column outside the select command.
 
 - what is the syntax of select command in mysql?
 - select col_name from table_name;
 
 - select authorid as author;  
 - This line is like print() statement only 
 - and not a select command as No 'From' keyword is there.
 
 - select authorid from books where bookid=authorid; This is actual mysql select command.
 - When you take authorid out from actual query, mysql does not understand what authorid is
 - When authorid is a part of select command, 
   mysql understands that it is coming from books table. 
   and authorid is a column in books table.
 - But when you take out from select command and put it in print command, 
   mysql does not understand it.
   Therefore any column can not be taken out of select command
   
 - Solution:
 - When you select any value, store it in a local variable
 - "Select authorid from books where bookid=bid;"
   and then use that local variable at different place
   eg: "select authorid into x from books where bookid = bid;
       select x as author;"
       
SYNTAX: 
CREATE PROCEDURE procedure_name ()
BEGIN
    SQL statements;
END;
*/

-- Q1. Create 1st procedure proc1 to display all records from books table
/*
CREATE PROCEDURE `proc1`()
BEGIN
select * from books;
END
*/

-- To execute this procedure:
-- a. right click on procedure name and click lightning icon
-- b. call procedure_name();

call proc1();

-- To delete the procedure:
-- a. right click on procedure name and click Drop Stored Procedure
-- b. drop procedure procedure_name;
drop procedure proc1;

-- Q2. Display Hello using a procedure
/*
CREATE PROCEDURE `hello`()
BEGIN
select "Hello" as Message;
END
*/

call hello();
select * from books;
-- Q3. Display all the books whose bookid is 5
/*
CREATE PROCEDURE `proc1`()
BEGIN
select * from books where bookid = 5;
END
*/

call proc1();

-- Q4. Display all the books whose bookid is 6 or 7
-- Now everytime instead of making changes in program 
-- we can pass argument to the procedure.
-- how to do this?

/*
CREATE PROCEDURE `myproc` (bid integer)
BEGIN
select * from books where bookid = bid;
END
*/

call myproc(5);
-- ***************************************************************
-- LOCAL VARIABLE:

select * from books;

-- Q5. Display the Title of book whose bookid is passed as an argument
-- with a message: "Title of book bid is: book_name" as output


/*
CREATE PROCEDURE `proc_author`(bid integer)
BEGIN
declare bk_title varchar(100);
select title into bk_title from books where bookid = bid;

select (concat("Title of book ", bid, " is: ",bk_title)) as BookTitle;
END
*/

call proc_author(8);

-- **********************************************************************
-- Conditional Statement in Stored Procedure
/*
SYNTAX:
BEGIN
if condition then
    statement
elseif condition then
    statement
else
    statement
end if;
END
*/

-- Q6. Write a procedure to display wheter a given number is positive, negative or zero

/*
CREATE PROCEDURE `proc_if` (num integer)
BEGIN
if num > 0 then
	select 'Positive' as Result;
elseif num = 0 then
	select 'It is Zero' as Result;
else 
	select 'Negative' as Result;
end if;
END
*/

call proc_if(9);

-- Q7. In above code output display message as: "Number is Positive"
-- What change you need to do? 
-- use select(concat())


/*
CREATE PROCEDURE `proc_if`(num integer)
BEGIN
if num > 0 then
	select (concat(num,' is ','Positive')) as Result;
elseif num = 0 then
	select (concat(num,' is ','Zero')) as Result;
else 
	select (concat(num,' is ','Negative')) as Result;
end if;
END
*/