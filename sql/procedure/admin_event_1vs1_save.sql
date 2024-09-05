CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_event_1vs1_save`(in V_IN_EVENT_ID int,
in V_IN_STATUS int,
in V_IN_TIME_FROM varchar(20),
in V_IN_TIME_TO varchar(20),
in V_MEMBER int,
in V_IN_TIME_SHOW_FROM varchar(20),
in V_IN_TIME_SHOW_TO varchar(20),
in V_MAX_SCORE smallint
)
LB_SAVE:BEGIN
	DECLARE x_event_id int;
	DECLARE x_cur_time_from varchar(20);
	DECLARE x_cur_time_to varchar(20);
	
	-- trường hợp insert 
	if(V_IN_EVENT_ID is null or V_IN_EVENT_ID = 0 or V_IN_EVENT_ID = -1) then 
	
			insert into event_1vs1_config(time_from,time_to,status,show_from,show_to,member,max_score )
			values(V_IN_TIME_FROM,V_IN_TIME_TO,V_IN_STATUS,V_IN_TIME_SHOW_FROM, V_IN_TIME_SHOW_TO
,V_MEMBER ,V_MAX_SCORE);
			set x_event_id = LAST_INSERT_ID();
			
			leave LB_SAVE;
	
	end if;
 --  trường hợp update 
	update event_1vs1_config set
				 time_from = V_IN_TIME_FROM
				,time_to= V_IN_TIME_TO
				,status= V_IN_STATUS 
				,member = V_MEMBER 
				,show_from=V_IN_TIME_SHOW_FROM
				,show_to = V_IN_TIME_SHOW_TO
				,max_score = V_MAX_SCORE
	where id = V_IN_EVENT_ID limit 1;
	 
	commit;
	

END