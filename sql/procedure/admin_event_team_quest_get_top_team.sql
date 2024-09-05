CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_event_team_quest_get_top_team`(in v_event_id int)
BEGIN
 
set @x_table =  concat("select t.name, tq.* from team_quest_rank_team_",v_event_id,"  tq join  team t on tq.team_id = t.id where tq.rank = 1 and tq.league_id = 6 "); 
-- select @x_table;
		PREPARE stmt FROM @x_table;
		EXECUTE stmt;
END