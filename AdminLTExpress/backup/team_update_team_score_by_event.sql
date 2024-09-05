CREATE DEFINER=`root`@`localhost` PROCEDURE `team_update_team_score_by_event`(IN `V_IN_EVENT_ID` int,IN `V_IN_REST_ID` int,IN `V_IN_TEAM_ID` int,IN `NEW_SCORE` int)
BEGIN
	DECLARE x_table_name_postfix varchar(20);

	set x_table_name_postfix := concat(V_IN_EVENT_ID, "_", V_IN_REST_ID);

 	set @sql_update_total_score_for_team = CONCAT("update event_data_team_",x_table_name_postfix," set total_score = ",
 	NEW_SCORE ," WHERE team_id = ",V_IN_TEAM_ID); 	 
 	
	PREPARE smpt from @sql_update_total_score_for_team;
	EXECUTE smpt;
	 	
	select 0 status, "OK" msg, '{}' data;
 
END