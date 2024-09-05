CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_event_champion_tournament_save`(in V_IN_EVENT_ID int,
																				in V_IN_STATUS int,
																				in V_IN_TIME_FROM varchar(20),
																				in V_IN_TIME_TO varchar(20),
																				in V_IN_COUNT_BY int,
																				in V_IN_TIME_SHOW_FROM varchar(20),
																				in V_IN_TIME_SHOW_TO varchar(20))
LB_SAVE:BEGIN

	DECLARE x_event_id int; 
	
	if(V_IN_EVENT_ID is null or V_IN_EVENT_ID = 0 or V_IN_EVENT_ID = -1) then 
	
			insert into event_champion_tournament_config(time_from,time_to,status,show_from,show_to,count_by )
																						values(V_IN_TIME_FROM,V_IN_TIME_TO,V_IN_STATUS,V_IN_TIME_SHOW_FROM, V_IN_TIME_SHOW_TO,V_IN_COUNT_BY);
			set x_event_id = LAST_INSERT_ID(); 
			update event_champion_tournament_config set  time_will_reward = DATE_ADD(time_to,INTERVAL 1 MINUTE)  where id = x_event_id limit 1;
			leave LB_SAVE;
	
	end if;
	
	update event_champion_tournament_config set
				 time_from = V_IN_TIME_FROM
				,time_to= V_IN_TIME_TO
				,status= V_IN_STATUS
				,time_will_reward = date_add(time_to,INTERVAL 1 MINUTE)
				,count_by = V_IN_COUNT_BY
				,show_from=V_IN_TIME_SHOW_FROM
				,show_to = V_IN_TIME_SHOW_TO
				where id = V_IN_EVENT_ID limit 1; 
	
	commit;
	

END