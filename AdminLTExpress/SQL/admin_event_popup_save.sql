CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_event_popup_save`(in V_IN_ADMIN_ID int
, in V_IN_EVENT_ID int
, in V_IN_OS_TYPE varchar(100)
, in V_IN_VERSION varchar(20)
,in V_IN_SHOW_FROM varchar(100)
,in V_IN_SHOW_TO varchar(100)
,in V_IN_CHECK_TYPE int
,in V_IN_FORCE_VIEW int
,in V_IN_ASSET_URL varchar(2000)
,in V_IN_BUNDLE_NAME varchar(100)
, in V_IN_STATUS int
, in V_IN_NOTE varchar(1000)
, in V_IN_IAP varchar(1000)
, in V_IN_BUNDLE varchar(1000)
, in V_IN_IMG_URL varchar(2000)
,in V_IN_DATA text
,in V_IN_TEMPLATE_TYPE int
,in V_IN_ORDER_BY int
,in V_IN_SHOW_MAP_COUNT int
,in V_IN_ONLY_USERS text
,in V_IN_IGNORE_USERS text
,IN V_IN_SHOW_CODITION text)
BEGIN
	
	if(V_IN_EVENT_ID = -1) then 
				insert into event_popup(os_type,version,show_from,show_to,check_type,force_view,asset_url,bundle_name, status,note,promote_iap_cfg,promote_bundle_cfg,template_type,img_url,data,order_by,show_map_count,only_users,ignore_users,show_condition)
				values(V_IN_OS_TYPE,V_IN_VERSION,V_IN_SHOW_FROM,V_IN_SHOW_To,V_IN_CHECK_TYPE,V_IN_FORCE_VIEW,V_IN_ASSET_URL,V_IN_BUNDLE_NAME,V_IN_STATUS,V_IN_NOTE,V_IN_IAP,V_IN_BUNDLE,V_IN_TEMPLATE_TYPE,V_IN_IMG_URL,V_IN_DATA,V_IN_ORDER_BY,V_IN_SHOW_MAP_COUNT,if(V_IN_ONLY_USERS is null or V_IN_ONLY_USERS = "", null, V_IN_ONLY_USERS),if(V_IN_IGNORE_USERS is null or V_IN_IGNORE_USERS = "", null, V_IN_IGNORE_USERS),V_IN_SHOW_CODITION);
	else
			
			insert into event_popup(id,os_type,version,show_from,show_to,check_type,force_view,asset_url,bundle_name, status,note,promote_iap_cfg,promote_bundle_cfg,template_type,img_url,data,order_by,show_map_count,only_users,ignore_users,show_condition)
				values(V_IN_EVENT_ID,V_IN_OS_TYPE,V_IN_VERSION,V_IN_SHOW_FROM,V_IN_SHOW_To,V_IN_CHECK_TYPE,V_IN_FORCE_VIEW,V_IN_ASSET_URL,V_IN_BUNDLE_NAME,V_IN_STATUS,V_IN_NOTE,V_IN_IAP,V_IN_BUNDLE,V_IN_TEMPLATE_TYPE,V_IN_IMG_URL,V_IN_DATA,V_IN_ORDER_BY,V_IN_SHOW_MAP_COUNT,if(V_IN_ONLY_USERS is null or V_IN_ONLY_USERS = "", null, V_IN_ONLY_USERS),if(V_IN_IGNORE_USERS is null or V_IN_IGNORE_USERS = "", null, V_IN_IGNORE_USERS),V_IN_SHOW_CODITION)
				on duplicate key update
				os_type = values(os_type),
				version = values(version),
				show_from = values(show_from),
					show_from = values(show_from),
					show_to = values(show_to),
					check_type = values(check_type),
						force_view = values(force_view),
							asset_url = values(asset_url),
							bundle_name = values(bundle_name),
				note = values(note),
				promote_iap_cfg = values(promote_iap_cfg),
				promote_bundle_cfg = values(promote_bundle_cfg),
				status = values(status),
				template_type = values(template_type),
				img_url = values(img_url),
				data = values(data),
				order_by = values(order_by),
				show_map_count = values(show_map_count),
				only_users = values(only_users),
				ignore_users = values(ignore_users),
				show_condition = values(show_condition)
				;
				
	end if;

	commit;
	select 0 status, "OK" msg;
	
END