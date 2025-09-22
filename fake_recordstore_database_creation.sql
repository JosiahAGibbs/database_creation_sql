CREATE TABLE customers (
	customer_id INTEGER PRIMARY KEY,
	name TEXT NOT NULL,
	city TEXT,
	joined_at DATE NOT NULL
);

CREATE TABLE products (
	product_id INTEGER PRIMARY KEY,
	name TEXT NOT NULL,
	category TEXT NOT NULL,
	price_cents INTEGER NOT NULL
);

CREATE TABLE orders (
	order_id INTEGER PRIMARY KEY,
	customer_id INTEGER NOT NULL REFERENCES customers(customer_id),
	order_date DATE NOT NULL
);

CREATE TABLE order_items (
	order_id INTEGER NOT NULL REFERENCES orders(order_id),
	product_id INTEGER NOT NULL REFERENCES products(product_id),
	qty INTEGER NOT NULL CHECK (qty>0),
	unit_price_cents INTEGER NOT NULL,
	PRIMARY KEY (order_id, product_id)
);

INSERT INTO customers VALUES
(1, 'Ava Grey', 'Nashville', '2025-05-05'),
(2, 'Noah Stone', 'Chicago','2025-05-20'),
(3, 'Lena Voss','Atlanta','2025-6-02'),
(4,'Mika Hale', 'Austin','2025-06-18'),
(5,'Rex Moon','Nashville','2025-07-01');

INSERT INTO products VALUES
(101,'Tribulation - Down Below (Vinyl)','Vinyl',2499),
(102, 'Unto Others - Strength (Vinyl)','Vinyl',2299),
(103, 'The Sound - Jeopardy (Cassette)', 'Cassette', 1299),
(104, 'Bauhaus Shirt', 'Shirt', 1999),
(105, 'Front 242 Tour Poster', 'Poster', 999),
(106, 'Sisters of Mercy - Floodland (Vinyl)', 'Vinyl', 2599),
(107, 'Industrial Sampler Vol.1 (CD)', 'CD', 899),
(108, 'Depeche Mode - People Are People (Single)', 'Single', 999),
(109, 'Luna Sea Shirt', 'Shirt', 2499),
(110, 'Buzz Kill - Fascination (Vinyl)', 'Vinyl', 2299);

INSERT INTO orders VALUES
(1001, 1, '2025-05-22'),
(1002, 2, '2025-05-28'),
(1003, 1, '2025-06-10'),
(1004, 3, '2025-06-22'),
(1005, 4, '2025-06-22'),
(1006, 2, '2025-07-15'),
(1007, 5, '2025-07-20'),
(1008, 1, '2025-08-04'),
(1009, 3, '2025-08-18'),
(1010, 5, '2025-09-02'),
(1011,2,'2025-09-06');

TRUNCATE TABLE order_items;

INSERT INTO order_items (order_id, product_id, qty, unit_price_cents) VALUES
(1001,101,1,2499),
(1001,105,2,999),
(1002,102,1,2199),
(1002,104,1,1899),
(1003,103,2,1299),
(1004,106,1,2599),
(1004,105,1,899),
(1005,104,1,1999),
(1005,107,3,899),
(1006,101,1,2399),
(1007,102,1,2299),
(1007,105,1,999),
(1008,106,2,2499),
(1008,103,1,1199),
(1009,101,1,2499),
(1009,104,2,1799),
(1010,107,2,899),
(1010,103,1,1199),
(1011,106,1,2599),
(1011,105,2,999);

WITH order_totals AS
	(SELECT 
		o1.order_id,
		o1.order_date,
		SUM(o2.qty * o2.unit_price_cents) AS order_cents
	FROM orders AS o1
	INNER JOIN order_items AS o2
	USING (order_id)
	GROUP BY
		o1.order_id,
		o1.order_date)
SELECT
	order_date,
	ROUND(order_cents/100,2) AS daily_revenue
FROM order_totals
ORDER BY order_date DESC;

WITH order_totals AS
	(SELECT 
		o1.order_id,
		SUM(o2.qty * o2.unit_price_cents) AS order_cents
	FROM orders AS o1
	INNER JOIN order_items AS o2
	USING (order_id)
	GROUP BY
		o1.order_id)
SELECT 
	ROUND(AVG (order_cents)/100,2) AS avg_order_amt
FROM order_totals