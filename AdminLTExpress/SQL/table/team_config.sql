CREATE TABLE `team_config` (
  `id` int(11) NOT NULL,
  `create_team_price` varchar(100) DEFAULT NULL,
  `min_level` int(11) DEFAULT '20',
  `curr_week_rank` int(11) DEFAULT NULL,
  `curr_month_rank` int(11) DEFAULT NULL,
  `time_ask_heart` int(11) DEFAULT NULL COMMENT 'Number of second between two times send ask heart',
  `time_ask_boost` int(11) DEFAULT NULL COMMENT 'Number of second between two times send ask boost',
  `time_keep_heart` int(11) DEFAULT '300',
  `time_keep_boost` int(11) DEFAULT '300',
  `time_ask_coin` int(11) DEFAULT '0',
  `time_keep_coin` int(11) DEFAULT '300',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4;
