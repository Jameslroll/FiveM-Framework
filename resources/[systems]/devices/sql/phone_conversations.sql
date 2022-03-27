CREATE TABLE IF NOT EXISTS `phone_conversations` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	`last_message_id` INT(10) UNSIGNED NULL DEFAULT NULL,
	`source_character_id` INT(10) UNSIGNED NOT NULL,
	`target_character_id` INT(10) UNSIGNED NOT NULL,
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `phone_conversations_id` (`id`) USING BTREE,
	INDEX `phone_conversations_source_character_id` (`source_character_id`) USING BTREE,
	INDEX `phone_conversations_target_character_id` (`target_character_id`) USING BTREE,
	INDEX `phone_conversations_last_message_id` (`last_message_id`) USING BTREE
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;
