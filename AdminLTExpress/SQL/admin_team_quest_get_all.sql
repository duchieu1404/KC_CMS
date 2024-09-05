CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_team_quest_get_all`()
BEGIN
	select 
			id,
			utils_format_datetime(time_from) time_from,
			utils_format_datetime(time_to) time_to,
			status,
			utils_format_datetime(show_from) show_from,
			utils_format_datetime(show_to) show_to,
			utils_format_datetime(time_will_reward) time_will_reward,
			evt_copy,
			count_by,
			event_popup_ids,
			prev_event_id
			
			
from team_quest_config order by id desc;

END