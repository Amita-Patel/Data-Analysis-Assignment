/*Day3 Q.1 1)	Show customer number, customer name, state and credit limit from customers table for below conditions. Sort the results by highest to lowest values of 
				creditLimit.

●	State should not contain null values
●	credit limit should be between 50000 and 100000 */
 USE classicmodels;
 
 
 SELECT *FROM customers;
 
 SELECT
 customerNumber,
 customerName,
 state,
 creditLimit
 FROM customers
 WHERE state is NOT NULL
 AND (creditLimit)BETWEEN 50000 AND 100000
 ORDER BY creditLimit DESC;
 
 # 2)	Show the unique productline values containing the word cars at the end from products table.
 SELECT * FROM products;
 
 SELECT DISTINCT productLine
 FROM  products
 WHERE productLine LIKE '%Cars';
 


/*Day 4

1)	Show the orderNumber, status and comments from orders table for shipped status only. If some comments are having null values then show them as “-“.
 */
 USE classicmodels;
 
 SELECT * FROM orders;
   
 SELECT
      orderNumber,
      status,
	IFNULL(Comments,'-') as Comments
	FROM orders;
    
    
    /*  2)	Select employee number, first name, job title and job title abbreviation from employees table based on following conditions.
If job title is one among the below conditions, then job title abbreviation column should show below forms.
●	President then “P”
●	Sales Manager / Sale Manager then “SM”
●	Sales Rep then “SR”
●	Containing VP word then “VP”  */
SELECT * FROM employees;
   
 SELECT
     employeeNumber ,  
	 firstName,
     jobTitle,
CASE 
     WHEN jobTitle= 'President' THEN 'P'
	 WHEN  jobTitle LIKE'Sales Manager%' OR  jobTitle LIKE 'Sale Manager%' THEN 'SM'
     WHEN  jobTitle='Sales Rep' THEN 'SR'
	WHEN  jobTitle LIKE '%VP%' THEN 'VP'
END  AS jobTitle_abbr
FROM employees;

/*Day 5:

1)	For every year, find the minimum amount value from payments table.*/
SELECT*FROM payments;
 
 SELECT 
 YEAR(paymentDate) AS `Year`,
 MIN(amount) AS `MIN Amount`
 FROM payments
  GROUP BY  YEAR(paymentDate);

 
 
# 2)For every year and every quarter, find the unique customers and total orders from orders table. Make sure to show the quarter as Q1,Q2 etc.
 SELECT*FROM orders;
 
 
 SELECT YEAR(orderDate) AS Year,
 CONCAT("Q", QUARTER(orderDate)) AS Quarter,
 COUNT( DISTINCT customerNumber ) AS UniqueCustomers,
 COUNT(*) AS TotalOrders
 FROM orders
 GROUP BY Year,Quarter;
 
 /* 3)Show the formatted amount in thousands unit (e.g. 500K, 465K etc.) for every month (e.g. Jan, Feb etc.) with filter on total amount as 500000 to 1000000. 
 Sort the output by total amount in descending mode. [ Refer. Payments Table]*/
 SELECT * FROM payments;
 
SELECT 
    CASE 
        WHEN MONTH(paymentDate) = 1 THEN 'Jan'
        WHEN MONTH(paymentDate) = 2 THEN 'Feb'
        WHEN MONTH(paymentDate) = 3 THEN 'Mar'
        WHEN MONTH(paymentDate) = 4 THEN 'Apr'
        WHEN MONTH(paymentDate) = 5 THEN 'May'
        WHEN MONTH(paymentDate) = 6 THEN 'Jun'
        WHEN MONTH(paymentDate) = 7 THEN 'Jul'
        WHEN MONTH(paymentDate) = 8 THEN 'Aug'
        WHEN MONTH(paymentDate) = 9 THEN 'Sep'
        WHEN MONTH(paymentDate) = 10 THEN 'Oct'
        WHEN MONTH(paymentDate) = 11 THEN 'Nov'
        WHEN MONTH(paymentDate) = 12 THEN 'Dec'
    END AS Month,
    CONCAT(FORMAT(SUM(amount) / 1000, 0), 'K') AS FormattedAmount
FROM 
    Payments
GROUP BY 
    Month
HAVING 
    SUM(amount) BETWEEN 500000 AND 1000000
