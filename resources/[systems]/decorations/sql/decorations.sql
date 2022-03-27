CREATE TABLE IF NOT EXISTS `decorations` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	`item_id` INT(10) UNSIGNED NOT NULL,
	`character_id` INT(10) UNSIGNED NULL DEFAULT NULL,
	`container_id` INT(10) UNSIGNED NULL DEFAULT NULL,
	`persistent` BIT(1) NOT NULL DEFAULT b'0',
	`variant` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`instance` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`start_time` DATETIME NOT NULL DEFAULT sysdate(),
	`durability` FLOAT NULL DEFAULT NULL,
	`pos_x` FLOAT NOT NULL DEFAULT '0',
	`pos_y` FLOAT NOT NULL DEFAULT '0',
	`pos_z` FLOAT NOT NULL DEFAULT '0',
	`rot_x` FLOAT NOT NULL DEFAULT '0',
	`rot_y` FLOAT NOT NULL DEFAULT '0',
	`rot_z` FLOAT NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `decorations_id_unique` (`id`) USING BTREE,
	INDEX `decorations_character_id` (`character_id`) USING BTREE,
	INDEX `decorations_item_id` (`item_id`) USING BTREE,
	INDEX `decorations_container_id` (`container_id`) USING BTREE,
	CONSTRAINT `decorations_character_id` FOREIGN KEY (`character_id`) REFERENCES `characters` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE,
	CONSTRAINT `decorations_container_id` FOREIGN KEY (`container_id`) REFERENCES `containers` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE,
	CONSTRAINT `decorations_item_id` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;
