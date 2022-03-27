ALTER TABLE `phone_conversations`
	ADD CONSTRAINT `phone_conversations_last_message_id` FOREIGN KEY IF NOT EXISTS (`last_message_id`) REFERENCES `phone_messages` (`id`) ON UPDATE RESTRICT ON DELETE SET NULL,
	ADD CONSTRAINT `phone_conversations_source_character_id` FOREIGN KEY IF NOT EXISTS (`source_character_id`) REFERENCES `characters` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE,
	ADD CONSTRAINT `phone_conversations_target_character_id` FOREIGN KEY IF NOT EXISTS (`target_character_id`) REFERENCES `characters` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE
;

ALTER TABLE `phone_messages`
	ADD CONSTRAINT `phone_messages_conversation_id` FOREIGN KEY IF NOT EXISTS (`conversation_id`) REFERENCES `phone_conversations` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE,
	ADD CONSTRAINT `phone_messages_source_character_id` FOREIGN KEY IF NOT EXISTS (`source_character_id`) REFERENCES `characters` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE,
	ADD CONSTRAINT `phone_messages_target_character_id` FOREIGN KEY IF NOT EXISTS (`target_character_id`) REFERENCES `characters` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE
;