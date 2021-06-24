-- CSC db project sql code

-- create db
create database if not exists clothdb; 
use clothdb;

-- create table
use clothdb;

create table if not exists customer
(
customer_id char(5) not null primary key,
first_name varchar(10),
gender varchar(10),
state varchar(5)
);

create table if not exists orders
(
order_id char(5) not null primary key,
customer_id char(5),
purchase_date date,
shipping_status varchar(10)
);

create table if not exists order_detail
(
order_id char(5),
product_id char(5),
order_quantity double,
unit_price integer,
discount_voucher_yn varchar(5),
primary key (order_id, product_id)
);

create table if not exists product
(
product_id char(5) not null primary key,
product_name varchar(15),
product_category varchar(10),
price integer,
stock double,
material varchar(10)
);

-- insert data
use clothdb;

insert into customer values('C-100', 'Abby', 'female', 'AZ');
insert into customer values('C-101', 'Betty', 'female', 'NY');
insert into customer values('C-102', 'Calvin', 'male', 'CA');
insert into customer values('C-103', 'David', 'male', 'NJ');
insert into customer values('C-104', 'Emma', 'female', 'IL');
insert into customer values('C-105', 'Fiona', 'female', 'TX');
insert into customer values('C-106', 'Grant', 'male', 'UT');
insert into customer values('C-107', 'Jack', 'male', 'AZ');
insert into customer values('C-108', 'Kate', 'female', 'CA');
insert into customer values('C-109', 'Leo', 'male', 'MN');


insert into orders values('O-001', 'C-103', '2020-06-27', 'processing');
insert into orders values('O-002', 'C-104', '2020-02-13', 'shipped');
insert into orders values('O-003', 'C-107', '2020-03-04', 'shipped');
insert into orders values('O-004', 'C-108', '2020-07-15', 'processing');
insert into orders values('O-005', 'C-103', '2020-01-28', 'shipped');
insert into orders values('O-006', 'C-106', '2020-05-03', 'processing');
insert into orders values('O-007', 'C-107', '2020-11-01', 'processing');
insert into orders values('O-008', 'C-109', '2020-12-21', 'processing');


insert into order_detail values('O-001', 'P-501', 1, 10, 'no');
insert into order_detail values('O-002', 'P-500', 3, 18, 'yes');
insert into order_detail values('O-002', 'P-506', 3, 5, 'yes');
insert into order_detail values('O-002', 'P-509', 3, 8, 'yes');
insert into order_detail values('O-003', 'P-504', 2, 30, 'no');
insert into order_detail values('O-003', 'P-505', 2, 28, 'no');
insert into order_detail values('O-004', 'P-508', 1, 30, 'no');
insert into order_detail values('O-005', 'P-502', 2, 17, 'no');
insert into order_detail values('O-005', 'P-506', 2, 6, 'no');
insert into order_detail values('O-006', 'P-503', 1, 25, 'no');
insert into order_detail values('O-007', 'P-501', 3, 9, 'yes');
insert into order_detail values('O-007', 'P-502', 3, 15, 'yes');
insert into order_detail values('O-007', 'P-507', 3, 14, 'yes');
insert into order_detail values('O-008', 'P-509', 1, 9, 'no');


insert into product values('P-500', 'floral_dress', 'dress', 20, 100, 'linen');
insert into product values('P-501', 'tank_top', 'top', 10, 50, 'cotton');
insert into product values('P-502', 'cat_tshirt', 'top', 17, 200, 'cotton');
insert into product values('P-503', 'denim_shorts', 'bottom', 25, 100, 'denim');
insert into product values('P-504', 'dog_pants', 'bottom', 30, 60, 'polyester');
insert into product values('P-505', 'plain_dress', 'dress', 28, 70, 'linen');
insert into product values('P-506', 'kid_socks', 'socks', 6, 200, 'cotton');
insert into product values('P-507', 'pocket_tshirt', 'top', 15, 110, 'polyester');
insert into product values('P-508', 'letter_shorts', 'bottom', 30, 200, 'cotton');
insert into product values('P-509', 'adult_socks', 'socks', 9, 200, 'polyester');


-- SELECT
-- select involving one/more conditions in Where Clause
-- Display product's id and name with products that made by cotton and remaining stock over 100 
SELECT 
    product_id, product_name
FROM
    product
WHERE
    material = 'cotton' AND stock > 100;

-- select with aggregate functions (i.e., SUM,MIN,MAX,AVG,COUNT)
-- Show each order's total price
SELECT 
    order_id, SUM(unit_price) AS total_price
FROM
    order_detail
GROUP BY order_id;

-- select with Having, Group By, Order By clause
-- Find each product category's average price that higher than $10 and listed as an order high to low by price
SELECT 
    product_category, AVG(price) AS avg_price
