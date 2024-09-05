CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_team_quest_save`(in V_IN_EVENT_ID int,
in V_IN_STATUS int,
in V_IN_TIME_FROM varchar(20),
in V_IN_TIME_TO varchar(20),
in V_IN_COUNT_BY int,
in V_IN_PREV_EVENT_ID int,
in V_IN_TIME_SHOW_FROM varchar(20),
in V_IN_TIME_SHOW_TO varchar(20),
in V_IN_EVT_POPUP_COPY varchar(100))
LB_SAVE:BEGIN
	DECLARE x_event_id int;
	DECLARE x_cur_time_from varchar(20);
	DECLARE x_cur_time_to varchar(20);
	
	
	if(V_IN_EVENT_ID is null or V_IN_EVENT_ID = 0 or V_IN_EVENT_ID = -1) then 
	
			insert into team_quest_config(time_from,time_to,status, evt_copy,show_from,show_to,count_by , prev_event_id)
			values(V_IN_TIME_FROM,V_IN_TIME_TO,V_IN_STATUS,V_IN_EVT_POPUP_COPY,V_IN_TIME_SHOW_FROM, V_IN_TIME_SHOW_TO,V_IN_COUNT_BY,V_IN_PREV_EVENT_ID);
			set x_event_id = LAST_INSERT_ID();
			
			update team_quest_config set  time_will_reward = DATE_ADD(time_to,INTERVAL 1 MINUTE)  where id = x_event_id limit 1;
			
			call team_quest_create_table_all(x_event_id);


			
			leave LB_SAVE;
	
	end if;
	
	update team_quest_config set
				 time_from = V_IN_TIME_FROM
				,time_to= V_IN_TIME_TO
				,status= V_IN_STATUS
				,evt_copy = V_IN_EVT_POPUP_COPY
				,time_will_reward = date_add(time_to,INTERVAL 1 MINUTE)
				,prev_event_id = V_IN_PREV_EVENT_ID
				
				,count_by = V_IN_COUNT_BY
				,show_from=V_IN_TIME_SHOW_FROM
				,show_to = V_IN_TIME_SHOW_TO
				
	where id = V_IN_EVENT_ID limit 1;
	
	call team_quest_create_table_all(V_IN_EVENT_ID);
	

	

	commit;
	

END