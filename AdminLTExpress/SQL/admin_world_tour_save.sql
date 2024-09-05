CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_world_tour_save`(in V_IN_EVENT_ID int,
in V_IN_STATUS int,
in V_IN_TIME_FROM varchar(20),
in V_IN_TIME_TO varchar(20),
in V_IN_TIME_SHOW_FROM varchar(20),
in V_IN_TIME_SHOW_TO varchar(20),
in V_IN_EVT_POPUP_COPY varchar(100),
in V_IN_FILE_URL varchar(2000),
in V_IN_FILE_VERSION varchar(100))
LB_SAVE:BEGIN
	DECLARE x_event_id int;
	DECLARE x_cur_time_from varchar(20);
	DECLARE x_cur_time_to varchar(20);
	DECLARE x_file_url varchar(2000);
	DECLARE x_file_version varchar(100);
	
	if(V_IN_EVENT_ID is null or V_IN_EVENT_ID = 0 or V_IN_EVENT_ID = -1) then 
		set V_IN_FILE_URL:= "https://statics.imsoft.vn/files/Crush/TestVersion/WorldTour/data.json";
				set V_IN_FILE_VERSION:= 103060;
	
			insert into world_tour_config(time_from,time_to,status, evt_copy,show_from,show_to,file_url,file_version)
			values(V_IN_TIME_FROM,V_IN_TIME_TO,V_IN_STATUS,V_IN_EVT_POPUP_COPY,V_IN_TIME_SHOW_FROM, V_IN_TIME_SHOW_TO,V_IN_FILE_URL,V_IN_FILE_VERSION);
			
			set x_event_id = LAST_INSERT_ID();
			


				call world_tour_get_rand(x_event_id);	
			call world_tour_create_table_all(x_event_id);
			
			leave LB_SAVE;
	
	end if;
	
	update world_tour_config set
				 time_from = V_IN_TIME_FROM
				,time_to= V_IN_TIME_TO
				,status= V_IN_STATUS
				,evt_copy = V_IN_EVT_POPUP_COPY
				,show_from=V_IN_TIME_SHOW_FROM
				,show_to = V_IN_TIME_SHOW_TO
				,file_url = V_IN_FILE_URL
				,file_version = V_IN_FILE_VERSION 
				
	where id = V_IN_EVENT_ID limit 1;

	

	

	commit;
	
END