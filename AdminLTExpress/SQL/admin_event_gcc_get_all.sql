CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_event_gcc_get_all`()
BEGIN
	select 
			id,
			utils_format_datetime(time_from) time_from,
			utils_format_datetime(time_to) time_to,
			rest_ids,
			status,
			mess_end,
			utils_format_datetime(show_from) show_from,
			utils_format_datetime(show_to) show_to,
			utils_format_datetime(time_will_reward) time_will_reward,
			evt_copy,
			event_popup_ids
			
			
from event_config order by id desc;

END