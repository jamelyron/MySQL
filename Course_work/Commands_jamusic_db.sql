
use jamusic;


-- 1 Скрипты характерных выборок
-- 1.1 стандартные JOIN'ы
-- 1.1.1 Вывести пользователя

SELECT firstname, lastname, email, phone, gender, birthday, country 
	FROM users
		JOIN profiles ON users.id = profiles.user_id
	WHERE users.id = 1;

-- 1.1.2 Список треков пользователя

SELECT my_music.user_id, track_name
	FROM my_music
		JOIN users ON my_music.user_id = users.id
		JOIN tracks t ON t.id = my_music.my_tracks
	WHERE my_music.user_id = 1;

-- 1.2 JOIN'ы треков
-- 1.2.1 Список треков и жанров автора

SELECT author_name, track_name, style_name
  FROM tracks
    JOIN author ON tracks.author_id = author.id
    JOIN styles_tracks ON tracks.style_track_id = styles_tracks.id
  WHERE author.id = 1;

-- 1.2.2 Список треков в альбоме
 
SELECT album_name, track_name, author_name
 	FROM tracks 
 		JOIN albums ON tracks.albums_id = albums.id 
 		JOIN author ON tracks.author_id = author.id
 	WHERE albums.id = 1;

-- 1.2.3 Список треков по жанру
 
 SELECT style_name, track_name, author_name
 	FROM tracks
 		JOIN styles_tracks ON tracks.style_track_id = styles_tracks.id
 		JOIN author ON tracks.author_id = author.id
 	WHERE style_track_id = 1;
 
 -- 2 представления
 -- 2.1 Пользователи с действующей подпиской
 
 CREATE or replace VIEW view_sub_now
AS
	select id, firstname, lastname, email, phone, country, start_sub, end_sub
	FROM users u
		JOIN subscription_pay sub ON u.id = sub.users_id
	WHERE
	end_sub > now();

select *
from view_subscription
where id = 1;

-- 2.2 пользователи, купившие подписку в этом году

 CREATE or replace VIEW view_sub_lastyear
AS
	select id, firstname, lastname, email, phone, country, start_sub, end_sub
	FROM users u
		JOIN subscription_pay sub ON u.id = sub.users_id
	WHERE
	start_sub > DATE_SUB(NOW(), INTERVAL 1 year) and start_sub < now();

select *
from view_sub_lastyear;

-- 3 хранимые процедуры / триггеры
-- 3.1 немного поправил под себя предоставленную на курсе процедуру

DROP PROCEDURE IF EXISTS `sp_add_user`;

DELIMITER $$

CREATE PROCEDURE `sp_add_user`(firstname varchar(100), lastname varchar(100), email
varchar(100), phone varchar(12), password_hash VARCHAR(100), country varchar(50),
    gender CHAR(1),
    birthday DATE,
	photo_id BIGINT,
    created_at DATETIME,
OUT tran_result varchar(200))

BEGIN
	DECLARE `_rollback` BOOL DEFAULT 0;
		DECLARE code varchar(100);
		DECLARE error_string varchar(100);
	DECLARE last_user_id int;

DECLARE CONTINUE HANDLER FOR SQLEXCEPTION

begin
	SET `_rollback` = 1;
	GET stacked DIAGNOSTICS CONDITION 1
	code = RETURNED_SQLSTATE, error_string = MESSAGE_TEXT;
	set tran_result := concat('Error occured. Code: ', code, '. Text: ', error_string);
end;

START TRANSACTION;
	INSERT INTO users (firstname, lastname, email, phone, password_hash, country)
		VALUES (firstname, lastname, email, phone, password_hash, country);
	INSERT INTO profiles (user_id, gender, birthday, photo_id, created_at)
		VALUES (last_insert_id(), gender, birthday, photo_id, created_at);
	IF `_rollback` THEN
		ROLLBACK;
	ELSE
		set tran_result := 'ok';
		COMMIT;
	END IF;

END$$

DELIMITER ;

call sp_add_user('New', 'User', 'new87@mail.com', 454545456, 'asdhjsadhjk123213jkl123', 'Russia', 'M', '1994-04-23', 1, now(), @tran_result);
select @tran_result;

-- 3.2 добавление трека в список своих треков

DROP PROCEDURE IF EXISTS `give_me_new_tracks`;

DELIMITER $$

CREATE PROCEDURE `my_new_tracks`(user_id bigint, my_tracks bigint)

BEGIN 
	INSERT INTO my_music (user_id, my_tracks)
		VALUES (user_id, my_tracks)
END$$

DELIMITER ;

call my_new_tracks(1, 500);


-- 3.3 Показать 5 рандомных треков, которых нет у пользователя

DROP PROCEDURE IF EXISTS rand_tracks;
DELIMITER //
CREATE PROCEDURE rand_tracks(IN call_id bigint)
BEGIN

	SELECT not_music_media.metadata, track_name, author_name
	  FROM tracks
		JOIN not_music_media ON tracks.track_picture_id = not_music_media.id 
 		JOIN author ON tracks.author_id = author.id
	 WHERE tracks.id not in (SELECT my_music.my_tracks FROM my_music WHERE my_music.user_id IN (call_id) ORDER BY my_music.user_id)
	 order by rand()	
	 LIMIT 5;

END //
DELIMITER ;


call rand_tracks(1);

