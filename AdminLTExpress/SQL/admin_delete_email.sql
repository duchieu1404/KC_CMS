CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_delete_email`(in V_IN_ADMIN_ID int,
in V_IN_EMAIL_ID int)
LB_DEL:BEGIN  
	delete from email_user where id = V_IN_EMAIL_ID and is_read = 0 and is_claimed = 0;
	select 0 status, "OK" msg, '{}' data;	
END