ORDER BY 
    SUM(amount) DESC;

    /*Day 6:

1)	Create a journey table with following fields and constraints.

●	Bus_ID (No null values)
●	Bus_Name (No null values)
●	Source_Station (No null values)
●	Destination (No null values)
●	Email (must not contain any duplicates)*/

     CREATE TABLE journey(
     Bus_ID INT NOT NULL PRIMARY KEY,
     Bus_Name VARCHAR(25) NOT NULL,
     Source_Station VARCHAR(25) NOT NULL,
     Destination VARCHAR(25)NOT NULL,
     Email  VARCHAR(50) NOT NULL
     );
     
	/*2) Create vendor table with following fields and constraints.
 ●	Vendor_ID (Should not contain any duplicates and should not be null)
 ●	Name (No null values)
 ●	Email (must not contain any duplicates)
 ●	Country (If no data is available then it should be shown as “N/A”)*/
 
 CREATE TABLE vendor (
 Vendor_ID INT NOT NULL PRIMARY KEY,
 Name VARCHAR(50) NOT NULL,
 Email VARCHAR(50) NOT NULL,
 Country VARCHAR(25) DEFAULT 'N/A',
  UNIQUE(EMAIL)
  );
  
  /*3)	Create movies table with following fields and constraints.

●	Movie_ID (Should not contain any duplicates and should not be null)
●	Name (No null values)
●	Release_Year (If no data is available then it should be shown as “-”)
●	Cast (No null values)
●	Gender (Either Male/Female)
●	No_of_shows (Must be a positive number)*/
  
  CREATE TABLE Movie(
  Movie_ID VARCHAR(50) PRIMARY KEY,
  Release_year VARCHAR(10) DEFAULT "-",
  Cast VARCHAR(25) NOT NULL,
  Gender ENUM("Male","Female"),
  No_of_shows INT UNSIGNED
  );

#4)	Create the following tables. Use auto increment wherever applicable

/*a. Product
✔	product_id - primary key
✔	product_name - cannot be null and only unique values are allowed
✔	description
✔	supplier_id - foreign key of supplier table
- b. Suppliers
-- ✔	supplier_id - primary key
-- ✔	supplier_name
-- ✔	location
-- c. Stock
-- ✔	id - primary key
-- ✔	product_id - foreign key of product table
-- ✔	balance_stock
*/

CREATE TABLE Suppliers(
supplier_id INT  AUTO_INCREMENT PRIMARY KEY,
supplier_name VARCHAR(50),
location VARCHAR(100)
);

CREATE TABLE Product(
product_id INT  AUTO_INCREMENT PRIMARY KEY,
product_name VARCHAR(50),
descrption VARCHAR(100),
supplier_id INT,
FOREIGN KEY(supplier_id) REFERENCES Suppliers(supplier_id),
UNIQUE(product_name)
);

CREATE TABLE Stock(
id INT  AUTO_INCREMENT PRIMARY KEY,
product_id INT,
balance_stock INT,
FOREIGN KEY(product_id) REFERENCES Product(product_id)
);

SELECT * FROM Product;
SELECT* FROM Suppliers;
SELECT* FROM Stock;

#Day7
/*1)	Show employee number, Sales Person (combination of first and last names of employees), 
customersunique customers for each employee number and sort the data by highest to lowest unique customers.
Tables: Employees, Customers*/

SELECT e.employeeNumber,
CONCAT(e.firstName," ",e.lastName)AS Sales_Person,
COUNT(DISTINCT customerName) AS Unique_Customer
FROM Employees AS e
LEFT JOIN customers AS c ON e.employeeNumber=c.salesRepEmployeeNumber
GROUP BY e.employeeNumber,Sales_Person
ORDER BY Unique_Customer DESC;

-- 2)	Show total quantities, total quantities in stock, left over quantities for each product and each customer. Sort the data by customer number.
-- Tables: Customers, Orders, Orderdetails, Products
SELECT* FROM customers;
SELECT* FROM orders;
SELECT*FROM orderdetails;
SELECT*FROM products;

SELECT 
    c.customerNumber,
    p.productCode,
    SUM(od.quantityOrdered) AS TotalQuantitiesOrdered,
    p.quantityInStock AS TotalQuantitiesInStock,
    (p.quantityInStock - SUM(od.quantityOrdered)) AS LeftoverQuantities
FROM 
    Customers c
JOIN 
    Orders o ON c.customerNumber = o.customerNumber
JOIN 
    OrderDetails od ON o.orderNumber = od.orderNumber
JOIN 
    Products p ON od.productCode = p.productCode
GROUP BY 
    c.customerNumber, p.productCode
ORDER BY 
    c.customerNumber;

