#Day3
/* 1)	Show customer number, customer name, state and credit limit from customers table for below conditions. Sort the results by highest to lowest values of creditLimit.

●	State should not contain null values
●	credit limit should be between 50000 and 100000 */

SELECT customerNumber, customerName, State, creditLimit
FROM Customers
WHERE state IS NOT NULL
    AND creditlimit BETWEEN  50000 AND 100000
ORDER BY creditLimit DESC;

/* 2)	Show the unique productline values containing the word cars at the end from products table.
Expected output:*/

SELECT DISTINCT productline FROM products Where productline LIKE '%cars';

#Day4
/* 1)	Show the orderNumber, status and comments from orders table for shipped status only. 
If some comments are having null values then show them as “-“. */

SELECT orderNumber,status ,infull (comments,'-') as comments FROM orders WHERE STATUS='Shipped'; 


/* 2)	Select employee number, first name, job title and job title abbreviation from employees table based on following conditions.
If job title is one among the below conditions, then job title abbreviation column should show below forms.
●	President then “P”
●	Sales Manager / Sale Manager then “SM”
●	Sales Rep then “SR”
●	Containing VP word then “VP” */

SELECT employeenumber,firstname,jobtitle,CASE
     WHEN jobtitle = 'President' THEN 'P'
     WHEN jobtitle  IN ('Sales Manager','Sale Manager') THEN 'SM'
     WHEN jobtitle = 'Sales Rep' THEN 'SR'
     WHEN jobtitle LIKE '%VP%' THEN 'VP'
     ELSE jobtitle   
END AS jobtitlebbreviation
FROM employees;

#Day5
/* 1) For every year, find the minimum amount value from payments table.*/
SELECT YEAR(paymentDate) AS paymentYear, MIN(amount) AS minAmount
FROM payments
GROUP BY year
ORDER BY Year;

/* 2)	For every year and every quarter, find the unique customers and total orders from orders table. 
Make sure to show the quarter as Q1,Q2 etc. */

select 
 year(orderdate) as year, concat ('Q',quarter(orderdate)) as quarter,
 count(distinct customernumber) as unique_customer,count(ordernumber) as total_order
from orders
group by
year, quarter
order by
year;

/* 3)	Show the formatted amount in thousands unit (e.g. 500K, 465K etc.) for every month (e.g. Jan, Feb etc.) with filter on total amount as 500000 to 1000000. 
Sort the output by total amount in descending mode. [ Refer. Payments Table] */

SELECT 
    MONTHNAME(paymentDate) AS Month,
    CONCAT(FORMAT(SUM(amount) / 1000, 0), 'K') AS FormattedAmount
FROM 
    payments
GROUP BY 
    MONTHNAME(paymentDate)
HAVING 
    SUM(amount) BETWEEN 500000 AND 1000000
ORDER BY 
    SUM(amount) DESC;
    
#Day6
/* 1)	Create a journey table with following fields and constraints.

●	Bus_ID (No null values)
●	Bus_Name (No null values)
●	Source_Station (No null values)
●	Destination (No null values)
●	Email (must not contain any duplicates)


2)	Create vendor table with following fields and constraints.

●	Vendor_ID (Should not contain any duplicates and should not be null)
●	Name (No null values)
●	Email (must not contain any duplicates)
●	Country (If no data is available then it should be shown as “N/A”)


3)	Create movies table with following fields and constraints.

●	Movie_ID (Should not contain any duplicates and should not be null)
●	Name (No null values)
●	Release_Year (If no data is available then it should be shown as “-”)
●	Cast (No null values)
●	Gender (Either Male/Female)
●	No_of_shows (Must be a positive number)


4)	Create the following tables. Use auto increment wherever applicable

a. Product
✔	product_id - primary key
✔	product_name - cannot be null and only unique values are allowed
✔	description
✔	supplier_id - foreign key of supplier table

b. Suppliers
✔	supplier_id - primary key
✔	supplier_name
✔	location

c. Stock
✔	id - primary key
✔	product_id - foreign key of product table
✔	balance_stock/*

/* Create Journey table Q1 */
CREATE TABLE journey (
BUS_ID int primary key,
BUS_NAME VARCHAR(20) Not Null,
SOURCE_STATION varchar(20) Not Null,
DESTINATION VARCHAR(20) Not Null,
Email VARCHAR(25) unique
);

