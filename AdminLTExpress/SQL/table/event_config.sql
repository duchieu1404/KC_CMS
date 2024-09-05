CREATE TABLE `event_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time_from` datetime DEFAULT NULL,
  `time_to` datetime DEFAULT NULL,
  `rest_ids` varchar(100) DEFAULT NULL,
  `total_0` bigint(20) DEFAULT '0',
  `total_1` bigint(20) DEFAULT '0',
  `total_2` bigint(20) DEFAULT '0',
  `lead_0` varchar(4000) DEFAULT NULL,
  `lead_1` varchar(4000) DEFAULT NULL,
  `lead_2` varchar(4000) DEFAULT NULL,
  `icon_url` varchar(2000) DEFAULT NULL,
  `status` varchar(255) DEFAULT '0' COMMENT '0 : temp ; 1 : actived ; 2 : rewarded',
  `mess_end` varchar(1000) DEFAULT NULL,
  `show_from` datetime DEFAULT NULL,
  `show_to` datetime DEFAULT NULL,
  `time_will_reward` datetime DEFAULT NULL,
  `evt_copy` varchar(255) DEFAULT NULL,
  `event_popup_ids` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=400
DEFAULT CHARSET=utf8mb4;
