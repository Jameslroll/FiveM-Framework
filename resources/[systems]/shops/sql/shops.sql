CREATE TABLE IF NOT EXISTS `shops` (
	`id` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_bin',
	`storage` INT(10) UNSIGNED NULL DEFAULT NULL,
	`prices` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_bin',
	`containers` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_bin',
	`decorations` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_bin',
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `shops_id_unique` (`id`) USING BTREE,
	INDEX `shops_id` (`id`) USING BTREE,
	INDEX `shops_storage` (`storage`) USING BTREE,
	CONSTRAINT `shops_storage` FOREIGN KEY (`storage`) REFERENCES `containers` (`id`) ON UPDATE NO ACTION ON DELETE SET NULL,
	CONSTRAINT `prices` CHECK (json_valid(`prices`)),
	CONSTRAINT `containers` CHECK (json_valid(`containers`)),
	CONSTRAINT `decorations` CHECK (json_valid(`decorations`))
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;
