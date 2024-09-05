CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_event_gcc_get_leaderboard`(in V_IN_ADMIN_ID int,
in V_IN_EVENT_ID int, in V_IN_REST_ID int, in V_IN_RANK_TYPE int)
LB_OUT: BEGIN
DECLARE x_table_name varchar(100);
DECLARE x_field_list varchar(200);

case V_IN_RANK_TYPE 
	when 2 then
		set x_table_name:= concat('event_rank_team_total_',V_IN_EVENT_ID,'_',V_IN_REST_ID);
		set x_field_list:= "team_id as id, score, rank, time_update";
	when 1 then
		set x_table_name:= concat('event_rank_global_total_',V_IN_EVENT_ID,'_',V_IN_REST_ID);
		set x_field_list:= "user_id as id, score, rank, time_update";
	when 0 then 
		set x_table_name:= concat('event_rank_global_best_',V_IN_EVENT_ID,'_',V_IN_REST_ID);
		set x_field_list:= "user_id as id, score, rank, time_update";
end case;
	
if(x_table_name is null) then 
	select 0 status, '[]' data;
	LEAVE LB_OUT;
end if;

SET @sql_query = concat( "select ",x_field_list, " from ",x_table_name," order by rank limit 20");
PREPARE stmt FROM @sql_query;
EXECUTE stmt;

END