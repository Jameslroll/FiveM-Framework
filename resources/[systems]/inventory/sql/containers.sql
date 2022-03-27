CREATE TABLE IF NOT EXISTS `containers` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	`sid` CHAR(12) NULL DEFAULT NULL COLLATE 'ascii_general_ci',
	`character_id` INT(10) UNSIGNED NULL DEFAULT NULL,
	`slot_id` BIGINT(20) UNSIGNED NULL DEFAULT NULL,
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `id_UNIQUE` (`id`) USING BTREE,
	UNIQUE INDEX `container_sid_UNIQUE` (`sid`) USING BTREE,
	INDEX `container_character_id` (`character_id`) USING BTREE,
	INDEX `container_sid` (`sid`) USING BTREE,
	INDEX `container_slot_Id` (`slot_id`) USING BTREE,
	CONSTRAINT `containers_character_id` FOREIGN KEY (`character_id`) REFERENCES `characters` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
ROW_FORMAT=DYNAMIC
;