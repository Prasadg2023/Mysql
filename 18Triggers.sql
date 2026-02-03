/*
TRIGGERS
Unlike stored procedures and Functions, we don't explicitly call Trigger.

- Triggers are fired in response to events
- Events can be any DML commands (Insert,Update,Delete)

- Whenever insert cmd is executed, the trigger associated with it is fired
- When we say that any DML cmd is executed, 
- trigger associated with it gets executed at that time
- It may first do insert operation & then trigger code gets executed or vice-versa
- So depending on this we have 2 types of triggers
1. Before Trigger
2. After Trigger

What all Triggers are possible on a table?
We can have:
1. Before Insert Trigger i.e. 1st Trigger executes then insert cmd executes
2. After Insert Trigger i.e. 1st Insert cmd executes then trigger executes
3. Before Update Trigger
4. After Update Trigger
5. Before Delete Trigger
6. After Delete Trigger
*******************************************************************************
2 Types of Triggers are available:
- Row Level Trigger: When we are executing any DML query,
  that command can affect multiple rows at a time depending upon where clause
  
  eg: "Update books where course is null;"
  
  Suppose in books table there are 4 records where course is null
  IMP: Row level trigger will be applied once For Each Row.
- Statement level trigger: will be executed only once irrespective of total no. of rows affected
       
       At the moment mysql does not support statement level trigger
       
- Before trigger values are accessed using "old." keyword
- After trigger values are accessed using "new." keyword


*/

select * from books;
-- we will add one column 'sales in books table.

alter table books 
add column sales integer 
default 0;

select * from books;


desc book_sales;

-- we will add an entry in this table through trigger.
-- bookid=5, title=Night Without End, qty_sold=5, tos=now()
-- So, whenever an update happens we want to write a trigger.

select * from book_sales; -- no records

-- *********************************************************
## WRITING TRIGGER:

-- triggers are always written on tables; 
-- Whenever any DML command is exeuted on books table,
-- because of trigger values will be automatically updated in book_sales table
-- Values will be: how many copies of a particular book has been sold till now.

-- Let us add AFTER UPDATE TRIGGER ON BOOKS TABLE
-- Right click on books table
-- write trigger to insert values in book_sales table.

/*
CREATE TRIGGER `books_AFTER_UPDATE` AFTER UPDATE ON `books` FOR EACH ROW BEGIN
insert into book_sales (bookid,title,qty_sold,tos)
values(old.bookid,old.title, new.sales - old.sales,now());
END
*/

-- Now if we buy 3 copies of bookid=6 we have to update books table

update books
set sales = sales + 3 
where bookid = 6;

select * from books;

-- check book_sales table

select * from book_sales; 
-- 1 record is inserted successfully

-- add one more entry in books table

update books
set sales = sales + 5 
where bookid = 11;

select * from books;

select * from book_sales;

-- 3 copies of bookid=11 are sold out
update books
set sales = sales + 3 
where bookid = 11;

select * from books;
select * from book_sales;


/*
To Conclude:
  Command		Before										After
1. Update		Values can be accessed using 'old.'			Values can be accessed using 'new.'
   [For update for a particular record we have previous state and next state]

2. Insert		We don't have any before value				Only call 'new.'

3. Delete		Only have 'old.'							After deleting there is no record

****************************************************************************
*/

drop trigger books_AFTER_UPDATE;



