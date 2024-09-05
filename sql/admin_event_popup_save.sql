CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_event_popup_save`(IN V_IN_ADMIN_ID INT
, IN V_IN_EVENT_ID INT
, IN V_IN_OS_TYPE VARCHAR(100)
, IN V_IN_VERSION VARCHAR(100)
,IN V_IN_SHOW_FROM VARCHAR(100)
,IN V_IN_SHOW_TO VARCHAR(100)
,IN V_IN_CHECK_TYPE INT
,IN V_IN_FORCE_VIEW INT
,IN V_IN_ASSET_URL VARCHAR(2000)
,IN V_IN_BUNDLE_NAME VARCHAR(100)
, IN V_IN_STATUS INT
, IN V_IN_NOTE VARCHAR(1000)
, IN V_IN_IAP VARCHAR(1000)
, IN V_IN_BUNDLE VARCHAR(1000)
, IN V_IN_IMG_URL VARCHAR(2000)
,IN V_IN_DATA TEXT
,IN V_IN_TEMPLATE_TYPE INT
,IN V_IN_ORDER_BY INT
,IN V_IN_SHOW_MAP_COUNT INT
,IN V_IN_ONLY_USERS TEXT
,IN V_IN_IGNORE_USERS TEXT
,IN V_IN_SHOW_CODITION TEXT)
BEGIN
	
	IF(V_IN_EVENT_ID = -1) THEN 
				INSERT INTO event_popup(os_type,VERSION,show_from,show_to,check_type,force_view,asset_url,bundle_name, STATUS,note,promote_iap_cfg,promote_bundle_cfg,template_type,img_url,DATA,order_by,show_map_count,only_users,ignore_users,show_condition)
				VALUES(V_IN_OS_TYPE,V_IN_VERSION,V_IN_SHOW_FROM,V_IN_SHOW_To,V_IN_CHECK_TYPE,V_IN_FORCE_VIEW,V_IN_ASSET_URL,V_IN_BUNDLE_NAME,V_IN_STATUS,V_IN_NOTE,V_IN_IAP,V_IN_BUNDLE,V_IN_TEMPLATE_TYPE,V_IN_IMG_URL,V_IN_DATA,V_IN_ORDER_BY,V_IN_SHOW_MAP_COUNT,IF(V_IN_ONLY_USERS IS NULL OR V_IN_ONLY_USERS = "", NULL, V_IN_ONLY_USERS),IF(V_IN_IGNORE_USERS IS NULL OR V_IN_IGNORE_USERS = "", NULL, V_IN_IGNORE_USERS),V_IN_SHOW_CODITION);
	ELSE
			
			INSERT INTO event_popup(id,os_type,VERSION,show_from,show_to,check_type,force_view,asset_url,bundle_name, STATUS,note,promote_iap_cfg,promote_bundle_cfg,template_type,img_url,DATA,order_by,show_map_count,only_users,ignore_users,show_condition)
				VALUES(V_IN_EVENT_ID,V_IN_OS_TYPE,V_IN_VERSION,V_IN_SHOW_FROM,V_IN_SHOW_To,V_IN_CHECK_TYPE,V_IN_FORCE_VIEW,V_IN_ASSET_URL,V_IN_BUNDLE_NAME,V_IN_STATUS,V_IN_NOTE,V_IN_IAP,V_IN_BUNDLE,V_IN_TEMPLATE_TYPE,V_IN_IMG_URL,V_IN_DATA,V_IN_ORDER_BY,V_IN_SHOW_MAP_COUNT,IF(V_IN_ONLY_USERS IS NULL OR V_IN_ONLY_USERS = "", NULL, V_IN_ONLY_USERS),IF(V_IN_IGNORE_USERS IS NULL OR V_IN_IGNORE_USERS = "", NULL, V_IN_IGNORE_USERS),V_IN_SHOW_CODITION)
				ON DUPLICATE KEY UPDATE
				os_type = VALUES(os_type),
				VERSION = VALUES(VERSION),
				show_from = VALUES(show_from),
					show_from = VALUES(show_from),
					show_to = VALUES(show_to),
					check_type = VALUES(check_type),
						force_view = VALUES(force_view),
							asset_url = VALUES(asset_url),
							bundle_name = VALUES(bundle_name),
				note = VALUES(note),
				promote_iap_cfg = VALUES(promote_iap_cfg),
				promote_bundle_cfg = VALUES(promote_bundle_cfg),
				STATUS = VALUES(STATUS),
				template_type = VALUES(template_type),
				img_url = VALUES(img_url),
				DATA = VALUES(DATA),
				order_by = VALUES(order_by),
				show_map_count = VALUES(show_map_count),
				only_users = VALUES(only_users),
				ignore_users = VALUES(ignore_users),
				show_condition = VALUES(show_condition)
				;
				
	END IF;

	COMMIT;
	SELECT 0 STATUS, "OK" msg;
	
END