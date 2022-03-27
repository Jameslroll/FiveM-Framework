CREATE TRIGGER IF NOT EXISTS `characters_after_insert` AFTER INSERT ON `characters` FOR EACH ROW BEGIN
	INSERT INTO `licenses` (
		`character_id`,
		`name`
	) VALUES (
		NEW.id,
		'drivers'
	);
END