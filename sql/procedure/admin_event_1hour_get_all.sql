CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_event_1hour_get_all`()
BEGIN
	select 
			id,
			utils_format_datetime(time_from) time_from,
			utils_format_datetime(time_to) time_to,status,
			utils_format_datetime(show_from) show_from,
			utils_format_datetime(show_to) show_to,  
			member   
from event_1hour_config order by id desc;

END