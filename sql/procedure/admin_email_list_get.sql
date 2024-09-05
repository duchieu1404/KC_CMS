CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_email_list_get`(in V_IN_ADMIN_ID int,
in V_IN_USER_ID int,
in V_IN_PAGE int)
BEGIN
  
	
	DECLARE x_offset int;
	set x_offset:= V_IN_PAGE* 20;
	
	select a.id, utils_format_datetime(a.time_send) time_send ,
	title,content,email_type,gift,data_etx,is_deleted,is_read,is_claimed,utils_format_datetime(expire_time) expire_time,sent_by
	from email_user a
	where user_id = V_IN_USER_ID
order by a.id desc
	limit x_offset,20;
	
	commit;
END