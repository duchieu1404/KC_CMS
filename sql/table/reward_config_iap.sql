/*
 Navicat Premium Data Transfer

 Source Server         : Cooking Crush Dev
 Source Server Type    : MySQL
 Source Server Version : 50735
 Source Host           : 14.225.3.172:3306
 Source Schema         : cooking_crush_002

 Target Server Type    : MySQL
 Target Server Version : 50735
 File Encoding         : 65001

 Date: 24/11/2023 10:35:29
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for reward_config_iap
-- ----------------------------
DROP TABLE IF EXISTS `reward_config_iap`;
CREATE TABLE `reward_config_iap`  (
  `code_reward` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `name_reward` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `value_reward` int(11) NULL DEFAULT NULL,
  `id_reward` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id_reward`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 31 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
