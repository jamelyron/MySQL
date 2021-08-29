USE vk;

SELECT 
	from_user_id,
	concat(u.firstname, ' ', u.lastname) as name,
	count(*) AS 'count'
FROM messages m JOIN users u ON u.id = m.from_user_id WHERE to_user_id = 1 GROUP BY from_user_id ORDER BY count(*) DESC LIMIT 1;


SELECT count(*) 
	FROM likes WHERE media_id IN (SELECT id FROM media WHERE user_id IN (SELECT user_id FROM profiles AS p WHERE  YEAR(CURDATE()) - YEAR(birthday) < 10));

SELECT gender, count(*)
	FROM (SELECT user_id AS USER,(SELECT gender FROM vk.profiles WHERE user_id = user) AS gender FROM likes) AS dummy GROUP BY gender;
	
