CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_royal_pass_get_all`()
BEGIN
	select 
			id,
			utils_format_datetime(time_from) time_from,
			utils_format_datetime(time_to) time_to,
			status,
			utils_format_datetime(show_from) show_from,
			utils_format_datetime(show_to) show_to,
			is_push_last_hour,
			key_bundle,
			user_ids,
			valid_version
			
from event_royal_pass_config order by id desc;

END