CREATE TABLE IF NOT EXISTS `slots` (
	`id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
	`container_id` INT(10) UNSIGNED NULL DEFAULT NULL,
	`slot_id` TINYINT(3) UNSIGNED NOT NULL,
	`item_id` INT(10) UNSIGNED NOT NULL,
	`quantity` MEDIUMINT(8) UNSIGNED NOT NULL DEFAULT '1',
	`durability` FLOAT UNSIGNED NULL DEFAULT NULL,
	`nested_container_id` INT(10) UNSIGNED NULL DEFAULT NULL,
	`fields` TEXT NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`last_update` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `slots_id` (`id`) USING BTREE,
	INDEX `slots_nested_container_id` (`nested_container_id`) USING BTREE,
	INDEX `slots_item_id` (`item_id`) USING BTREE,
	INDEX `slots_container_id` (`container_id`) USING BTREE,
	CONSTRAINT `slots_container_id` FOREIGN KEY (`container_id`) REFERENCES `containers` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE,
	CONSTRAINT `slots_item_id` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE,
	CONSTRAINT `slots_nested_container_id` FOREIGN KEY (`nested_container_id`) REFERENCES `containers` (`id`) ON UPDATE RESTRICT ON DELETE SET NULL
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
ROW_FORMAT=DYNAMIC
;
