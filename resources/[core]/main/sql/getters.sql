CREATE FUNCTION IF NOT EXISTS `get_numbers`(
	`output_type` ENUM('num', 'char', 'both')
)
RETURNS varchar(10) CHARSET utf8
LANGUAGE SQL
DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
RETURN '1234567890';

CREATE FUNCTION IF NOT EXISTS `get_letters`(
	`output_type` ENUM('num', 'char', 'both')
)
RETURNS varchar(25) CHARSET utf8
LANGUAGE SQL
DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
RETURN 'QWERYUIOPASDFGHJKLZXCVBNM';

CREATE FUNCTION IF NOT EXISTS `get_alphanumerals`(
	`output_type` ENUM('num', 'char', 'both')
)
RETURNS varchar(35) CHARSET utf8
LANGUAGE SQL
DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
RETURN 'QWERYUIOPASDFGHJKLZXCVBNM1234567890';