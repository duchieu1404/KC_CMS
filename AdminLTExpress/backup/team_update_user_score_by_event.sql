CREATE DEFINER=`root`@`localhost` PROCEDURE `team_update_user_score_by_event`(
	in V_IN_EVENT_ID int, in V_IN_REST_ID int, in V_IN_TEAM_ID int, in V_IN_USER_ID int,
	in V_IN_NEW_SCORE int, in V_IN_REASON text, in V_IN_CREATOR text)
BEGIN
	DECLARE x_table_name_postfix varchar(20);

 DECLARE total_score_for_team int;
 DECLARE total_score_user_old int;
	set x_table_name_postfix := concat(V_IN_EVENT_ID, "_", V_IN_REST_ID);
	
		
	set @sql_total_scrore_user_old  = concat("select total_score into @total_score_user_old from event_data_team_detail_",x_table_name_postfix,"  where user_id = ",V_IN_USER_ID,"  and team_id  =  ",V_IN_TEAM_ID);
	
	 PREPARE stmt_user_old FROM @sql_total_scrore_user_old; 
	EXECUTE stmt_user_old;
	
	-- set @total_score_user_update = @total_score_user_old + V_IN_NEW_SCORE;

	SELECT @total_score_user_update;
		set @sql_update = concat("update event_data_team_detail_", x_table_name_postfix, " set total_score = ", (@total_score_user_old + V_IN_NEW_SCORE),
 		" where user_id = ", V_IN_USER_ID, " and team_id = ", V_IN_TEAM_ID);
 	PREPARE stmt FROM @sql_update;
 	EXECUTE stmt; 
	
	# lấy total_score cũ của user 
	
	set @sql_total_scrore_sum_team= concat("SELECT sum(evdata.total_score) into @total_score_for_team from event_data_team_detail_",x_table_name_postfix," as evdata ,  user_recently as ur WHERE evdata.user_id =  ur.id and evdata.team_id  = ",V_IN_TEAM_ID);
	 PREPARE stmt_scrore_sum_team FROM @sql_total_scrore_sum_team; 
		EXECUTE stmt_scrore_sum_team;

 	set @sql_update_total_score_for_team = CONCAT("update event_data_team_",x_table_name_postfix," set total_score = ",
 	@total_score_for_team ," WHERE team_id = ",V_IN_TEAM_ID); 	 
 	
 	PREPARE stmp_total_team FROM @sql_update_total_score_for_team;
 	EXECUTE stmp_total_team;
 	#end update total score for team 

	insert into user_score_changed (user_id, username, event_id, team_id, team_name, value, reason, creator)
 	values (V_IN_USER_ID, (select username from user_recently where id = V_IN_USER_ID),
 		V_IN_EVENT_ID, V_IN_TEAM_ID, (select name from team where id = V_IN_TEAM_ID), V_IN_NEW_SCORE, V_IN_REASON, V_IN_CREATOR);
 	
	select 0 status, "OK" msg, '{}' data;
	
END