CREATE TABLE IF NOT EXISTS `properties` (
	`id` INT(10) UNSIGNED NOT NULL,
	`character_id` INT(10) UNSIGNED NULL DEFAULT NULL,
	`purchase_at` TIMESTAMP NULL DEFAULT NULL,
	`due_at` TIMESTAMP NULL DEFAULT NULL,
	`paid_amount` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`due_amount` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`total_amount` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`keys` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_bin',
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `id_UNIQUE` (`id`) USING BTREE,
	INDEX `properties_character_id` (`character_id`) USING BTREE,
	CONSTRAINT `property_character_id` FOREIGN KEY (`character_id`) REFERENCES `characters` (`id`) ON UPDATE RESTRICT ON DELETE RESTRICT,
	CONSTRAINT `keys` CHECK (json_valid(`keys`))
)
COLLATE='utf8mb3_general_ci'
ENGINE=InnoDB
;
