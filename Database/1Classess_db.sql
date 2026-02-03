-- Create the database
create database if not exists classess;
use classess;

-- Drop database if needed (uncomment to use)
-- DROP DATABASE classess;

-- Create table
create table students (
    student_id int auto_increment primary key,
    student_name varchar(200) not null,
    email varchar(255) not null unique,
    phone varchar(15) not null unique,
    qualification varchar(200) not null,
    grad_year year,
    dob date,
    enrolled_on date,
    age tinyint check (age >= 18),
    address text
);

-- see all columns in the tables
select * from students;

-- Data Exploration
-- see all columns and structure of the tables
describe students; -- OR desc students;

-- select particular columns from the tables
select student_name, age, qualification, grad_year from students;
/*
check output panel - 40 rows returned.
LIMIT0,1000-This is Not written by you
It is automatically added by the mysql client / GUI tool(such as Mysql Workbench)
*/
-- count no of rows in table
select * from students;

select count(*) from students;
select count(*) as count_of_students from students;

select count(student_name) as cnt from students;
select count(age) as total_rows from students;

-- check null values in age of students
select count(*) from students where age is null;
select count(*) from students where age is not null;
-- Extract data depending on certain conditions
-- checks uniques of grad-year
select distinct(grad_year) from students;
select count(distinct(grad_year)) as gradyr_total from students;

-- How many students in grad_year?
select count(*) as pass_20 from students where grad_year=2020;
select count(*) as pass_20 from students where grad_year=2021;
select count(*) as pass_20 from students where grad_year=2022;
select count(*) as pass_20 from students where grad_year=2023;
select count(*) as pass_20 from students where grad_year=2024;
select * from students;

select distinct(qualification) from students;
select count(distinct(qualification)) as quali_total from students;
select count(*) as "B.Sc" from students where qualification="B.Sc";
select count(*) as "M.Tech" from students where qualification="M.Tech";
select count(*) as "MCA" from students where qualification="MCA";
select count(*) as "B.Tech" from students where qualification="B.Tech";
select count(*) as "BCA" from students where qualification="BCA";
select count(*) as "BE" from students where qualification="BE";

-- Group BY:
/*
Row level Functions -will give 1 output for each row
Group level Functions- will take a set of rows/records
Restrication: Here we can select only those columns which are part of group by
*/

select min(age) as min_age from students;
select max(age) as max_age from students;
select avg(age) as avg_age from students;

select * from students;
-- Find the total number of students in every year
select grad_year,count(*) from students group by grad_year; 

-- Find the average age of students yearwise
select grad_year,avg(age) as avg_age from students group by grad_year;

-- Find specific columns in dataset
select student_id,student_name from students;

-- Find specific rows in dataset
select * from students limit 15;  -- Limit command

-- view only 8th row
select * from students limit 1 offset 7;

select * from students limit 1 offset 19;

select * from students limit 5 offset 7;

select * from students limit 6 offset 24;

select student_id,student_name,email from students limit 10;

select student_id,student_name,email from students limit 5 offset 35;

-- we can can calculate any mathematical expression and display it with heading
select 5+5 as result;
select 5*5 as result;
select 5=5 as result;
select 5 != 5 as result;
select 5 + null as result; -- anything add to result is always null
select 5=5 as result;