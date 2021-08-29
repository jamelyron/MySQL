USE shop;

INSERT INTO orders (user_id) SELECT id FROM users WHERE name = 'Геннадий';
INSERT INTO orders_products (order_id, product_id, total)
	SELECT LAST_INSERT_ID(), id, 2 FROM products WHERE name = 'Intel Core i5-7400';

INSERT INTO orders (user_id) SELECT id FROM users WHERE name = 'Наталья';
INSERT INTO orders_products (order_id, product_id, total)
	SELECT LAST_INSERT_ID(), id, 1 FROM products WHERE name IN ('Intel Core i5-7400', 'Gigabyte H310M S2H');

INSERT INTO orders (user_id) SELECT id FROM users WHERE name = 'Иван';
INSERT INTO orders_products (order_id, product_id, total)
	SELECT LAST_INSERT_ID(), id, 1 FROM products WHERE name IN ('AMD FX-8320', 'ASUS ROG MAXIMUS X HERO');

select distinct user_id from orders;

SELECT
	id, name, birthday_at
FROM
	users
WHERE
	id IN (SELECT DISTINCT user_id FROM orders);

/* 
SELECT
	u.id, u.name, u.birthday_at
FROM
	users AS u
JOIN
	orders AS o
ON
	u.id = o.user_id;
*/


SELECT
	id,
	name,
	price,
	(SELECT name FROM catalogs WHERE id = products.catalog_id) AS catalogs
FROM
	products;

/* 
SELECT
	p.id,
	p.name,
	p.price,
	c.name as catalogs
FROM
	products AS p
LEFT JOIN
	catalogs AS c
ON
	p.catalog_id = c.id;
*/


CREATE DATABASE IF NOT EXISTS flights_cities;

USE flights_cities;

DROP TABLE IF EXISTS flights;
CREATE TABLE IF NOT EXISTS flights (
	id SERIAL PRIMARY KEY,
	`from` VARCHAR(255) COMMENT 'Город отправления',
	`to` VARCHAR(255) COMMENT 'Город прибытия'
) COMMENT = 'Рейсы';

INSERT INTO flights (`from`, `to`) VALUES
	('moscow', 'omsk'),
	('nowgorod', 'kazan'),
	('irkutsk', 'moscow'),
	('omsk', 'irkutsk'),
	('moscow', 'kazan');
	
DROP TABLE IF EXISTS cities;
CREATE TABLE IF NOT EXISTS cities (
	id SERIAL PRIMARY KEY,
	label VARCHAR(255) COMMENT 'Код города',
	name VARCHAR(255) COMMENT 'Название города'
) COMMENT = 'Словарь городов';

INSERT INTO cities (label, name) VALUES
	('moscow', 'Москва'),
	('irkutsk', 'Иркутск'),
	('nowgorod', 'Новгород'),
	('kazan', 'Казань'),
	('omsk', 'Омск');
	
SELECT
	id,
	(SELECT name FROM cities WHERE label = flights.from) AS `from`,
	(SELECT name FROM cities WHERE label = flights.to) AS `to`
FROM
	flights;
	
/* 
SELECT
	f.id,
	cities_from.name as `from`,
	cities_to.name as `to`
FROM
	flights AS f
LEFT JOIN
	cities AS cities_from
ON
	f.from = cities_from.label
LEFT JOIN
	cities AS cities_to
ON
	f.to = cities_to.label;
*/