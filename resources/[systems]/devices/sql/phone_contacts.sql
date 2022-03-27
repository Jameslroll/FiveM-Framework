CREATE TABLE IF NOT EXISTS `phone_contacts` (
	`character_id` INT(10) UNSIGNED NOT NULL,
	`number` VARCHAR(10) NOT NULL COLLATE 'latin1_swedish_ci',
	`name` VARCHAR(32) NOT NULL COLLATE 'latin1_swedish_ci',
	`color` TINYINT(3) UNSIGNED NOT NULL DEFAULT '0',
	`favorite` BIT(1) NOT NULL DEFAULT b'0',
	`avatar` VARCHAR(2048) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
	`notes` TINYTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	UNIQUE INDEX `phone_contacts_UNIQUE` (`character_id`, `number`) USING BTREE,
	INDEX `phone_contacts_character_id` (`character_id`) USING BTREE,
	CONSTRAINT `contacts_character_id` FOREIGN KEY (`character_id`) REFERENCES `characters` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;
