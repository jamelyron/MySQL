USE vk

SELECT DISTINCT firstname FROM users;

ALTER TABLE profiles
ADD COLUMN is_active BIT DEFAULT 1;
UPDATE profiles
SET
	is_active = 0
WHERE (birthday + INTERVAL 18 YEAR) > NOW();
SELECT * FROM profiles
WHERE is_active = 0
ORDER BY birthday;

UPDATE messages
	SET created_at='2022-05-02 04:06:29'
	WHERE id = 4;

DELETE FROM messages
WHERE created_at > now();