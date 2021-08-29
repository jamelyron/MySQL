USE Lesson5;

SELECT AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())) AS age FROM users;



SELECT
	DATE_FORMAT(DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(birthday_at), DAY(birthday_at))), '%W') AS day, COUNT(*) AS total
FROM users
GROUP BY day
ORDER BY total DESC;


SELECT ROUND(EXP(SUM(LN(id)))) FROM users WHERE id < 6;