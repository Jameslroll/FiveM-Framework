CREATE TABLE IF NOT EXISTS `logs` (
	`time_stamp` TIMESTAMP NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
	`resource` CHAR(16) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`source` INT(10) UNSIGNED NULL DEFAULT NULL,
	`target` INT(10) UNSIGNED NULL DEFAULT NULL,
	`verb` CHAR(16) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`noun` CHAR(16) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`extra` VARCHAR(256) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`transaction` INT(11) NULL DEFAULT NULL,
	`pos_x` FLOAT NOT NULL DEFAULT '0',
	`pos_y` FLOAT NOT NULL DEFAULT '0',
	`pos_z` FLOAT NOT NULL DEFAULT '0',
	INDEX `logs_time_stamp` (`time_stamp`) USING BTREE,
	INDEX `logs_source` (`source`) USING BTREE,
	INDEX `logs_target` (`target`) USING BTREE,
	INDEX `logs_resource` (`resource`) USING BTREE,
	INDEX `logs_verb` (`verb`) USING BTREE,
	INDEX `logs_noun` (`noun`) USING BTREE,
	CONSTRAINT `logs_source_id` FOREIGN KEY (`source`) REFERENCES `users` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE,
	CONSTRAINT `logs_target_id` FOREIGN KEY (`target`) REFERENCES `users` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
ROW_FORMAT=DYNAMIC
;
