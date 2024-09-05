CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_event_kr_get_all`()
BEGIN
	select 
			id,
			utils_format_datetime(time_from) time_from,
			utils_format_datetime(time_to) time_to,
			status,
			utils_format_datetime(show_from) show_from,
			utils_format_datetime(show_to) show_to,
			count_by 
			
from event_kr_config order by id desc;

END