DROP DATABASE IF EXISTS JaMusic;
CREATE DATABASE JaMusic;
USE JaMusic;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    email VARCHAR(120) UNIQUE,
    phone BIGINT UNSIGNED UNIQUE,
 	password_hash VARCHAR(100), 
 	country	VARCHAR(50)
) COMMENT 'пользователи';

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
	id SERIAL,
    name VARCHAR(255),
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP
)COMMENT 'расширение пикч';

DROP TABLE IF EXISTS not_music_media;
CREATE TABLE not_music_media(
	id SERIAL,
    media_type_id BIGINT UNSIGNED NOT NULL,
    downloader_id BIGINT UNSIGNED NOT NULL,
  	filename VARCHAR(255),
    size INT,
	metadata JSON,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (downloader_id) REFERENCES users(id),
    FOREIGN KEY (media_type_id) REFERENCES media_types(id)
)COMMENT 'пикчи';

DROP TABLE IF EXISTS `profiles`;
CREATE TABLE `profiles` (
	user_id BIGINT UNSIGNED NOT NULL UNIQUE,
    gender CHAR(1),
    birthday DATE,
	photo_id BIGINT UNSIGNED NULL,
    created_at DATETIME DEFAULT NOW(),
    FOREIGN KEY (photo_id) REFERENCES not_music_media(id)
   )COMMENT 'личный профиль пользователя';

ALTER TABLE `profiles` ADD CONSTRAINT fk_user_id
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT;
   

DROP TABLE IF EXISTS subscription_pay;
CREATE TABLE subscription_pay (
	users_id BIGINT UNSIGNED NOT NULL UNIQUE,	
	start_sub DATE,
	end_sub DATE,
	
	PRIMARY KEY (users_id),
	FOREIGN KEY (users_id) REFERENCES users(id)
)COMMENT 'подписка';


DROP TABLE IF EXISTS albums;
CREATE TABLE albums (
    id            SERIAL,
    album_picture_id BIGINT UNSIGNED NULL,
    album_name    VARCHAR(20),
    release_year  DATE, 
    
    FOREIGN KEY (album_picture_id) REFERENCES not_music_media(id)
)COMMENT 'альбомы';


DROP TABLE IF EXISTS author;
CREATE TABLE author (
    id              SERIAL,
    author_name  VARCHAR(30)
)COMMENT 'авторы';

DROP TABLE IF EXISTS styles_tracks;
CREATE TABLE styles_tracks (
	id SERIAL,
	style_name VARCHAR(50)
)COMMENT 'стили треков';

DROP TABLE IF EXISTS tracks;
CREATE TABLE tracks (
    id SERIAL,
    track_picture_id BIGINT UNSIGNED NULL,
    track_name VARCHAR(50),
    duration FLOAT,
    albums_id BIGINT UNSIGNED NOT NULL,
    author_id BIGINT UNSIGNED NOT NULL,
    style_track_id BIGINT UNSIGNED NOT NULL,
    filename VARCHAR(255),
    size INT,
	metadata JSON,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (track_picture_id) REFERENCES not_music_media(id),
    FOREIGN KEY (albums_id) REFERENCES albums(id),
    FOREIGN KEY (author_id) REFERENCES author(id),
    FOREIGN KEY (style_track_id) REFERENCES styles_tracks(id)    
)COMMENT 'треки';

DROP TABLE IF EXISTS my_music;
CREATE TABLE my_music (
	id SERIAL,
    user_id    BIGINT UNSIGNED NOT NULL,
    my_tracks  BIGINT UNSIGNED NOT NULL,
    
    FOREIGN KEY (user_id) REFERENCES users(id),
	foreign key (my_tracks) references tracks(id)
)COMMENT '"лайки" пользователей';
