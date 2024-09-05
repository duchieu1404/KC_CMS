CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_event_kr_save`(in V_IN_EVENT_ID int,
in V_IN_STATUS int,
in V_IN_TIME_FROM varchar(20),
in V_IN_TIME_TO varchar(20),
in V_IN_COUNT_BY int,
in V_IN_TIME_SHOW_FROM varchar(20),
in V_IN_TIME_SHOW_TO varchar(20))
LB_SAVE:BEGIN
	DECLARE x_event_id int;
	DECLARE x_cur_time_from varchar(20);
	DECLARE x_cur_time_to varchar(20);
	
	-- trường hợp insert 
	if(V_IN_EVENT_ID is null or V_IN_EVENT_ID = 0 or V_IN_EVENT_ID = -1) then 
	
			insert into event_kr_config(time_from,time_to,status,show_from,show_to,count_by )
			values(V_IN_TIME_FROM,V_IN_TIME_TO,V_IN_STATUS,V_IN_TIME_SHOW_FROM, V_IN_TIME_SHOW_TO
,V_IN_COUNT_BY );
			set x_event_id = LAST_INSERT_ID();
			
			leave LB_SAVE;
	
	end if;
 --  trường hợp update 
	update event_kr_config set
				 time_from = V_IN_TIME_FROM
				,time_to= V_IN_TIME_TO
				,status= V_IN_STATUS 
				,count_by = V_IN_COUNT_BY 
				,show_from=V_IN_TIME_SHOW_FROM
				,show_to = V_IN_TIME_SHOW_TO
			 
	where id = V_IN_EVENT_ID limit 1;
	 
	commit;
	

END