FROM
    product
GROUP BY product_category
HAVING avg_price > 10
ORDER BY avg_price DESC;

-- Nested Select
-- Find customer's first name with orders that haven't be shipped out yet
SELECT 
    first_name
FROM
    customer
WHERE
    customer_id IN (SELECT 
            customer_id
        FROM
            orders
        WHERE
            shipping_status = 'processing');

-- select involving the Union operation
-- Find all customer with their orders whether they have it or not
SELECT 
    *
FROM
    customer c
        LEFT JOIN
    orders os ON c.customer_id = os.customer_id 
UNION SELECT 
    *
FROM
    customer c
        RIGHT JOIN
    orders os ON c.customer_id = os.customer_id;

-- INSERT
-- insert one tuple into a table (for 2 tables, just add 3 records for each table)
insert into customer values('C-120', 'Mary', 'female', 'WA');

-- ?(for 2 tables, just add 3 records for each table)
insert into product values('P-801', 'stripe_shirt', 'top', 17, 100, 'polyester'),
('P-802', 'ckeck_tshit', 'top', 13, 200, 'polyester'),
('P-803', 'cat_socks', 'socks', 9, 300, 'polyester');

-- insert a set of tuples (by using another select statement)
-- insert female customers from customer into new table CustomerFemale
create table if not exists CustomerFemale
(
cf_id varchar(10) not null primary key,
cf_state varchar(5)
);

insert into CustomerFemale (cf_id, cf_state) select customer_id, state from customer where gender = 'female';

-- insert involving two tables
-- insert customer id purchase between Nov and Dec to CustomerFemale with FL state
insert into CustomerFemale (cf_id, cf_state) select customer_id, 'FL' from orders where purchase_date >= '2020-11-01' and purchase_date <= '2020-12-31';

-- DELETE
-- delete one tuple or a set of tuples: from one table
-- cancel orders that order quantity is equal to or more than 3
DELETE FROM order_detail 
WHERE
    order_quantity >= 3;

-- from multiple tables
-- delete orders data from MN or NJ
DELETE FROM orders 
WHERE
    customer_id IN (SELECT 
        customer_id
    FROM
        customer
    WHERE
        state = 'MN' or state = 'NJ');

-- UPDATE
-- update one tuple or a set of tuples: from one table
-- update price if stock >= 100 take 10% off, if not, increase 10%
UPDATE product 
SET 
    price = CASE
        WHEN stock >= 100 THEN price* 0.9
        WHEN stock <100 THEN price* 1.1
    END;

-- from multiple tables
-- set shipping status as shipped where customer state is NJ or CA
UPDATE orders 
SET 
    shipping_status = 'shipped'
WHERE
    customer_id IN (SELECT 
            customer_id
        FROM
            customer
        WHERE
            state = 'NJ' OR state = 'CA');

-- for check
-- SELECT 
--     c.first_name, c.state, os.*
-- FROM
--     customer c
--         JOIN
--     orders os ON c.customer_id = os.customer_id;

-- CREATE VIEW
-- based on one relation
-- create view as products with stock more than 100
CREATE VIEW PStocks100 AS
    SELECT 
        *
    FROM
        product
    WHERE
        stock > 100;

-- create a view with customer's total amount spend on all orders
-- CREATE VIEW CustomerSpend AS
--     SELECT 
--         os.customer_id, SUM(od.unit_price) AS total_spend
--     FROM
--         orders os
--             JOIN
--         order_detail od ON os.order_id = od.order_id
--     GROUP BY os.customer_id;

-- more than one relation
-- create a view with customer's name, gender, purchase date, shipping status and order quantity
CREATE VIEW CustomersOrder AS
    SELECT DISTINCT
        c.first_name,
        os.purchase_date,
        os.shipping_status,
        od.order_quantity
    FROM
        customer c
            JOIN
        orders os ON c.customer_id = os.customer_id
            JOIN
        order_detail od ON os.order_id = od.order_id;

-- operate on View (i.e., select, insert, delete, update)
-- insert
insert into PStocks100 (product_id, product_name, product_category, price, stock, material) values ('P-520', 'dot_dress', 'dress', 25, 300, 'cotton');

-- delete: delete 'top' category
DELETE FROM PStocks100 
WHERE
    product_category = 'top';
    
-- update: update price increase 10%
UPDATE PStocks100 
SET 
    price = price *1.1;

-- select: show polyester mateiral's avg price
SELECT 
    ROUND(AVG(price)) AS avg_price
FROM
    PStocks100
WHERE
    material = 'polyester';


