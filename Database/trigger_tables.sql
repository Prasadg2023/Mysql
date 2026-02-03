create database mini_mart;
use mini_mart;
## Step 1 Create table
-- Customers Table
CREATE TABLE Customers (
CustomerID INT PRIMARY KEY,
Name VARCHAR(50),
Email VARCHAR(50)
);

-- Inventory Table
CREATE TABLE Inventory (
ProductID INT PRIMARY KEY,
ProductName VARCHAR(50),
Stock INT,
Price DECIMAL(10,2)
);

-- Orders Table
CREATE TABLE Orders (
OrderID INT PRIMARY KEY,
CustomerID INT,
OrderDate DATE,
FOREIGN KEY (CustomerID) 
REFERENCES Customers(CustomerID)
);

-- OrderDetails Table
CREATE TABLE OrderDetails (
OrderDetailID INT PRIMARY KEY,
OrderID INT,
ProductID INT,
Quantity INT,
FOREIGN KEY (OrderID) 
REFERENCES Orders(OrderID),
FOREIGN KEY (ProductID) 
REFERENCES Inventory(ProductID)
);

## Step 2 Add values
## Add value
-- Customers
INSERT INTO Customers VALUES (1, 'Alice', 'alice@email.com');
INSERT INTO Customers VALUES (2, 'Bob', 'bob@email.com');
INSERT INTO Customers VALUES (3, 'Charlie', 'charlie@email.com');

-- Inventory
INSERT INTO Inventory VALUES (101, 'Milk', 50, 2.5);
INSERT INTO Inventory VALUES (102, 'Bread', 30, 1.0);
INSERT INTO Inventory VALUES (103, 'Eggs', 100, 0.2);

-- Orders
INSERT INTO Orders VALUES (201, 1, '2025-12-02');
INSERT INTO Orders VALUES (202, 2, '2025-12-02');
INSERT INTO Orders VALUES (203, 3, '2025-12-02');

-- OrderDetails
INSERT INTO OrderDetails VALUES (301, 201, 101, 5);  -- Alice buys 5 Milk
INSERT INTO OrderDetails VALUES (302, 202, 102, 2);  -- Bob buys 2 Bread
INSERT INTO OrderDetails VALUES (303, 203, 103, 12); -- Charlie buys 12 Eggs




create database demo_trigger;
use demo_trigger;

create table aadhar(
aid tinyint,
first_name varchar(200),
second_name varchar(200),
address varchar(255)
);
select * from aadhar;

-- create update_tracker

create table update_tracker(
aid tinyint,
old_address varchar(255),
new_address varchar(255));

select * from update_tracker;
select * from aadhar;

insert into aadhar value (1, 'sai','k','Pune'), (2,'manu','singh','Hyd');



use learndb;

DROP TABLE IF EXISTS `book_sales`;


CREATE TABLE `book_sales` (
  `sale_id` int(11) NOT NULL AUTO_INCREMENT,
  `bookid` int(11) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `qty_sold` int(11) DEFAULT NULL,
  `tos` datetime DEFAULT NULL,
  PRIMARY KEY (`sale_id`)
) ;
