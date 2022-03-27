CREATE FUNCTION IF NOT EXISTS `get_random_text`(
	`input_characters` VARCHAR(35),
	`output_length` TINYINT
)
RETURNS varchar(35) CHARSET utf8
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
BEGIN
	DECLARE n VARCHAR(35);
	DECLARE i SMALLINT;
	SET n = '';
	SET i = 0;
	
	WHILE i < output_length DO
		SET i = i + 1;
		SET n = CONCAT(n, SUBSTRING(input_characters, ROUND(RAND() * (LENGTH(input_characters) - 1)) + 1, 1));
	END WHILE;

	RETURN n;
END