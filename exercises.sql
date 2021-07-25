-- ---------------------------------
-- LIKE clause
-- ---------------------------------
SELECT *
FROM customers
WHERE address LIKE '%trail%'
OR address LIKE '%avenue%';

SELECT *
FROM customers
WHERE phone LIKE '%9';

-- ---------------------------------
-- REGEXP
-- ---------------------------------

SELECT *
FROM customers
WHERE last_name REGEXP '[a-h]e';

-- REGEXP SECTION https://www.youtube.com/watch?v=7S_tz1z_5bA

SELECT *
FROM customers
WHERE first_name REGEXP '^elka$|^ambur$';

SELECT *
FROM customers
WHERE last_name REGEXP 'ey$|on$';

SELECT *
FROM customers
WHERE last_name REGEXP '^my|se';

SELECT *
FROM customers
WHERE last_name REGEXP 'b[r|u]';

-- ---------------------------------
-- RECORDS WITH MISSING VALUES
-- ---------------------------------
SELECT *
FROM customers
WHERE phone IS NOT NULL;

SELECT *
FROM orders
WHERE shipped_date IS NULL;

-- ---------------------------------
-- ORDER BY
-- ---------------------------------
SELECT *
FROM customers 
ORDER BY state, first_name;

SELECT *
FROM customers 
ORDER BY state ASC, birth_date DESC;

SELECT *, 10 AS points
FROM customers 
ORDER BY first_name ASC, birth_date DESC;

SELECT *, quantity * unit_price AS total_price
FROM order_items
WHERE order_id = 2 
ORDER BY total_price DESC;

-- ---------------------------------
-- LIMIT
-- ---------------------------------

-- LIMIT <skip>, <limit>
SELECT *
FROM customers
LIMIT 6, 3;

SELECT *
FROM customers
ORDER BY points DESC
LIMIT 3;

-- ---------------------------------
-- INNER JOIN
-- ---------------------------------
SELECT order_id, o.customer_id, first_name, last_name
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

SELECT oi.order_id, oi.product_id, p.name, oi.quantity, oi.unit_price
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id;

-- ---------------------------------
-- JOIN FOR MULTIPLE DATABASES
-- ---------------------------------
SELECT *
FROM order_items oi
JOIN sql_inventory.products p ON oi.product_id = p.product_id;


-- ---------------------------------
-- JOIN TABLE WITH ITSELF
-- ---------------------------------
USE sql_hr;

SELECT e.first_name AS employee_first_name, e.employee_id, m.employee_id AS manager_id, m.first_name AS manager_first_name
FROM employees e
JOIN employees m ON e.reports_to = m.employee_id;

-- ---------------------------------
-- JOIN MULTIPLE TABLES 
-- ---------------------------------
SELECT 
	orders.order_id, orders.order_date, orders.customer_id, 
    customers.first_name, customers.last_name, 
    order_statuses.name AS order_status
FROM orders
JOIN customers ON orders.customer_id = customers.customer_id
JOIN order_statuses ON orders.status = order_statuses.order_status_id;

SELECT 
	payments.payment_id, payments.invoice_id, payments.date, payments.amount, 
    clients.name AS client_name,
    payment_methods.name AS payment_method
FROM payments
JOIN clients ON clients.client_id = payments.client_id
-- JOIN invoices ON invoices.invoice_id = payments.invoice_id
JOIN payment_methods ON payment_methods.payment_method_id = payments.payment_method;

-- ---------------------------------
-- COMPOUND JOIN CONDITIONS 
-- ---------------------------------
 
SELECT * 
FROM order_items oi
JOIN order_item_notes oin
ON oi.order_id = oin.order_id
AND oi.product_id = oin.product_id;

-- ---------------------------------
-- IMPLICIT JOIN SYNTAX
-- ---------------------------------

-- explicit join syntax
SELECT * 
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id;

-- implicit join syntax
-- (should not be used, prefer common join syntax instead)
SELECT * 
FROM orders o, customers c
WHERE o.customer_id = c.customer_id;

-- ---------------------------------
-- OUTER JOIN
-- ---------------------------------

SELECT 
	c.customer_id, 
    c.first_name, 
    o.order_id
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
ORDER BY c.customer_id;


SELECT 
	p.product_id,
    p.name,
    oi.quantity,
    oi.order_id
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id;

-- ---------------------------------
-- OUTER JOIN MULTIPLE TABLES
-- ---------------------------------

SELECT
	c.customer_id,
    c.first_name,
    c.last_name,
    o.order_id,
    o.shipper_id,
    s.name AS shipper_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN shippers s ON o.shipper_id = s.shipper_id;


SELECT 
	o.order_date,
    o.order_id,
	c.first_name,
    s.name AS shipper,
    os.name AS order_status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN shippers s ON s.shipper_id = o.shipper_id
JOIN order_statuses os ON os.order_status_id = o.status
ORDER BY os.name;

-- ---------------------------------
-- OUTER SELF JOIN 
-- ---------------------------------
SELECT 
	e.employee_id, 
	e.first_name,
    m.first_name AS manager_name
FROM employees e
LEFT JOIN employees m ON e.reports_to = m.employee_id;

-- ---------------------------------
-- USING clause
-- ---------------------------------

