CREATE TABLE IF NOT EXISTS `factions` (
	`character_id` INT(10) UNSIGNED NOT NULL,
	`name` VARCHAR(50) NOT NULL COLLATE 'latin1_swedish_ci',
	`group` VARCHAR(50) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
	`level` INT(11) NOT NULL DEFAULT '0',
	`join_time` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
	`update_time` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
	`fields` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_bin',
	INDEX `factions_name` (`name`) USING BTREE,
	INDEX `factions_character_id` (`character_id`) USING BTREE,
	INDEX `factions_group` (`group`) USING BTREE,
	CONSTRAINT `factions_character_id` FOREIGN KEY (`character_id`) REFERENCES `characters` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE,
	CONSTRAINT `fields` CHECK (json_valid(`fields`))
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;