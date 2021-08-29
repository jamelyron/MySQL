
DROP TABLE IF EXISTS comments;
CREATE TABLE comments(
	id SERIAL,
    user_id BIGINT UNSIGNED NOT NULL,
    media_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT NOW(),
   
    FOREIGN KEY (media_id) REFERENCES vk.media(id),
   	FOREIGN KEY (user_id) REFERENCES vk.users(id)

);


DROP TABLE IF EXISTS music;
CREATE TABLE music(
	id SERIAL,
	name VARCHAR(150),
	size INT,
	metadata JSON,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS albums;
CREATE TABLE albums(
	id SERIAL,
	media_id BIGINT UNSIGNED NOT NULL,
  
	PRIMARY KEY (id, media_id),
    FOREIGN KEY (id) REFERENCES vk.media_types(id),
    FOREIGN KEY (media_id) REFERENCES vk.music(id)
);
	