CREATE TABLE IF NOT EXISTS `jobs_sessions` (
	`job_id` VARCHAR(50) NOT NULL COLLATE 'latin1_swedish_ci',
	`character_id` INT(10) UNSIGNED NOT NULL,
	`level` INT(11) NOT NULL DEFAULT '0',
	`start_time` TIMESTAMP NULL DEFAULT NULL,
	`end_time` TIMESTAMP NULL DEFAULT NULL,
	`was_cached` BIT(1) NOT NULL DEFAULT b'0',
	INDEX `jobs_sessions_character_id` (`character_id`) USING BTREE,
	INDEX `jobs_sessions_job_id` (`job_id`) USING BTREE,
	CONSTRAINT `jobs_sessions_character_id` FOREIGN KEY (`character_id`) REFERENCES `characters` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;