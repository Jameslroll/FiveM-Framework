CREATE TABLE IF NOT EXISTS `phones` (
	`character_id` INT(11) UNSIGNED NOT NULL,
	`phone_number` CHAR(10) NOT NULL COLLATE 'latin1_bin',
	PRIMARY KEY (`phone_number`) USING BTREE,
	UNIQUE INDEX `phones_number_unique` (`phone_number`) USING BTREE,
	INDEX `phones_character_id` (`character_id`) USING BTREE,
	INDEX `phones_phone_number` (`phone_number`) USING BTREE,
	CONSTRAINT `phones_character_id` FOREIGN KEY (`character_id`) REFERENCES `characters` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;
