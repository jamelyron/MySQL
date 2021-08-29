
START TRANSACTION;
INSERT INTO sample.users (SELECT * FROM shop.users WHERE shop.users.id = 1);
COMMIT;


CREATE OR REPLACE VIEW v AS 
  SELECT products.name AS p_name, catalogs.name AS c_name 
    FROM products,catalogs 
      WHERE products.catalog_id = catalogs.id;


DELIMITER //

DROP FUNCTION IF EXISTS hello//
CREATE FUNCTION hello() RETURNS TEXT DETERMINISTIC
BEGIN
  RETURN CASE
      WHEN "06:00" <= CURTIME() AND CURTIME() < "12:00" THEN "Доброе утро"
      WHEN "12:00" <= CURTIME() AND CURTIME() < "18:00" THEN "Добрый День"
      WHEN "18:00" <= CURTIME() AND CURTIME() < "00:00" THEN "Добрый вечер"
      ELSE "Доброй ночи"
    END;
END //

DELIMITER ;


DELIMITER //

CREATE TRIGGER desc_and_name_check_before_insert BEFORE INSERT ON products FOR EACH ROW
BEGIN
  IF NEW.name IS NULL AND NEW.description IS NULL
    THEN SIGNAL sqlstate '45001' set message_text = "products name or description can not be NULL"; 
  end if;
END; //

CREATE desc_and_name_check_before_update BEFORE UPDATE ON products FOR EACH ROW
BEGIN
  IF NEW.name IS NULL AND NEW.description IS NULL
    THEN SIGNAL sqlstate '45001' set message_text = "products name or description can not be NULL"; 
  end if;
END; //

DELIMITER //

CREATE PROCEDURE rec_fib(num INT, OUT result INT)
BEGIN
  DECLARE num_1 INT;
  DECLARE num_2 INT;

  IF (num=0) THEN
    SET result=0;
  ELSEIF (num=1) then
    SET result=1;
  ELSE
    CALL rec_fib(num-1,num_1);
    CALL rec_fib(num-2,num_2);
    SET result=(num_1 + num_2);
  END IF;
END//