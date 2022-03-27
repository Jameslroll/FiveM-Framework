CREATE TRIGGER IF NOT EXISTS `characters_before_insert` BEFORE INSERT ON `characters` FOR EACH ROW BEGIN
	DECLARE n VARCHAR(50);
	SET n = '';
	
	WHILE n = '' OR (SELECT COUNT(*) FROM `characters` WHERE phone_number=n)=1 DO
		SET n = CONCAT(
			ROUND(RAND() * 8 + 1),
			ROUND(RAND() * 9),
			ROUND(RAND() * 9),
			ROUND(RAND() * 9),
			ROUND(RAND() * 9),
			ROUND(RAND() * 9),
			ROUND(RAND() * 9),
			ROUND(RAND() * 9),
			ROUND(RAND() * 9),
			ROUND(RAND() * 9)
		);
	END WHILE;
	
	SET NEW.phone_number = n;
	SET n = '';
	
	WHILE n = '' OR (SELECT COUNT(*) FROM `characters` WHERE license_text=n)=1 DO
		SET n = CONCAT(
			get_random_text(get_numbers(), 3),
			get_random_text(get_numbers(), 3),
			get_random_text(get_numbers(), 3)
		);
	END WHILE;
	
	SET NEW.license_text = n;
END