/*3)	Create below tables and fields. (You can add the data as per your wish)

●	Laptop: (Laptop_Name)
●	Colours: (Colour_Name)
Perform cross join between the two tables and find number of rows.*/

CREATE TABLE Laptop(
Laptop_Name VARCHAR(25)
);

CREATE TABLE Colours(
Colour_Name VARCHAR(25)
);

INSERT INTO Laptop(Laptop_Name ) VALUE("DELL");
INSERT INTO Laptop(Laptop_Name ) VALUE ("HP");

INSERT INTO Colours(Colour_Name) VALUE("Silver");
INSERT INTO Colours(Colour_Name) VALUE("White");
INSERT INTO Colours(Colour_Name) VALUE("Black");

SELECT *
FROM Laptop
CROSS JOIN Colours
ORDER BY  Laptop_Name;

/*4)	Create table project with below fields.

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
Find out the names of employees and their related managers.*/

CREATE TABLE Project (
    EmployeeID INT  NOT NULL PRIMARY KEY,
	FullName VARCHAR(50),
	Gender ENUM ("Male","Female"),
    ManagerID INT  DEFAULT NULL
    );
INSERT INTO Project VALUES(1, 'Pranaya', 'Male', 3);
INSERT INTO Project VALUES(2, 'Priyanka', 'Female', 1);
INSERT INTO Project VALUES(3, 'Preety', 'Female', NULL);
INSERT INTO Project VALUES(4, 'Anurag', 'Male', 1);
INSERT INTO Project VALUES(5, 'Sambit', 'Male', 1);
INSERT INTO Project VALUES(6, 'Rajesh', 'Male', 3);
INSERT INTO Project VALUES(7, 'Hina', 'Female', 3);    
    
SELECT 
e.FullName AS Emp_Name,m.FullName AS Manager_Name
FROM Project AS e
INNER JOIN Project AS m ON m.ManagerID = e.EmployeeID
ORDER BY Emp_Name;
    
    
/*Day 8
Create table facility. Add the below fields into it.
●	Facility_ID
●	Name
●	State
●	Country

i) Alter the table by adding the primary key and auto increment to Facility_ID column.
ii) Add a new column city after name with data type as varchar which should not accept any null values.*/
 
 CREATE TABLE Facility(
            Facility_ID  INT ,
			`Name` VARCHAR(50),
			State VARCHAR(25),
			Country VARCHAR(25)
            )
 ;
 
 ALTER TABLE Facility 
 MODIFY Facility_ID INT PRIMARY KEY AUTO_INCREMENT;
 
 ALTER TABLE Facility
 ADD COLUMN City VARCHAR(25) NOT NULL  AFTER `Name`;
 
 /*Day 9
Create table university with below fields.
●	ID
●	Name
Add the below data into it as it is.
INSERT INTO University
VALUES (1, "       Pune          University     "), 
	 (2, "  Mumbai          University     "),
              (3, "     Delhi   University     "),
              (4, "Madras University"),
              (5, "Nagpur University");
Remove the spaces from everywhere and update the column like Pune University etc.*/


CREATE TABLE University(
           ID INT  PRIMARY KEY,
           `Name` VARCHAR(50)
           );
           
INSERT INTO University
VALUES (1, "       Pune          University     "), 
		(2, "  Mumbai          University     "),
		(3, "     Delhi   University     "),
	    (4, "Madras University"),
		(5, "Nagpur University");  
        
        
        -- SET SQL_SAFE_UPDATES=0;
           UPDATE University
           SET `Name` = TRIM(REGEXP_REPLACE(Name, ' +', ' '));

       SELECT*FROM University;
       /*Day 10
Create the view products status. Show year wise total products sold. Also find the percentage of total value for each year. The output should look as shown in below figure.*/

CREATE VIEW Product_status  AS (
        SELECT
        YEAR (o.orderDate) AS `Year`,
        CONCAT(COUNT(od.ProductCode),"( ",ROUND(COUNT(od.ProductCode) / (SELECT COUNT(*) 
                FROM orderdetails ) *100),"%)") AS Yearly_Sold_Value
		FROM orderdetails od
        JOIN orders o ON od.orderNumber = o.orderNumber
		GROUP BY YEAR  -- (o.orderDate)
		ORDER BY Yearly_Sold_Value DESC
        );
SELECT*FROM Product_status;


