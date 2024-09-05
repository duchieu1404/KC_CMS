CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_event_gcc_save`(in V_IN_EVENT_ID int,
in V_IN_STATUS int,
in V_IN_TIME_FROM varchar(20),
in V_IN_TIME_TO varchar(20),
in V_IN_REST_IDS varchar(20),
in V_IN_EVT_POPUP_COPY varchar(100))
LB_SAVE:BEGIN
	DECLARE x_event_id int;
	DECLARE x_cur_time_from varchar(20);
	DECLARE x_cur_time_to varchar(20);
	
	
	if(V_IN_EVENT_ID is null or V_IN_EVENT_ID = 0 or V_IN_EVENT_ID = -1) then 
	
			insert into event_config(time_from,time_to,rest_ids,status, evt_copy,show_from,show_to)
			values(V_IN_TIME_FROM,V_IN_TIME_TO,V_IN_REST_IDS,V_IN_STATUS,V_IN_EVT_POPUP_COPY,V_IN_TIME_FROM, V_IN_TIME_TO );
			set x_event_id = LAST_INSERT_ID();
			
			update event_config set  time_will_reward = DATE_ADD(time_to,INTERVAL 1 MINUTE)  where id = x_event_id limit 1;
			
			call event_create_table_rest_all(x_event_id);
		  call  event_popup_create_by_event_gcc(x_event_id);
			
			insert into push_event_gcc(event_id) values(x_event_id);

			
			leave LB_SAVE;
	
	end if;
	
	update event_config set
				 time_from = V_IN_TIME_FROM
				,time_to= V_IN_TIME_TO
				,rest_ids= V_IN_REST_IDS
				,status= V_IN_STATUS
				,evt_copy = V_IN_EVT_POPUP_COPY
				,time_will_reward = date_add(time_to,INTERVAL 1 MINUTE)
				,show_from = V_IN_TIME_FROM
				,show_to = V_IN_TIME_TO
	
	where id = V_IN_EVENT_ID limit 1;
	
	call event_create_table_rest_all(V_IN_EVENT_ID);
	
	call  event_popup_create_by_event_gcc(V_IN_EVENT_ID);
	

	commit;
	

END