CREATE TABLE IF NOT EXISTS `outfits` (
	`character_id` INT(10) UNSIGNED NOT NULL,
	`name` TINYTEXT NOT NULL COLLATE 'utf8mb4_general_ci',
	`appearance` TEXT NOT NULL COLLATE 'utf8mb4_general_ci',
	`time_stamp` TIMESTAMP NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
	PRIMARY KEY (`character_id`, `name`(100)) USING BTREE,
	UNIQUE INDEX `outfits_unique_key` (`character_id`, `name`(100)) USING BTREE,
	INDEX `outfits_character_id` (`character_id`) USING BTREE,
	INDEX `outfits_name` (`name`(100)) USING BTREE,
	CONSTRAINT `outfits_character_id` FOREIGN KEY (`character_id`) REFERENCES `characters` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;
