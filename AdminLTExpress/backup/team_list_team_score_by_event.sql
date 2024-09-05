CREATE DEFINER=`root`@`localhost` PROCEDURE `team_list_team_score_by_event`(
	in V_IN_EVENT_ID int, in V_IN_REST_ID int, in V_PAGE_SIZE int, in V_PAGE_INDEX int)
BEGIN
	DECLARE x_table_name_postfix varchar(20);
	
	set x_table_name_postfix := concat(V_IN_EVENT_ID, "_", V_IN_REST_ID);
	
	set @sql_query := concat(
		"select t.`name` as 'team_name' , ev.total_score , t.id as 'team_id' from event_data_team_", x_table_name_postfix," ev join team t on ev.team_id = t.id;" );
	PREPARE stmt FROM @sql_query;
	EXECUTE stmt;
END