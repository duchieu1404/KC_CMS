CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_change_log_event_royal_pass`(in V_IN_USER_ID int, IN V_PAGE_SIZE INT, IN V_PAGE INT)
LB_OUT: BEGIN 

IF (V_PAGE IS NULL ) THEN 
 SET V_PAGE := 0;
END IF ;

IF (V_PAGE_SIZE IS NULL) THEN
	SET V_PAGE_SIZE := 10;
END IF;

SELECT id, 
user_id, 
event_id,
step,
utils_format_datetime(time_client)  time_client, 
current_score,
type, 
action,
action_values,
utils_format_datetime(time_server)  time_server  
FROM event_royal_pass_user_data_details 
WHERE user_id = V_IN_USER_ID order by time_server desc limit  V_PAGE,V_PAGE_SIZE ;

END