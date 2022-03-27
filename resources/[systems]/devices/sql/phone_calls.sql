CREATE TABLE IF NOT EXISTS `phone_calls` (
	`source_number` CHAR(10) NOT NULL COLLATE 'latin1_bin',
	`target_number` CHAR(10) NOT NULL COLLATE 'latin1_bin',
	`time_stamp` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
	`duration` SMALLINT(5) UNSIGNED NOT NULL DEFAULT '0',
	INDEX `phone_calls_target_number` (`target_number`) USING BTREE,
	INDEX `phone_calls_source_number` (`source_number`) USING BTREE
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;