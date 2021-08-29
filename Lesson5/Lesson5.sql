DROP DATABASE IF EXISTS Lesson5;
CREATE DATABASE IF NOT EXISTS Lesson5;

USE Lesson5;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
 id SERIAL PRIMARY KEY,
 name VARCHAR(255),
 birthday_at DATE,
 created_at DATETIME,
 updated_at DATETIME
);

INSERT INTO users (name, birthday_at, created_at, updated_at) VALUES
	('Геннадий', '1990-10-05', NULL, NULL),
	('Наталья', '1984-11-12', NULL, NULL),
	('Александр', '1985-05-20', NULL, NULL),
	('Сергей', '1988-02-14', NULL, NULL),
	('Иван', '1998-01-12', NULL, NULL),
	('Мария', '1992-08-29', NULL, NULL);

UPDATE users SET created_at = NOW(), updated_at = NOW();

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL,
  name VARCHAR(255),
  birthday_at DATE,
  created_at VARCHAR(255),
  updated_at VARCHAR(255)
);

INSERT INTO users (name, birthday_at, created_at, updated_at) VALUES
  ('Геннадий', '1990-10-05', '03.05.2021 16:54', '03.05.2021 16:54'),
  ('Наталья', '1984-11-12', '03.05.2021 16:54', '03.05.2021 16:54'),
  ('Александр', '1985-05-20', '03.05.2021 16:54', '03.05.2021 16:54'),
  ('Сергей', '1988-02-14', '03.05.2021 16:54', '03.05.2021 16:54'),
  ('Иван', '1998-01-12', '03.05.2021 16:54', '03.05.2021 16:54'),
  ('Мария', '1992-08-29', '03.05.2021 16:54', '03.05.2021 16:54');
 
UPDATE users
	SET created_at = STR_TO_DATE(created_at, '%d.%m.%Y %k:%i'),
 		updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %k:%i');
  
 ALTER TABLE users
	MODIFY COLUMN created_at DATETIME,
	MODIFY COLUMN updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
 
/*------------------------------------------------------------------------------------------------------------------------------------------------*/ 


DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
 
INSERT INTO storehouses_products (storehouse_id, product_id, value) VALUES
  (1, 4563, 0),
  (1, 450, 4500),
  (1, 3120, 0),
  (1, 78, 789),
  (1, 878, 600),
  (1, 789, 1); 

SELECT id, value, IF(value > 0, 0, 1) AS sort FROM storehouses_products ORDER BY value;
SELECT * FROM storehouses_products ORDER BY IF(value > 0, 0, 1), value;
 

/*------------------------------------------------------------------------------------------------------------------------------------------------*/ 

SELECT name FROM users WHERE DATE_FORMAT(birthday_at, '%M') IN ('may', 'august'); 

/*------------------------------------------------------------------------------------------------------------------------------------------------*/ 

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  UNIQUE unique_name(name(10))
);

INSERT INTO catalogs (id, name) VALUES
  (1, 'Процессоры'),
  (2, 'Материнские платы'),
  (5, 'Видеокарты');

SELECT id, name, FIELD(id, 5, 1, 2) AS pos FROM catalogs WHERE id IN (5, 1, 2);
SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY FIELD(id, 5, 1, 2);