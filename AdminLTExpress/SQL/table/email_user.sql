CREATE TABLE `email_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `title` varchar(1000) CHARACTER SET utf8 DEFAULT NULL,
  `content` text,
  `time_send` datetime DEFAULT NULL,
  `sent_by` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `gift` longtext CHARACTER SET utf8,
  `expire_time` datetime DEFAULT NULL COMMENT 'Thời gian hết hạn của email',
  `email_type` int(11) NOT NULL DEFAULT '0' COMMENT '0 : normal - delete when read, 1: gift : delete after claim; 2: importain : delete after expire ; 3: force set data; 4 : force set no confirm',
  `is_read` int(11) DEFAULT '0' COMMENT 'is user readed email',
  `is_deleted` int(11) DEFAULT '0' COMMENT 'is_deleted email, user will not show it',
  `is_claimed` int(11) DEFAULT '0',
  `is_auto_delete` int(11) NOT NULL DEFAULT '1',
  `user_send_id` int(11) DEFAULT NULL,
  `user_send_avatar_id` int(11) DEFAULT NULL,
  `user_send_avatar_url` varchar(2000) CHARACTER SET utf8 DEFAULT NULL,
  `user_send_fullname` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `tracking_location` varchar(255) CHARACTER SET utf8 DEFAULT 'CMS',
  `data_etx` longtext CHARACTER SET utf8,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `user_id_index` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=31393445
DEFAULT CHARSET=utf8mb4;