-- TRIGGERS
-- TRIGGER for Summary Table
-- create summary table ProductData: calculating each category's avg price and stock
CREATE TABLE ProductData (
    category VARCHAR(10),
    avg_price DOUBLE,
    avg_stock INTEGER
);

INSERT INTO ProductData
SELECT 
    product_category AS category,
    ROUND(AVG(price), 2) AS avg_price,
    AVG(stock) AS avg_stock
FROM
    product
GROUP BY product_category;

-- trigger: update ProductData whenever insert new data into product table
DELIMITER $$
CREATE TRIGGER ProductData AFTER INSERT
ON product
FOR EACH ROW
BEGIN
DELETE FROM ProductData;
INSERT INTO ProductData
(SELECT 
    product_category,
    ROUND(AVG(price), 2),
    AVG(stock)
FROM
    product
GROUP BY product_category); 
END$$
DELIMITER ;

-- insert to active trigger
insert into product values ('P-601', 'string_pants', 'bottom', 40, 350, 'cotton');

-- for check
-- SELECT 
--     *
-- FROM
--     product;
--     
-- SELECT 
--     *
-- FROM
--     ProductData;

    

-- TRIGGER for Log
-- create CustomerData from customer table
CREATE TABLE CustomerData AS SELECT * FROM
    customer;

-- create theLog table
CREATE TABLE theLog (
    message VARCHAR(100)
);

DELIMITER $$
CREATE TRIGGER Add_Customer AFTER INSERT ON CustomerData
FOR EACH ROW
BEGIN
INSERT INTO theLog VALUES(CONCAT(current_date(), ': customer has been added by ',current_user()));
END$$
DELIMITER ;
    
-- insert to activate trigger
insert into CustomerData values('C-500', 'Sean', 'male', 'FL');

-- for check    
SELECT 
    *
FROM
    CustomerData;

SELECT 
    *
FROM
    theLog;



-- TRIGGER Referential Integrity
-- Before adding a new order data, it has to make sure that the customer exists! Otherwise, a message will show up in theLog table!

DELIMITER $$
CREATE TRIGGER Add_Orders BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
DECLARE temp INT; SET temp = 0;
SELECT COUNT(*) INTO temp FROM orders, customer WHERE
orders.customer_id = customer.customer_id
AND customer.customer_id = new.customer_id;
IF temp = 0 THEN
INSERT INTO theLog VALUES(CONCAT('customer id: ', new.customer_id, ' does not exist!'));
END IF;
END$$
DELIMITER ;

-- insert to activate trigger
-- exist data
insert into orders values('O-500', 'C-103', '2020-03-13', 'shipped');

-- non-exist data
insert into orders values('O-600', 'C-112', '2020-09-09', 'shipped');

-- for check
SELECT 
    *
FROM
    orders;

SELECT 
    *
FROM
    theLog;


-- Before adding new data into the order detail table, order id has to be in the orders table system! Else, a message will show up in theLog table!

-- 'orders' pk: order_id
CREATE TABLE Order_ID AS SELECT order_id FROM
    orders;

DELIMITER $$
CREATE TRIGGER Add_ODetail BEFORE INSERT ON order_detail
FOR EACH ROW
BEGIN
DECLARE temp INT; SET temp = 0;
SELECT COUNT(*) INTO temp FROM order_detail, Order_ID WHERE
order_detail.order_id = Order_ID.order_id
AND Order_ID.order_id = new.order_id;
IF temp = 0 THEN
INSERT INTO theLog VALUES(CONCAT('order id: ', new.order_id, ' does not exist in the system!'));
END IF;
END$$
DELIMITER ;

-- insert to activate trigger
-- non-exist data
insert into order_detail values('O-100', 'P-503', 1, 25, 'no');


-- for check
SELECT 
    *
FROM
    Order_ID;

SELECT 
    *
FROM
    order_detail;

SELECT 
    *
FROM
    theLog;



-- TRIGGER Attribute Domain Checking
-- Make sure to add the product with the existing category!

-- create table Product_Type
CREATE TABLE Product_Type AS SELECT DISTINCT product_category FROM
    product;

DELIMITER $$
CREATE TRIGGER Add_Product BEFORE INSERT ON product
FOR EACH ROW
BEGIN
DECLARE temp INT; SET temp = 0;
SELECT COUNT(*) INTO temp FROM Product_Type WHERE
product_category = new.product_category;
IF temp = 0 THEN
INSERT INTO theLog VALUES(CONCAT('product category: ', new.product_category, ' does not exist in the system!'));
END IF;
END$$
DELIMITER ;

-- insert to activate trigger
insert into product values('P-700', 'face mask', 'cosmetics', 50, 10, 'cotton');

-- for check
SELECT 
    *
FROM
    product;

SELECT 
    *
FROM
    theLog;


