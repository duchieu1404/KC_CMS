CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_tester_save`(in V_IN_ADMIN_ID int
, in V_IN_TESTER_ID int
, in V_IN_DEVICE_ID varchar(100)
, in V_IN_OS_TYPE varchar(100)
, in V_IN_VERSION varchar(20)
, in V_IN_STATUS int
, in V_IN_NOTE varchar(1000))
BEGIN
	
	if(V_IN_TESTER_ID = -1) then 
				insert into user_test(device_id, os_type,version,note,status)
				values(V_IN_DEVICE_ID,V_IN_OS_TYPE,V_IN_VERSION,V_IN_NOTE, V_IN_STATUS)
				on duplicate key update
				device_id = values(device_id),
				os_type = values(os_type),
				version = values(version),
				note = values(note),
				status = values(status);
	else
			
			insert into user_test(id,device_id, os_type,version,note,status)
				values(V_IN_TESTER_ID,V_IN_DEVICE_ID,V_IN_OS_TYPE,V_IN_VERSION,V_IN_NOTE, V_IN_STATUS)
				on duplicate key update
				device_id = values(device_id),
				os_type = values(os_type),
				version = values(version),
				note = values(note),
				status = values(status);
				
	end if;

	commit;
	select 0 status, "OK" msg;
	
END