/* Day 11
1)	Create a stored procedure GetCustomerLevel which takes input as customer number and gives the output as either Platinum, Gold or Silver as per below criteria.

Table: Customers

●	Platinum: creditLimit > 100000
●	Gold: creditLimit is between 25000 to 100000
●	Silver: creditLimit < 25000 */
SELECT *FROM customers;

DELIMITER //
CREATE PROCEDURE GetCustomerLevel (IN custNumber INT)
BEGIN
    DECLARE customerCredit DECIMAL(10,2);

    SELECT creditLimit INTO customerCredit FROM Customers WHERE customerNumber = custNumber;

    IF customerCredit > 100000 THEN
        SELECT 'Platinum' AS CustomerLevel;
    ELSEIF customerCredit BETWEEN 25000 AND 100000 THEN
        SELECT 'Gold' AS CustomerLevel;
    ELSE
        SELECT 'Silver' AS CustomerLevel;
    END IF;
END //
DELIMITER ;
CALL GetCustomerLevel(103);


/*2)	Create a stored procedure Get_country_payments which takes in year and country as inputs and gives year wise, country wise total amount as an output. Format the total amount to nearest thousand unit (K)
Tables: Customers, Payments*/

DELIMITER //

CREATE PROCEDURE Get_country_payments (IN inputYear INT, IN inputCountry VARCHAR(50))
BEGIN
    SELECT 
        YEAR(p.paymentDate) AS PaymentYear,
        c.country AS Country,
        CONCAT(FORMAT(SUM(p.amount) / 1000, 0), 'K') AS TotalAmount_K
    FROM 
        Customers c
    JOIN 
        Payments p ON c.customerNumber = p.customerNumber
    WHERE 
        YEAR(p.paymentDate) = inputYear AND c.country = inputCountry
    GROUP BY 
        PaymentYear, Country;
END //

DELIMITER ;
CALL Get_country_payments(2003,'France');

/*Day 12
1)	Calculate year wise, month name wise count of orders and year over year (YoY) percentage change. Format the YoY values in no decimals and show in % sign.
Table: Orders
*/
select*from orders;
SELECT 
    YEAR(orderDate) AS OrderYear,
    MONTHNAME(orderDate) AS `MonthName`,
    COUNT(*) AS Total_Orders,
     CONCAT(
        IFNULL(FORMAT((COUNT(*) - LAG(COUNT(*)) OVER (ORDER BY YEAR(orderDate), MONTH(orderDate))) / LAG(COUNT(*)) OVER (ORDER BY YEAR(orderDate), MONTH(orderDate)) * 100, 0), 'NULL'),
        '%'
    ) AS `YoY_%_Change`
FROM Orders
GROUP BY  OrderYear,Month(orderDate),`MonthName`
ORDER BY   OrderYear,Month(orderDate),`MonthName`;

/*
2)	Create the table emp_udf with below fields.

●	Emp_ID
●	Name
●	DOB
Add the data as shown in below query.
INSERT INTO Emp_UDF(Name, DOB)
VALUES ("Piyush", "1990-03-30"), ("Aman", "1992-08-15"), ("Meena", "1998-07-28"), ("Ketan", "2000-11-21"), ("Sanjay", "1995-05-21");

Create a user defined function calculate_age which returns the age in years and months (e.g. 30 years 5 months) by accepting DOB column as a parameter.*/

CREATE TABLE emp_udf (
    Emp_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50),
    DOB DATE
);

INSERT INTO emp_udf (Name, DOB)
VALUES 
    ('Piyush', '1990-03-30'),
    ('Aman', '1992-08-15'),
    ('Meena', '1998-07-28'),
    ('Ketan', '2000-11-21'),
    ('Sanjay', '1995-05-21');
    
    
    DELIMITER //

CREATE FUNCTION calculate_age(date_of_birth DATE)
RETURNS VARCHAR(50)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE years_passed INT;
    DECLARE months_passed INT;
    DECLARE age VARCHAR(50);

    SELECT 
        TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) INTO years_passed;
    SELECT 
        TIMESTAMPDIFF(MONTH, date_of_birth, CURDATE()) % 12 INTO months_passed;

    SET age = CONCAT(years_passed, ' years ', months_passed, ' months');
    RETURN age;
END//

DELIMITER ;

SELECT 
    Name, 
    DOB, 
    calculate_age(DOB) AS Age
FROM emp_udf;

/*Day 13
1)	Display the customer numbers and customer names from customers table who have not placed any orders using subquery
Table: Customers, Orders*/

SELECT customerNumber, customerName
FROM Customers
WHERE customerNumber NOT IN (
    SELECT customerNumber
    FROM Orders
);

