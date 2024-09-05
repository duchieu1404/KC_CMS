CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_world_tour_get_all`()
BEGIN
	select 
			id,
			utils_format_datetime(time_from) time_from,
			utils_format_datetime(time_to) time_to,
			status,
			utils_format_datetime(show_from) show_from,
			utils_format_datetime(show_to) show_to,
			evt_copy,
			event_popup_ids,
			event_data,
			file_url,
			file_version
			
			
from world_tour_config order by id desc;

END