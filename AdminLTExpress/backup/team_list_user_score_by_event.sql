CREATE DEFINER=`root`@`localhost` PROCEDURE `team_list_user_score_by_event`(
	in V_IN_EVENT_ID int, in V_IN_REST_ID int, in V_PAGE_SIZE int, in V_PAGE_INDEX int)
BEGIN
	DECLARE x_table_name_postfix varchar(20);
	
	set x_table_name_postfix := concat(V_IN_EVENT_ID, "_", V_IN_REST_ID);
	
	set @sql_query := concat(
		"select ur.id as 'user_id', ur.username, ur.fullname, edt.total_score, s.best_score,ur.last_device_id , 
		(select total_score from event_data_team_",x_table_name_postfix," as team_data where t.id = team_data.team_id ) as total_team_score , 
			t.id as 'team_id', t.name as 'team_name', json_extract(other_info, '$.app_version') app_version
		from user_recently ur, (
			select *
			from event_data_", x_table_name_postfix, "
			order by total_score desc
			limit 0,", LEAST(100, v_page_size), "
		) s, team t , event_data_team_detail_", x_table_name_postfix, " edt  
		where s.user_id = ur.id   and edt.user_id = s.user_id and edt.user_id = ur.id and  t.id = edt.team_id
		order by total_score desc");
	PREPARE stmt FROM @sql_query;
	EXECUTE stmt;
END