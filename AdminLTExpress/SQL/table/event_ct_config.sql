CREATE TABLE `event_ct_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time_from` datetime DEFAULT NULL,
  `time_to` datetime DEFAULT NULL,
  `lead_1` varchar(4000) DEFAULT NULL,
  `status` varchar(255) DEFAULT '0' COMMENT '0 : temp ; 1 : actived ; 2 : rewarded',
  `show_from` datetime DEFAULT NULL,
  `show_to` datetime DEFAULT NULL,
  `time_will_reward` datetime DEFAULT NULL,
  `count_by` int(11) DEFAULT NULL COMMENT '0 : coin, 1 cus, 2 like, 3 dish',
  `event_name` varchar(255) DEFAULT NULL,
  `join_require` int(11) DEFAULT NULL COMMENT 'Số lượng count_by cần thiết để join event',
  `join_reward` text,
  `max_rest_id` int(11) DEFAULT '13',
  `has_all_boost` int(11) DEFAULT '0',
  `evt_copy` varchar(255) DEFAULT NULL,
  `event_popup_ids` varchar(255) DEFAULT NULL,
  `champion_rest` int(11) DEFAULT '13' COMMENT 'Id nhà hàng sử dụng khi champion',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=359
DEFAULT CHARSET=utf8mb4;
