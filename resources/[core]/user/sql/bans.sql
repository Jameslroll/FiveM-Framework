CREATE TABLE IF NOT EXISTS `bans` (
	`start_time` DATETIME NOT NULL DEFAULT sysdate(),
	`unbanned` BIT(1) NOT NULL DEFAULT b'0',
	`duration` INT(10) UNSIGNED NOT NULL DEFAULT '24',
	`reason` CHAR(255) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`steam` CHAR(15) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`license` CHAR(40) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`license2` CHAR(40) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`discord` CHAR(18) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`endpoint` CHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`xbl` CHAR(16) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`live` CHAR(15) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`tokens` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci'
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;
