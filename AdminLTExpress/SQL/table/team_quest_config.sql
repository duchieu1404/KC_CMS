CREATE TABLE `team_quest_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time_from` datetime DEFAULT NULL,
  `time_to` datetime DEFAULT NULL,
  `status` varchar(255) DEFAULT '0' COMMENT '0 : temp ; 1 : actived ; 2 : rewarded',
  `show_from` datetime DEFAULT NULL,
  `show_to` datetime DEFAULT NULL,
  `time_will_reward` datetime DEFAULT NULL,
  `count_by` int(11) DEFAULT NULL COMMENT '0 : coin, 1 cus, 2 like, 3 dish',
  `event_name` varchar(255) DEFAULT NULL,
  `prev_event_id` int(11) DEFAULT '13' COMMENT 'Event id active ngay trước',
  `evt_copy` varchar(255) DEFAULT NULL,
  `event_popup_ids` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=170
DEFAULT CHARSET=utf8mb4;
