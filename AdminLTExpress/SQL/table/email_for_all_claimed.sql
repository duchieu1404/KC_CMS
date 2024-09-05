CREATE TABLE `email_for_all_claimed` (
  `user_id` bigint(20) NOT NULL,
  `email_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`,`email_id`)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4;
