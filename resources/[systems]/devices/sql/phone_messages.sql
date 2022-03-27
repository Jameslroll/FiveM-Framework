CREATE TABLE IF NOT EXISTS `phone_messages` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	`source_character_id` INT(10) UNSIGNED NOT NULL,
	`target_character_id` INT(10) UNSIGNED NULL DEFAULT NULL,
	`conversation_id` INT(10) UNSIGNED NULL DEFAULT NULL,
	`time_stamp` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
	`scope` VARCHAR(16) NOT NULL COLLATE 'latin1_swedish_ci',
	`text` TEXT NOT NULL COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`id`) USING BTREE,
	INDEX `phone_messages_target_character_id` (`target_character_id`) USING BTREE,
	INDEX `phone_messages_scope` (`scope`) USING BTREE,
	INDEX `phone_messages_id` (`id`) USING BTREE,
	INDEX `phone_messages_conversation_id` (`conversation_id`) USING BTREE,
	INDEX `phone_messages_source_character_id` (`source_character_id`) USING BTREE
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;
