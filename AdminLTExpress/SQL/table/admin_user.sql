CREATE TABLE `admin_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `salt` varchar(100) DEFAULT NULL,
  `fullname` varchar(100) DEFAULT NULL,
  `roles` varchar(255) DEFAULT NULL COMMENT '[] array of role : 0 : root ; 1 : user view, 2: user change data, 3 : user delete, 4 ....',
  `created` datetime DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `mobile` varchar(255) DEFAULT NULL,
  `is2FA` int(2) DEFAULT NULL,
  `secret` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 
DEFAULT CHARSET=utf8;