/*2)	Write a full outer join between customers and orders using union and get the customer number, customer name, count of orders for every customer.
Table: Customers, Orders*/
SELECT c.customerNumber, c.customerName, COUNT(o.orderNumber) AS Total_orders
FROM Customers c
LEFT JOIN Orders o ON c.customerNumber = o.customerNumber
GROUP BY c.customerNumber, c.customerName

UNION

SELECT c.customerNumber, c.customerName, COUNT(o.orderNumber) AS Total_orders
FROM Orders o
RIGHT JOIN Customers c ON c.customerNumber = o.customerNumber
GROUP BY c.customerNumber, c.customerName;

/*3)	Show the second highest quantity ordered value for each order number.
Table: Orderdetails*/
SELECT orderNumber, MAX(quantityOrdered) AS SecondHighestQuantity
FROM (
    SELECT orderNumber, quantityOrdered,
        ROW_NUMBER() OVER (PARTITION BY orderNumber ORDER BY quantityOrdered DESC) AS rn
    FROM Orderdetails
) ranked
WHERE rn = 2
GROUP BY orderNumber;

/*4)	For each order number count the number of products and then find the min and max of the values among count of orders.
Table: Orderdetails*/
   

SELECT MAX(ProductCount) AS `MAX(Total)`,MIN(ProductCount) AS `MIN(Total)`
FROM ( SELECT orderNumber, COUNT(productCode) AS ProductCount
     FROM Orderdetails
     GROUP BY orderNumber)
AS subquery;


/*5)	Find out how many product lines are there for which the buy price value is greater than the average of buy price value. Show the output as product line and its count.*/
SELECT productLine, COUNT(*) AS LineCount
FROM products
WHERE buyPrice > (
    SELECT AVG(buyPrice)
    FROM products
)
GROUP BY productLine;

/*Day 14
Create the table Emp_EH. Below are its fields.
●	EmpID (Primary Key)
●	EmpName
●	EmailAddress
Create a procedure to accept the values for the columns in Emp_EH. Handle the error using exception handling concept. Show the message as “Error occurred” in case of anything wrong.*/

CREATE TABLE Emp_EH (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50),
    EmailAddress VARCHAR(100)
);

DELIMITER //
CREATE PROCEDURE InsertIntoEmp_EH(
    IN input_EmpID INT,
    IN input_EmpName VARCHAR(100),
    IN input_EmailAddress VARCHAR(100)
)
BEGIN
    DECLARE error_occurred BOOLEAN DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND
    BEGIN
        SET error_occurred = TRUE;
    END;

    START TRANSACTION;

    -- Insert the values into Emp_EH
    INSERT INTO Emp_EH (EmpID, EmpName, EmailAddress)
    VALUES (input_EmpID, input_EmpName, input_EmailAddress);

    IF error_occurred THEN
        ROLLBACK;
        SELECT 'Error occurred' AS Message;
    ELSE
        COMMIT;
        SELECT 'Data inserted successfully' AS Message;
    END IF;
END //
DELIMITER ;

CALL InsertIntoEmp_EH(1, 'abc', 'abc@example.com');

select * from emp_eh;

/*-- Day 15
-- Create the table Emp_BIT. Add below fields in it.
-- ●	Name
-- ●	Occupation
-- ●	Working_date
-- ●	Working_hours
-- Insert the data as shown in below query.
-- INSERT INTO Emp_BIT VALUES
-- ('Robin', 'Scientist', '2020-10-04', 12),  
-- ('Warner', 'Engineer', '2020-10-04', 10),  
-- ('Peter', 'Actor', '2020-10-04', 13),  
-- ('Marco', 'Doctor', '2020-10-04', 14),  
-- ('Brayden', 'Teacher', '2020-10-04', 12),  
-- ('Antonio', 'Business', '2020-10-04', 11);  
-- Create before insert trigger to make sure any new value of Working_hours, if it is negative, then it should be inserted as positive*/

CREATE TABLE Emp_BIT(
Name CHAR(50),
Occupation VARCHAR(100),
Working_date DATE,
Working_hours INT
);
INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);  

DELIMITER //
CREATE TRIGGER Before_Insert_Emp_BIT
BEFORE INSERT ON Emp_BIT
FOR EACH ROW
BEGIN
    IF NEW.Working_hours < 0 THEN
        SET NEW.Working_hours = -NEW.Working_hours;
    END IF;
END //
DELIMITER 
SHOW TRIGGERS;


