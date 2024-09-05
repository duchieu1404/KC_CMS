CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_event_popup_get_all`()
BEGIN
	
	select id,os_type,version,utils_format_datetime(show_from) show_from, utils_format_datetime(show_to) show_to, check_type,force_view,asset_url,note,status,bundle_name,
	promote_iap_cfg promote_iap_cnf ,promote_bundle_cfg promote_bundle_cnf, template_type, img_url,data,order_by,show_map_count,ignore_users, only_users,show_condition
	,relate_event_id,duplicate_from
	
	
from event_popup order by id desc;
END