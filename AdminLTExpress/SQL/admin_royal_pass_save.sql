CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_royal_pass_save`(in V_IN_EVENT_ID int,
in V_IN_STATUS int,
in V_IN_TIME_FROM varchar(20),
in V_IN_TIME_TO varchar(20),
in V_IN_TIME_SHOW_FROM varchar(20),
in V_IN_TIME_SHOW_TO varchar(20),
in V_IN_KEY_BUNDLE varchar(100),
in V_USER_IDS varchar(100),
in V_VERSION varchar(20))
LB_SAVE:BEGIN
	DECLARE x_event_id int;
	DECLARE x_cur_time_from varchar(20);
	DECLARE x_cur_time_to varchar(20);
	
	if(V_IN_EVENT_ID is null or V_IN_EVENT_ID = 0 or V_IN_EVENT_ID = -1) then 
	
			insert into event_royal_pass_config(time_from,time_to,status,show_from,show_to, key_bundle,user_ids,valid_version)
			values(V_IN_TIME_FROM,V_IN_TIME_TO,V_IN_STATUS,V_IN_TIME_SHOW_FROM, V_IN_TIME_SHOW_TO,V_IN_KEY_BUNDLE,V_USER_IDS,V_VERSION);
			-- set x_event_id = LAST_INSERT_ID();
			-- update team_quest_config set  time_will_reward = DATE_ADD(time_to,INTERVAL 1 MINUTE)  where id = x_event_id limit 1;
			leave LB_SAVE;
	
	end if;
	
	update event_royal_pass_config set
				 time_from = V_IN_TIME_FROM
				,time_to= V_IN_TIME_TO
				,status= V_IN_STATUS
				,show_from=V_IN_TIME_SHOW_FROM
				,show_to = V_IN_TIME_SHOW_TO
				,key_bundle = V_IN_KEY_BUNDLE
				,user_ids = V_USER_IDS
				,valid_version = V_VERSION
				
	where id = V_IN_EVENT_ID limit 1;
	commit;
END