/*create vendor table Q2*/
CREATE TABLE Vendor (
    Vendor_ID INT PRIMARY KEY,
    Name VARCHAR(25) NOT NULL,
    Email VARCHAR(25) unique,
    Country VARCHAR(25) DEFAULT 'N/A'
    );
    
    /*create movies table Q3*/
    CREATE TABLE movies (
    Movie_ID INT PRIMARY KEY NOT NULL,
    Name VARCHAR(255) NOT NULL,
    Release_Year INT DEFAULT NULL,
    Cast VARCHAR(255) NOT NULL,
    Gender ENUM('Male', 'Female'),
    No_of_shows INT CHECK (No_of_shows > 0)
);
set SQL_SAFE_UPDATES=0;
UPDATE movies SET Release_Year = '-' 
WHERE Release_Year IS NULL;

 /*	Create the following tables. Use auto increment wherever applicable Q4*/
 
 -- Create the "Suppliers" table
CREATE TABLE Suppliers (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_name VARCHAR(255) NOT NULL,
    location VARCHAR(255)
);

-- Create the "Product" table
CREATE TABLE Product (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    supplier_id INT,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);

-- Create the "Stock" table
CREATE TABLE Stock (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    balance_stock INT,
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

#Day7
/* 1)	Show employee number, Sales Person (combination of first and last names of employees), unique customers for each employee number and sort the data by highest to lowest unique customers.
Tables: Employees, Customers*/

select  e.employeeNumber,concat(e.firstname,' ',e.lastname)as `Sales Person`,
count(Distinct c.customerNumber) as `Unique Customers`
 from employees e
 left join customers c on e.employeenumber = c.salesRepemployeenumber
 Group by
 e.employeeNumber
 order by
 `Unique Customers` desc;
 
/* 2)	Show total quantities, total quantities in stock, left over quantities for each product and each customer. Sort the data by customer number.

Tables: Customers, Orders, Orderdetails, Products */

SELECT
    c.CustomerID,
    c.CustomerName,
    p.ProductID,
    p.ProductName,
    SUM(od.Quantity) AS TotalQuantities,
    p.QuantityInStock AS TotalQuantitiesInStock,
    (p.QuantityInStock - SUM(od.Quantity)) AS LeftOverQuantities
FROM
    Customers c
JOIN
    Orders o ON c.CustomerID = o.CustomerID
JOIN
    OrderDetails od ON o.OrderID = od.OrderID
JOIN
    Products p ON od.ProductID = p.ProductID
GROUP BY
    c.CustomerID, p.ProductID
ORDER BY
    c.CustomerID;
    
/*
3)	Create below tables and fields. (You can add the data as per your wish)

●	Laptop: (Laptop_Name)
●	Colours: (Colour_Name)
Perform cross join between the two tables and find number of rows.*/

CREATE TABLE Laptop (
    Laptop_Name VARCHAR(50)
);

CREATE TABLE Colours (
    Colour_Name VARCHAR(20)
);

INSERT INTO Laptop (Laptop_Name) VALUES
    ('Dell'),
    ('HP'),
    ('Acer');
commit;
INSERT INTO Colours (Colour_Name) VALUES
    ('White'),
    ('Silver'),
    ('Black');
    commit;
    
    SELECT Laptop.Laptop_Name, Colours.Colour_Name
FROM Laptop
CROSS JOIN Colours;

/* 4)	Create table project with below fields.

●	EmployeeID
●	FullName
●	Gender
●	ManagerID
Add below data into it.
INSERT INTO Project VALUES(1, 'Pranaya', 'Male', 3);
INSERT INTO Project VALUES(2, 'Priyanka', 'Female', 1);
INSERT INTO Project VALUES(3, 'Preety', 'Female', NULL);
INSERT INTO Project VALUES(4, 'Anurag', 'Male', 1);
INSERT INTO Project VALUES(5, 'Sambit', 'Male', 1);
INSERT INTO Project VALUES(6, 'Rajesh', 'Male', 3);
INSERT INTO Project VALUES(7, 'Hina', 'Female', 3);
Find out the names of employees and their related managers. */

create table project (
	employeeid int,
    fullname char(20),
    gender char(20),
    managerID int
    );
    
INSERT INTO Project VALUES(1, 'Nikhil', 'Male', 3);
INSERT INTO Project VALUES(2, 'Harshali', 'Female', 1);
INSERT INTO Project VALUES(3, 'Dharmika', 'Female', NULL);
INSERT INTO Project VALUES(4, 'Chris', 'Male', 1);
INSERT INTO Project VALUES(5, 'Manas', 'Male', 1);
INSERT INTO Project VALUES(6, 'Mihir', 'Male', 3);
INSERT INTO Project VALUES(7, 'Prajakta', 'Female', 3);
commit;

select * from manager;
select * from Project;

select 
	m.managername as `Manager Name`,
    p.fullname as `Emp Name`
from manager m 
join project p on m.managerID = p.managerID ;

#Day8
/* Create table facility. Add the below fields into it.
●	Facility_ID
●	Name
●	State
●	Country

i) Alter the table by adding the primary key and auto increment to Facility_ID column.
ii) Add a new column city after name with data type as varchar which should not accept any null values. */

create table facility(
Facility_ID INT ,
`Name`varchar(25),
State VARCHAR(50),
Country VARCHAR(50)
);

alter table facility modify Facility_id int primary key auto_increment;
alter table facility add column city varchar(40) not null after Name;
desc facility;

#Day9
/* Create table university with below fields.
●	ID
●	Name
Add the below data into it as it is.
INSERT INTO University
VALUES (1, "       Pune          University     "), 
               (2, "  Mumbai          University     "),
              (3, "     Delhi   University     "),
              (4, "Madras University"),
              (5, "Nagpur University");
Remove the spaces from everywhere and update the column like Pune University etc. */

create table University(
ID int Primary key,
`Name` varchar(25));
INSERT INTO University
VALUES (1, "  Pune     University  "), 
               (2, "  Mumbai     University   "),
              (3, "     Delhi     University  "),
              (4, "Madras    University  "),
              (5, "Nagpur      University  ");
              commit;

set SQL_SAFE_UPDATES=0;
update University 
SET Name = TRIM(BOTH ' ' FROM Name);

Select * from university;

#Day10
/* Create the view products status. Show year wise total products sold. 
Also find the percentage of total value for each year. The output should look as shown in below figure */

Create view product_status as
select
year(o.orderDate) as year,
count(ProductCode) as totalProductSold,
Count(ProductCode * od.priceEach) as totalValue
from orders o
join orderdetails od on o.ordernumber = od.ordernumber
group by
year;

SELECT
    year,
    (totalProductSold/ SUM(totalProductSold) OVER ()) * 100 AS value
FROM
    product_status;

#Day11
/* 1)	Create a stored procedure GetCustomerLevel which takes input as customer number and gives the output as either Platinum, Gold or Silver as per below criteria.

Table: Customers

●	Platinum: creditLimit > 100000
●	Gold: creditLimit is between 25000 to 100000
●	Silver: creditLimit < 25000v*/

/* STORED PROCEDURE CODE :- */

CREATE TABLE Customers (
    CustomerNumber INT PRIMARY KEY,
    CreditLimit DECIMAL(10, 2) NOT NULL
);

INSERT INTO Customers (CustomerNumber, CreditLimit) VALUES
    (1, 150000),
    (2, 50000),
    (3, 20000);

DELIMITER //
CREATE PROCEDURE GetCustomerLevel(IN p_CustomerNumber INT)
BEGIN
    DECLARE p_CreditLimit DECIMAL(10, 2);

    SELECT CreditLimit INTO p_CreditLimit
    FROM Customers
    WHERE CustomerNumber = p_CustomerNumber;

   IF p_CreditLimit > 100000 THEN
        SELECT 'Platinum' AS CustomerLevel;
    ELSEIF p_CreditLimit BETWEEN 25000 AND 100000 THEN
        SELECT 'Gold' AS CustomerLevel;
    ELSE
        SELECT 'Silver' AS CustomerLevel;
    END IF;
END //
DELIMITER ;

CALL GetCustomerLevel(1);

/* 2)	Create a stored procedure Get_country_payments which takes in year and country as inputs and gives year wise, country wise total amount as an output. Format the total amount to nearest thousand unit (K)
Tables: Customers, Payments */

/* STORED PROCEDURE CODE :- */

CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_country_payments`(in `year.in` int,in `country.in` varchar(25))
BEGIN
select
year(p.paymentDate) as year,c.country,
concat(Round(sum(p.amount)/1000),'k') as total_amount
from Payments p
join customers c on p.customernumber = c.customernumber
where year(p.paymentdate) = `year.in`
and c.country = `country.in`
Group by 
year, country;
END

/* TO CALL STORED PROCEDURE :- */

call Get_country_payments (2003, 'France');

#Day12
/* 1)	Calculate year wise, month name wise count of orders and year over year (YoY) percentage change. 
Format the YoY values in no decimals and show in % sign.
Table: Orders */

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    OrderDate DATE NOT NULL);
    INSERT INTO Orders (OrderID, OrderDate) VALUES
    (1, '2021-01-15'),
    (2, '2021-01-20'),
    (3, '2022-02-10'),
    (4, '2022-03-05'),
    (5, '2022-03-18'),
    (6, '2023-01-12'),
    (7, '2023-02-25');
    SELECT
    YEAR(OrderDate) AS OrderYear,
    DATE_FORMAT(OrderDate, '%b') AS OrderMonth,
    COUNT(*) AS OrderCount,
    IFNULL(
        FORMAT(
            (COUNT(*) / LAG(COUNT(*), 1) OVER (ORDER BY YEAR(OrderDate), MONTH(OrderDate))) * 100,
            0
        ), 
        
        '0')AS YoYPercentageChange
FROM
    Orders
GROUP BY
    OrderYear, OrderMonth
ORDER BY
    OrderYear, MONTH(OrderDate);
    
/* 2)	Create the table emp_udf with below fields.

●	Emp_ID
●	Name
●	DOB
Add the data as shown in below query.
INSERT INTO Emp_UDF(Name, DOB)
VALUES ("Piyush", "1990-03-30"), ("Aman", "1992-08-15"), ("Meena", "1998-07-28"), ("Ketan", "2000-11-21"), ("Sanjay", "1995-05-21");

Create a user defined function calculate_age which returns the age in years and months (e.g. 30 years 5 months) by 
accepting DOB column as a parameter.*/

CREATE TABLE emp_udf (
    Emp_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL,
    DOB DATE NOT NULL);
    
    INSERT INTO emp_udf (Name, DOB)
VALUES 
    ("Piyush", "1990-03-30"),
    ("Aman", "1992-08-15"),
    ("Meena", "1998-07-28"),
    ("Ketan", "2000-11-21"),
    ("Sanjay", "1995-05-21");
    
    DELIMITER //
CREATE FUNCTION calculate_age(dob DATE)
RETURNS VARCHAR(50)
BEGIN
    DECLARE years INT;
    DECLARE months INT;

    SET years = TIMESTAMPDIFF(YEAR, dob, CURDATE());
    SET months = TIMESTAMPDIFF(MONTH, dob, CURDATE()) % 12;

    RETURN CONCAT(years, ' years ', months, ' months');
END //
DELIMITER ;

SELECT Name, calculate_age(DOB) AS Age FROM emp_udf;

#Day13
/* 1)	Display the customer numbers and customer names from customers table who have not placed any orders using subquery
      Table: Customers, Orders */
      
      SELECT customerNumber, customerName
FROM Customers
WHERE customerNumber NOT IN (
    SELECT customerNumber
    FROM Orders
);

/*
2)	Write a full outer join between customers and orders using union and get the customer number, customer name, count of 
orders for every customer.
Table: Customers, Orders*/

SELECT C.customerNumber, C.customerName, COUNT(O.orderNumber) AS orderCount
FROM Customers C
LEFT JOIN Orders O ON C.customerNumber = O.customerNumber
GROUP BY C.customerNumber, C.customerName

UNION ALL

SELECT C.customerNumber, C.customerName, COUNT(O.orderNumber) AS orderCount
FROM Customers C
RIGHT JOIN Orders O ON C.customerNumber = O.customerNumber
GROUP BY C.customerNumber, C.customerName;

/*3)	Show the second highest quantity ordered value for each order number.
Table: Orderdetails*/

SELECT
    OrderID,
    MAX(Quantity) AS SecondHighestQuantity
FROM (
    SELECT
        OrderID,
        Quantity,
        ROW_NUMBER() OVER (PARTITION BY OrderID ORDER BY Quantity DESC) AS RowNum
    FROM
        OrderDetails
) AS RankedData
WHERE
    RowNum = 2
GROUP BY
    OrderID;
    
/* 4)	For each order number count the number of products and then find the min and max of the values among count of orders.
Table: Orderdetails */

SELECT
  orderNumber,
  COUNT(productCode) AS numberOfProducts
FROM
  orderdetails
GROUP BY
  orderNumber
HAVING
  numberOfProducts = (
    SELECT MIN(productCount) FROM (
      SELECT COUNT(productCode) AS productCount
      FROM orderdetails
      GROUP BY orderNumber
    ) AS counts
  )
  OR
  numberOfProducts = (
    SELECT MAX(productCount) FROM (
      SELECT COUNT(productCode) AS productCount
      FROM orderdetails
      GROUP BY orderNumber
    ) AS counts);
    
/* 5)	Find out how many product lines are there for which the buy price value is greater than the average of buy price value. 
    Show the output as product line and its count.*/
    
    SELECT
    productLine,
    COUNT(*) AS productLineCount
FROM
    Products
WHERE
    buyPrice > (
        SELECT AVG(buyPrice)
        FROM Products
    )
GROUP BY
    productLine;
    
#Day14
/*Create the table Emp_EH. Below are its fields.
●	EmpID (Primary Key)
●	EmpName
●	EmailAddress
Create a procedure to accept the values for the columns in Emp_EH. Handle the error using exception handling concept. 
Show the message as “Error occurred” in case of anything wrong.*/

CREATE TABLE Emp_EH (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(255) NOT NULL,
    EmailAddress VARCHAR(255) NOT NULL
);

/* STORED PROCEDURE CODE :-*/

DELIMITER //
CREATE PROCEDURE InsertEmp(
    IN p_EmpID INT,
    IN p_EmpName VARCHAR(255),
    IN p_EmailAddress VARCHAR(255)
    );

    BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
       SELECT 'Error occurred' AS ErrorMessage;
    END;
 INSERT INTO Emp_EH (EmpID, EmpName, EmailAddress) VALUES (p_EmpID, p_EmpName, p_EmailAddress);
 SELECT 'Data inserted successfully' AS SuccessMessage;
END //
DELIMITER ;

#Day15
/* Create the table Emp_BIT. Add below fields in it.
●	Name
●	Occupation
●	Working_date
●	Working_hours

Insert the data as shown in below query.
INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);  
 
Create before insert trigger to make sure any new value of Working_hours, if it is negative, then it should be inserted as positive.*/

CREATE TABLE Emp_BIT (
    Name VARCHAR(255) NOT NULL,
    Occupation VARCHAR(255) NOT NULL,
    Working_date DATE NOT NULL,
    Working_hours INT
);
DELIMITER //
CREATE TRIGGER BeforeInsert_Emp_BIT
BEFORE INSERT ON Emp_BIT
FOR EACH ROW
BEGIN

 IF NEW.Working_hours < 0 THEN
        SET NEW.Working_hours = ABS(NEW.Working_hours);
    END IF;
END //
DELIMITER ;
INSERT INTO Emp_BIT VALUES
    ('Robin', 'Scientist', '2020-10-04', 12),
    ('Warner', 'Engineer', '2020-10-04', 10),
    ('Peter', 'Actor', '2020-10-04', 13),
    ('Marco', 'Doctor', '2020-10-04', 14),
    ('Brayden', 'Teacher', '2020-10-04', 12),
    ('Antonio', 'Business', '2020-10-04', 11);
    commit;
    




    







      
      


    
        
        
        


