SELECT
	o.order_id,
    c.first_name
FROM orders o
JOIN customers c USING(customer_id);

-- ---------------------------------
-- NATURAL JOIN
-- ---------------------------------

SELECT 
	o.order_id,
    c.first_name
FROM orders o
NATURAL JOIN customers c;

-- ---------------------------------
-- CROSS JOINS
-- ---------------------------------

SELECT 
	c.first_name,
    p.name AS product
FROM customers c, orders o
CROSS JOIN products p
ORDER BY c.first_name;

SELECT *
FROM shippers sh
CROSS JOIN products p;

SELECT 
	sh.name AS shipper,
    p.name AS product_name
FROM shippers sh, products p;

-- ---------------------------------
-- UNIONS
-- ---------------------------------

SELECT order_id, customer_id, order_date, 'Active' AS status
FROM orders
WHERE order_date >= '2019-01-01'
UNION
SELECT order_id, customer_id, order_date, 'Archived' AS status
FROM orders
WHERE order_date < '2019-01-01';

-- < 2000 - bronze 
-- <=2000 <= 3000 silver
-- > 3000 gold

SELECT 
	customer_id, first_name, points, 'Bronze' AS type
FROM customers
WHERE points < 2000
UNION
SELECT 
	customer_id, first_name, points, 'Silver' AS type
FROM customers
WHERE points BETWEEN 2000 AND 3000
UNION
SELECT 
	customer_id, first_name, points, 'Gold' AS type
FROM customers
WHERE points > 3000
ORDER BY first_name;

-- ---------------------------------
-- INSERT ONE
-- ---------------------------------

INSERT INTO customers (
	first_name,
    last_name,
    address,
    city,
    state)
VALUES (
	'Test First name',
    'Test last name',
    'Test address',
    'Test city',
    'NJ');

-- ---------------------------------
-- INSERT MANY
-- ---------------------------------

INSERT INTO shippers (name)
VALUES 
	('Shipper 1'),
	('Shipper 2'),
	('Shipper 3');
    
    
INSERT INTO products 
	(name, quantity_in_stock, unit_price)
VALUES
	('test product 1', 20, 4.0),
    ('test product 2', 5, 4.0),
    ('test product 3', 10, 4.0);

-- ---------------------------------
-- INSERT INTO MULTIPLE TABLES (HIERARCHICAL DATA STRUCTURE)
-- ---------------------------------
INSERT INTO orders
	(customer_id, order_date, status)
VALUES
	(1, '2020-01-01', 1);
    
INSERT INTO order_items
	(order_id, product_id, quantity, unit_price)
	VALUES
    (last_insert_id(), 1, 10, 2.95),
    (last_insert_id(), 2, 10, 3.95);
    
-- ---------------------------------
-- CREATE COPY OF A TABLE
-- ---------------------------------
CREATE TABLE orders_archived AS
SELECT * FROM orders;

INSERT INTO orders_archived
SELECT * 
FROM orders
WHERE order_date < '2019-01-01';


CREATE TABLE invoices_archived AS
SELECT
	i.invoice_id,
    i.number,
    i.client_id,
    i.invoice_total,
    i.payment_total,
    i.invoice_date,
    i.due_date,
    i.payment_date,
    c.name AS client_name
FROM invoices i
JOIN clients c ON i.client_id = c.client_id
WHERE payment_date IS NOT NULL;

CREATE TABLE invoices_archived AS
SELECT
	i.invoice_id,
    i.number,
    i.client_id,
    i.invoice_total,
    i.payment_total,
    i.invoice_date,
    i.due_date,
    i.payment_date,
    c.name AS client
FROM invoices i
JOIN clients c USING(client_id)
WHERE payment_date IS NOT NULL;

-- ---------------------------------
-- UPDATE ROW IN A TABLE
-- ---------------------------------
 
UPDATE invoices
SET payment_total = 10, payment_date = '2019-01-01'
WHERE invoice_id = 1;

UPDATE invoices
SET payment_total = DEFAULT, payment_date = DEFAULT
WHERE invoice_id = 1;

UPDATE invoices
SET 
	payment_total = invoice_total * 0.5,
    payment_date = due_date
WHERE invoice_id = 1;
 
-- ---------------------------------
-- UPDATE MULTIPLE ROWS IN A TABLE
-- ---------------------------------

UPDATE invoices
SET payment_date = '2019-01-01'
WHERE client_id = 2;

UPDATE customers
SET points = points + 50
WHERE birth_date < '1990-01-01';


-- ---------------------------------
-- USE SUBQUERIES IN UPDATES
-- --------------------------------- 

UPDATE invoices
SET 
	payment_total = invoice_total * 0.5,
    payment_date = due_date
WHERE client_id IN (
		SELECT client_id
		FROM clients
		WHERE state IN ('CA', 'NY'));

UPDATE orders
SET comments = 'Gold customer' 
WHERE customer_id IN (
		SELECT customer_id
		FROM customers c
		WHERE c.points > 3000);
        
-- ---------------------------------
-- DELETE ROWS
-- --------------------------------- 

DELETE FROM invoices
WHERE client_id = (
			SELECT client_id
			FROM clients c
			WHERE c.name = 'Myworks');
